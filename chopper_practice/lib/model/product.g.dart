// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
  productId: (json['product_id'] as num).toInt(),
  name: json['name'] as String,
  description: json['description'] as String,
  price: (json['price'] as num).toDouble(),
  unit: json['unit'] as String,
  image: json['image'] as String,
  discount: (json['discount'] as num).toInt(),
  availability: json['availability'] as bool,
  brand: json['brand'] as String,
  category: json['category'] as String,
  rating: (json['rating'] as num).toDouble(),
);

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
  'product_id': instance.productId,
  'name': instance.name,
  'description': instance.description,
  'price': instance.price,
  'unit': instance.unit,
  'image': instance.image,
  'discount': instance.discount,
  'availability': instance.availability,
  'brand': instance.brand,
  'category': instance.category,
  'rating': instance.rating,
};
