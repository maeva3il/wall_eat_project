import 'package:flutter/foundation.dart';
import 'package:wall_eat_project/model/product.dart';
import 'package:wall_eat_project/service/product_service.dart';

class ProductProvider with ChangeNotifier {
  final ProductService _productService = ProductService();
  List<Product> _products = [];
  List<Product> _productsByIds = [];

  List<Product> get products => _products;
  List<Product> get productsByIds => _productsByIds;

  Future<void> fetchProductsByStore(String storeId) async {
    try {
      _products = await _productService.getProductsByStore(storeId);
      notifyListeners();
    } catch (e) {
      debugPrint("Erreur fetchProducts: $e");
    }
  }

  Future<void> fetchProductsByIds(List<String> productIds) async {
    try {
      _productsByIds = [];
      notifyListeners();

      for (String id in productIds) {
        final product = await _productService.getProductById(id);
        if (product != null) {
          _productsByIds.add(product);
        }
      }

      notifyListeners();
    } catch (e) {
      debugPrint("Erreur fetchProductsByIds: $e");
    }
  }

  // Ajoutez les autres méthodes au besoin (add, update, delete)
}