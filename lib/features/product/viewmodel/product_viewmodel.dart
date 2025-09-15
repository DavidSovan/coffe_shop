import 'package:flutter/material.dart';
import 'package:uc_coffee_shop/features/product/model/product_model.dart';
import 'package:uc_coffee_shop/features/product/services/product_service.dart';

class ProductViewModel extends ChangeNotifier {
  final ProductService _productService = ProductService();

  List<ProductModel> _products = [];
  List<ProductModel> get products => _products;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> fetchProducts(String accessToken) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _products = await _productService.getProducts(accessToken);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
