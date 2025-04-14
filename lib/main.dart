import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart'; // <== pour FirebaseAuth
import 'package:wall_eat_project/provider/cart_provider.dart';
import 'package:wall_eat_project/provider/order_provider.dart';
import 'package:wall_eat_project/provider/product_provider.dart';
import 'package:wall_eat_project/provider/store_provider.dart';
import 'package:wall_eat_project/provider/user_provider.dart';
import 'package:wall_eat_project/screen/home_screen.dart';
import 'package:wall_eat_project/screen/login_screen.dart';
import 'package:wall_eat_project/service/auth_service.dart';
import 'package:wall_eat_project/service/order_service.dart';
import 'package:wall_eat_project/service/product_service.dart';
import 'package:wall_eat_project/service/store_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => StoreProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        Provider(create: (_) => AuthService()),
        Provider(create: (_) => StoreService()),
        Provider(create: (_) => ProductService()),
        Provider(create: (_) => OrderService()),
      ],
      child: MaterialApp(
        title: 'Wall Eat Project',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: AuthWrapper(), // On affiche l'écran en fonction de la connexion
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(), // écoute l'état de connexion
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          return const HomeScreen(); // utilisateur connecté
        } else {
          return const LoginScreen(); // utilisateur non connecté
        }
      },
    );
  }
}
