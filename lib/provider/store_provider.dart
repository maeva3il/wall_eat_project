import 'package:flutter/foundation.dart';
import 'package:wall_eat_project/model/store.dart';
import 'package:wall_eat_project/service/store_service.dart';

class StoreProvider with ChangeNotifier {
  List<Store> _stores = [];
  final StoreService _storeService = StoreService();

  List<Store> get stores => _stores;

  // 🔁 Récupération des magasins
  Future<void> fetchStores() async {
    _stores = await _storeService.getStores();
    notifyListeners();
  }

  // Ajouter un magasin avec produits
  Future<void> addStore(String name, String address, Map<String, String> productMap) async {
    try {
      await _storeService.addStore(name, address, productMap);
      await fetchStores(); // rechargement
    } catch (e) {
      print("Erreur lors de l'ajout du magasin: $e");
    }
  }
}
