import 'package:flutter/foundation.dart';
import 'package:wall_eat_project/model/order.dart' as model;
import 'package:wall_eat_project/service/order_service.dart';

class OrderProvider with ChangeNotifier {
  final OrderService _orderService = OrderService();

  List<model.Order> _orders = [];
  List<model.Order> get orders => _orders;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchOrders(String userId) async {
    try {
      _isLoading = true;
      notifyListeners();

      _orders = await _orderService.getOrders(userId);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint("Erreur fetchOrders: $e");
      rethrow;
    }
  }

  Future<void> addOrder(String userId, List<String> productIds, double total, String status) async {
    await _orderService.addOrder(userId, productIds, total, status);
    await fetchOrders(userId); // rafraîchir la liste
  }

  Future<void> createOrder(model.Order order) async {
    await _orderService.createOrder(order);
    await fetchOrders(order.userId);
  }
}