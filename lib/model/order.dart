import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  final String id;
  final String userId;
  final List<String> products; // Liste d'IDs de produits
  final double total;
  final String status;
  final DateTime date;

  Order({
    required this.id,
    required this.userId,
    required this.products,
    required this.total,
    required this.status,
    required this.date,
  });

  factory Order.fromFirestore(Map<String, dynamic> data, String id) {
    return Order(
      id: id,
      userId: data['userId'],
      products: List<String>.from(data['products'] ?? []),
      total: (data['total'] ?? 0).toDouble(),
      status: data['status'] ?? 'Inconnu',
      date: data['createdAt'] != null && data['createdAt'] is Timestamp
        ? (data['createdAt'] as Timestamp).toDate()
        : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'products': products,
      'total': total,
      'status': status,
      'date': date.toIso8601String(),
    };
  }
}
