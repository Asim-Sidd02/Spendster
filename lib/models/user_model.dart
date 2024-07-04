import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoUrl;
  final String? tag;

  UserModel({required this.uid, this.email, this.displayName, this.photoUrl, this.tag});

  // Factory method to create a UserModel from Firebase User
  factory UserModel.fromFirebaseUser(User user, {String? tag}) {
    return UserModel(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoURL,
      tag: tag,
    );
  }
}
