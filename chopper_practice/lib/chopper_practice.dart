import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:chopper_practice/model/product.dart';
import 'package:chopper_practice/services/product_service.dart';

final chopper = ChopperClient(
  baseUrl: Uri.parse("https://fake-store-api.mock.beeceptor.com/"),
  services: [ProductService.create()],
);

void getProducts() async {
  final productService = chopper.getService<ProductService>();

  final response = await productService.getProducts();

  if (response.isSuccessful) {
    final List data = jsonDecode(response.body);
    final products = data.map((e) => Product.fromJson(e)).toList();
    print(products.first);
  } else {
    print("Error: ${response.statusCode} - ${response.error}");
  }
}
