import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wall_eat_project/provider/order_provider.dart';
import 'package:wall_eat_project/provider/user_provider.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    final userId = Provider.of<UserProvider>(context, listen: false).user?.uid ?? '';
    Provider.of<OrderProvider>(context, listen: false)
        .fetchOrders(userId)
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (orderProvider.orders.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('Aucune commande trouvée')),
      );
    }

    return Scaffold(
      body: ListView.builder(
        itemCount: orderProvider.orders.length,
        itemBuilder: (context, index) {
          final order = orderProvider.orders[index];
          return ListTile(
            title: Text('Commande #${order.id}'),
            subtitle: Text('Total: ${order.total}€ - ${order.status}'),
            trailing: Text(order.date.toString()),
          );
        },
      ),
    );
  }
}
