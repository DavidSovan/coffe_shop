import 'package:dio/dio.dart';
import 'package:uc_coffee_shop/core/network/dio.dart';
import 'package:uc_coffee_shop/features/product/model/product_model.dart';

class ProductService {
  final Dio _dio = DioClient().dio;

  Future<List<ProductModel>> getProducts(String accessToken) async {
    try {
      final response = await _dio.get(
        '/api/v1/products',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200) {
        final List<ProductModel> products = (response.data as List)
            .map(
              (product) => ProductModel(
                id: product['id'],
                name: product['name'],
                price: product['price'].toDouble(),
                imageUrl: product['image_url'],
                description: product['description'],
                available: product['available'],
                createdAt: DateTime.parse(product['created_at']),
                updatedAt: product['updated_at'],
              ),
            )
            .toList();
        return products;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }
}
