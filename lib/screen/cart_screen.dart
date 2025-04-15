// cart_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wall_eat_project/provider/cart_provider.dart';
import 'package:wall_eat_project/provider/order_provider.dart';
import 'package:wall_eat_project/provider/user_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartProvider.items.length,
              itemBuilder: (context, index) {
                final item = cartProvider.items[index];
                return ListTile(
                  leading: Image.asset(item.imageUrl, width: 50),
                  title: Text(item.name),
                  subtitle: Text('${item.price}€ x ${item.quantity}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => cartProvider.removeItem(item.productId),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Total: ${cartProvider.totalPrice.toStringAsFixed(2)}€',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (userProvider.user == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Connectez-vous pour commander')),
                );
                return;
              }

              await orderProvider.addOrder(
                userProvider.user!.uid,
                cartProvider.items.map((item) => item.productId).toList(),
                cartProvider.totalPrice,
                'En attente',
              );

              cartProvider.clearCart();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Commande passée avec succès !')),
              );
            },
            child: const Text('Passer la commande'),
          ),
        ],
      ),
    );
  }
}