import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
abstract class Product with _$Product {
  const factory Product({
    @JsonKey(name: 'product_id') required int productId,
    required String name,
    required String description,
    required double price,
    required String unit,
    required String image,
    required int discount,
    required bool availability,
    required String brand,
    required String category,
    required double rating,
  }) = _Product;

  factory Product.fromJson(Map<String, Object?> json) => _$ProductFromJson(json);
}
