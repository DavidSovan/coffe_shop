import 'package:dio/dio.dart';
import 'package:uc_coffee_shop/core/network/dio.dart';
import 'package:uc_coffee_shop/features/orders/model/order_model.dart';

class OrderService {
  final Dio _dio = DioClient().dio;

  Future<OrderModel> createOrder(
    String accessToken,
    Map<String, dynamic> orderData,
  ) async {
    try {
      final response = await _dio.post(
        '/api/v1/orders/',
        data: orderData,
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200) {
        return OrderModel.fromJson(response.data);
      } else {
        throw Exception('Failed to create order');
      }
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }
}
