import 'package:flutter/material.dart';
import 'package:uc_coffee_shop/features/orders/model/order_model.dart';
import 'package:uc_coffee_shop/features/orders/services/order_service.dart';

class OrderViewModel extends ChangeNotifier {
  final OrderService _orderService = OrderService();

  OrderModel? _order;
  OrderModel? get order => _order;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<bool> createOrder(
      String accessToken, Map<String, dynamic> orderData) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _order = await _orderService.createOrder(accessToken, orderData);
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
