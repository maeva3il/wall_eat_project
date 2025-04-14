import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wall_eat_project/model/product.dart';

class ProductService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Récupérer tous les produits d'un magasin
  Future<List<Product>> getProductsByStore(String storeId) async {
    try {
      QuerySnapshot snapshot = await _db
          .collection('products')
          .where('storeId', isEqualTo: storeId)
          .get();

      return snapshot.docs.map((doc) {
        return Product.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
    } catch (e) {
      print("Erreur lors de la récupération des produits: $e");
      return [];
    }
  }

    // Récupérer un produit par son ID
  Future<Product?> getProductById(String productId) async {
    try {
      DocumentSnapshot doc = await _db.collection('products').doc(productId).get();

      if (doc.exists) {
        return Product.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      } else {
        return null;
      }
    } catch (e) {
      print("Erreur lors de la récupération du produit par ID : $e");
      return null;
    }
  }

  // Ajouter un nouveau produit
  Future<void> addProduct({
    required String storeId,
    required String name,
    required double price,
    String? description,
    String? imageUrl,
  }) async {
    try {
      await _db.collection('products').add({
        'storeId': storeId,
        'name': name,
        'price': price,
        'description': description ?? '',
        'imageUrl': imageUrl ?? '',
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Erreur lors de l'ajout du produit: $e");
      rethrow;
    }
  }

  // Mettre à jour un produit existant
  Future<void> updateProduct({
    required String productId,
    String? name,
    double? price,
    String? description,
    String? imageUrl,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (name != null) updateData['name'] = name;
      if (price != null) updateData['price'] = price;
      if (description != null) updateData['description'] = description;
      if (imageUrl != null) updateData['imageUrl'] = imageUrl;

      await _db.collection('products').doc(productId).update(updateData);
    } catch (e) {
      print("Erreur lors de la mise à jour du produit: $e");
      rethrow;
    }
  }

  // Supprimer un produit
  Future<void> deleteProduct(String productId) async {
    try {
      await _db.collection('products').doc(productId).delete();
    } catch (e) {
      print("Erreur lors de la suppression du produit: $e");
      rethrow;
    }
  }

  // Écouter les changements en temps réel pour un magasin
  Stream<List<Product>> streamProductsByStore(String storeId) {
    return _db
        .collection('products')
        .where('storeId', isEqualTo: storeId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Product.fromFirestore(
          doc.data(),
          doc.id,
        );
      }).toList();
    });
  }
}