import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_screen.dart'; // FIX: Import HomeScreen for direct navigation

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> signupUser() async {
    try {
      // 1. Try to create a new user
      UserCredential userCred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // 2. Create Firestore user document
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userCred.user!.uid)
          .set({
        "name": nameController.text.trim(),
        "email": emailController.text.trim(),
        "bio": "",
        "photoUrl": null,
        "favorites": [],
        "trips": [],
      });

      // FIX: Replace screen with HomeScreen after successful signup.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );

    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        // If email exists, try to sign in instead
        try {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );
          // FIX: Replace screen with HomeScreen after successful sign-in.
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        } on FirebaseAuthException catch (signInError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(signInError.message ?? "Sign-in failed after user existed")),
          );
        }
      } else {
        // Display other Firebase authentication errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? "An unexpected sign-up error occurred")),
        );
      }
    } catch (e) {
      // Display generic error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Account")),
      body: SingleChildScrollView( // Added to prevent overflow if keyboard is up
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(hintText: "Name")),
            const SizedBox(height: 10), // Added spacing
            TextField(controller: emailController, decoration: const InputDecoration(hintText: "Email")),
            const SizedBox(height: 10), // Added spacing
            TextField(controller: passwordController, obscureText: true, decoration: const InputDecoration(hintText: "Password")),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: signupUser, child: const Text("Sign Up")),
          ],
        ),
      ),
    );
  }
}