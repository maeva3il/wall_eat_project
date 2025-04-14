import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wall_eat_project/model/store.dart';

class StoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Ajouter un magasin avec une map de produits (ex: {"productId": "prod1"})
  Future<void> addStore(String name, String address, Map<String, String> productsMap) async {
    try {
      DocumentReference storeRef = await _db.collection('stores').add({
        'name': name,
        'address': address,
        'products': productsMap, // 🔄 enregistre le Map directement
      });

      print("Magasin ajouté avec succès : ${storeRef.id}");
    } catch (e) {
      print("Erreur lors de l'ajout du magasin: $e");
    }
  }

  // 🔁 Récupérer la liste des magasins
  Future<List<Store>> getStores() async {
    try {
      QuerySnapshot storeSnapshot = await _db.collection('stores').get();
      return storeSnapshot.docs
          .map((doc) => Store.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print("Erreur lors de la récupération des magasins: $e");
      return [];
    }
  }
}
