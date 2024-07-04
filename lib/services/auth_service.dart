import 'package:spendster/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get a non-default Storage bucket
  final storage = FirebaseStorage.instanceFor(bucket: "gs://spendster-75987.appspot.com");

  User? get currentUser => _auth.currentUser;

  AuthService() {
    _auth.authStateChanges().listen(_handleAuthStateChanged);
  }

  void _handleAuthStateChanged(User? user) async {
    if (user != null) {
      final userDoc = _firestore.collection('users').doc(user.uid);
      final docSnapshot = await userDoc.get();
      if (!docSnapshot.exists) {
        await userDoc.set({
          'email': user.email,
          'displayName': user.displayName,
          'photoUrl': user.photoURL,
          'tag': 'Developer',
        });
      }
    }
  }

  Future<void> updateProfile({
    String? displayName,
    String? email,
    String? tag,
    File? imageFile,
  }) async {
    final user = currentUser;
    if (user == null) {
      throw Exception('User is not logged in');
    }

    // Update display name and email
    if (displayName != null) await user.updateDisplayName(displayName);
    if (email != null) await user.updateEmail(email);

    // Upload profile image to Firebase Storage
    if (imageFile != null) {
      final storageRef = storage.ref('profile_images/${user.uid}');
      await storageRef.putFile(imageFile);
      final imageUrl = await storageRef.getDownloadURL();
      await user.updatePhotoURL(imageUrl);
    }

    // Update the tag in Firestore
    final userDoc = _firestore.collection('users').doc(user.uid);
    await userDoc.update({
      'displayName': displayName,
      'email': email,
      'photoUrl': imageFile != null ? user.photoURL : null,
      'tag': tag,
    });
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = currentUser;
    if (user == null) {
      throw Exception('User is not logged in');
    }

    final cred = EmailAuthProvider.credential(
      email: user.email!,
      password: currentPassword,
    );

    await user.reauthenticateWithCredential(cred);
    await user.updatePassword(newPassword);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Fetch user data from Firestore
  Future<UserModel?> fetchUserData() async {
    final user = currentUser;
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        final tag = data['tag'] as String?;
        return UserModel.fromFirebaseUser(user, tag: tag);
      }
    }
    return null;
  }
}
