import 'package:dio/dio.dart';
import 'package:uc_coffee_shop/core/network/dio.dart';
import 'package:uc_coffee_shop/features/payments/model/payment_model.dart';

class PaymentService {
  final Dio _dio = DioClient().dio;

  Future<PaymentModel> createPayment({
    required String accessToken,
    required int userId,
    required int orderId,
    required double amount,
    required String currency,
    required String method,
  }) async {
    try {
      final response = await _dio.post(
        '/api/v1/payments/create',
        data: {
          'user_id': userId,
          'order_id': orderId,
          'amount': amount,
          'currency': currency,
          'method': method,
        },
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return PaymentModel.fromJson(response.data);
      } else {
        throw Exception('Failed to create payment');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<PaymentModel> completePayment({
    required String accessToken,
    required int userId,
    required int orderId,
    required double amount,
    required String currency,
    required String method,
  }) async {
    try {
      final response = await _dio.post(
        '/api/v1/payments/complete',
        data: {
          'user_id': userId,
          'order_id': orderId,
          'amount': amount,
          'currency': currency,
          'method': method,
          'status': 'completed',
        },
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return PaymentModel.fromJson(response.data);
      } else {
        throw Exception('Failed to complete payment');
      }
    } catch (e) {
      rethrow;
    }
  }
}
