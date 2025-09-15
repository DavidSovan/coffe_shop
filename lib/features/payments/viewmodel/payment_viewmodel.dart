import 'package:flutter/foundation.dart';
import 'package:uc_coffee_shop/features/payments/model/payment_model.dart';
import 'package:uc_coffee_shop/features/payments/services/payment_service.dart';

enum PaymentState { idle, creating, pending, completing, completed, error }

class PaymentViewModel extends ChangeNotifier {
  final PaymentService _paymentService = PaymentService();

  PaymentModel? _payment;
  PaymentModel? get payment => _payment;

  PaymentState _state = PaymentState.idle;
  PaymentState get state => _state;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String _selectedMethod = 'credit_card';
  String get selectedMethod => _selectedMethod;

  void selectMethod(String method) {
    _selectedMethod = method;
    notifyListeners();
  }

  void _setState(PaymentState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<bool> createPayment({
    required String accessToken,
    required int userId,
    required int orderId,
    required double amount,
    String currency = 'USD',
    String? method,
  }) async {
    _setState(PaymentState.creating);
    _errorMessage = null;
    try {
      _payment = await _paymentService.createPayment(
        accessToken: accessToken,
        userId: userId,
        orderId: orderId,
        amount: amount,
        currency: currency,
        method: method ?? _selectedMethod,
      );
      _setState(PaymentState.pending);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setState(PaymentState.error);
      return false;
    }
  }

  Future<bool> completePayment({
    required String accessToken,
    required int userId,
    required int orderId,
    required double amount,
    String currency = 'USD',
    String? method,
  }) async {
    _setState(PaymentState.completing);
    _errorMessage = null;
    try {
      _payment = await _paymentService.completePayment(
        accessToken: accessToken,
        userId: userId,
        orderId: orderId,
        amount: amount,
        currency: currency,
        method: method ?? _selectedMethod,
      );
      _setState(PaymentState.completed);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setState(PaymentState.error);
      return false;
    }
  }

  void reset() {
    _payment = null;
    _state = PaymentState.idle;
    _errorMessage = null;
    _selectedMethod = 'credit_card';
    notifyListeners();
  }
}
