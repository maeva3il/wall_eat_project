import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wall_eat_project/screen/home_screen.dart';
import 'package:wall_eat_project/screen/login_screen.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Méthode pour vérifier si l'utilisateur est connecté
  Widget handleAuth() {
    return StreamBuilder<User?>(
      stream: _auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Charge l'écran si en attente
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (snapshot.hasData) {
          return HomeScreen(); // Accéder à la page d'accueil si connecté
        } else {
          return LoginScreen(); // Accéder à la page de login si non connecté
        }
      },
    );
  }

  // Méthode pour s'inscrire
  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Error during sign up: $e");
      return null;
    }
  }

  // Méthode pour se connecter
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Error during sign in: $e");
      return null;
    }
  }

  // Méthode pour se déconnecter
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
