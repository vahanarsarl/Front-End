import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vahanar_front/config/api_config.dart';
import '../models/product_model.dart';

class ProductService {
  final storage = const FlutterSecureStorage();

  // Get all products
  Future<List<Product>> getAllProducts({String? category, String? search, int page = 1, int limit = 10}) async {
    // Build query parameters
    final queryParams = {
      if (category != null) 'category': category,
      if (search != null) 'search': search,
      'page': page.toString(),
      'limit': limit.toString(),
    };

    final uri = Uri.parse(ApiConfig.baseUrl + ApiConfig.products).replace(
      queryParameters: queryParams,
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['products'] as List).map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception(jsonDecode(response.body)['error'] ?? 'Failed to load products');
    }
  }

  // Get product details
  Future<Product> getProductById(String id) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.products}/$id'),
    );

    if (response.statusCode == 200) {
      return Product.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(jsonDecode(response.body)['error'] ?? 'Failed to load product');
    }
  }
}