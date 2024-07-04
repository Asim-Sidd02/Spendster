import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import 'login_screen.dart'; // Login screen

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isSignUpSuccessful = false; // Flag to check if sign up was successful

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark background
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView( // Makes the page scrollable
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Lottie Animation for Welcome
              LottieBuilder.asset(
                'assets/animations/welcome.json', // Replace with your Lottie animation file
                height: 200,
              ),
              const SizedBox(height: 20), // Spacing between the animation and the text
              // Title
              const Text(
                'Create Account',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              // Subtitle
              const Text(
                'Fill in the details below to get started.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 40), // Spacing between the text and the form
              // Name TextField
              TextField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white), // Text color
                decoration: const InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20), // Spacing between fields
              // Email TextField
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.white), // Text color
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20), // Spacing between fields
              // Password TextField
              TextField(
                controller: _passwordController,
                obscureText: true,
                style: const TextStyle(color: Colors.white), // Text color
                decoration: const InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 40), // Spacing between the form and the button
              // Sign Up Button
              ElevatedButton(
                onPressed: () async {
                  try {
                    final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
                      email: _emailController.text.trim(),
                      password: _passwordController.text.trim(),
                    );
                    if (userCredential.user != null) {
                      setState(() {
                        _isSignUpSuccessful = true;
                      });
                      // Show success animation
                      await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          content: LottieBuilder.asset(
                            'assets/animations/success.json', // Replace with your Lottie success animation file
                            repeat: false,
                            onLoaded: (composition) {
                              Future.delayed(composition.duration, () {
                                Navigator.pop(context);
                                // Navigate to Login Screen or another screen
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (context) => LoginScreen()),
                                      (route) => false,
                                );
                              });
                            },
                          ),
                        ),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Sign Up Failed: ${e.toString()}')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black, backgroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Sign up'),
              ),
              const SizedBox(height: 10), // Spacing between the button and the text
              // Already have an account? Log in Text
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()), // Use the alias to reference the correct LoginScreen
                  );
                },
                child: const Text(
                  'Already have an account? Log in',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
