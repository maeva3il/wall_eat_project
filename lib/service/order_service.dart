import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:wall_eat_project/model/order.dart' as model;

class OrderService {
  final firestore.FirebaseFirestore _db = firestore.FirebaseFirestore.instance;

  Future<void> addOrder(String userId, List<String> productIds, double total,
      String status) async {
    try {
      final docRef =
          firestore.FirebaseFirestore.instance.collection('orders').doc();

      final orderData = {
        'userId': userId,
        'products': productIds,
        'total': total,
        'status': 'En attente',
        'createdAt': firestore.FieldValue.serverTimestamp(),
      };

      await docRef.set(orderData);
    } catch (e) {
      print("Erreur lors de l'ajout de la commande: $e");
    }
  }

  Future<void> createOrder(model.Order order) async {
    try {
      await _db.collection('orders').add(order.toMap());
    } catch (e) {
      print('Erreur lors de la création de la commande : $e');
      rethrow;
    }
  }

  Future<List<model.Order>> getOrders(String userId) async {
    try {
      final snapshot = await _db
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .get();

      return snapshot.docs
          .map((doc) => model.Order.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print("Erreur lors de la récupération des commandes: $e");
      return [];
    }
  }
}
