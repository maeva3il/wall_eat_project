import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wall_eat_project/provider/user_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context); // Récupérer les informations de l'utilisateur

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Afficher les informations de l'utilisateur
            userProvider.user != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nom : ${userProvider.user?.displayName ?? 'Non renseigné'}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Email : ${userProvider.user?.email ?? 'Non renseigné'}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'ID Utilisateur : ${userProvider.user?.uid ?? 'Non renseigné'}',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  )
                : const Center(
                    child: Text('Aucun utilisateur connecté'),
                  ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                print('Accéder aux paramètres du profil');
              },
              child: const Text('Paramètres du profil'),
            ),
          ],
        ),
      ),
    );
  }
}
