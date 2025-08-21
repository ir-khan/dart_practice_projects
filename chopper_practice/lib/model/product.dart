import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
@JsonSerializable()
class Product with _$Product {
  @override
  @JsonKey(name: 'product_id')
  final int productId;
  @override
  final String name;
  @override
  final String description;
  @override
  final double price;
  @override
  final String unit;
  @override
  final String image;
  @override
  final int discount;
  @override
  final bool availability;
  @override
  final String brand;
  @override
  final String category;
  @override
  final double rating;

  Product({
    required this.productId,
    required this.name,
    required this.description,
    required this.price,
    required this.unit,
    required this.image,
    required this.discount,
    required this.availability,
    required this.brand,
    required this.category,
    required this.rating,
  });

  factory Product.fromJson(Map<String, Object?> json) =>
      _$ProductFromJson(json);

  Map<String, Object?> toJson() => _$ProductToJson(this);
}
