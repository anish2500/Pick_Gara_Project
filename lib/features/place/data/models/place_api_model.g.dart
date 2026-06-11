// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaceApiModel _$PlaceApiModelFromJson(Map<String, dynamic> json) =>
    PlaceApiModel(
      placeId: json['_id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      image: json['image'] as String,
      rating: (json['rating'] as num).toDouble(),
      location: json['location'] as String,
      priceRange: json['priceRange'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$PlaceApiModelToJson(PlaceApiModel instance) =>
    <String, dynamic>{
      '_id': instance.placeId,
      'name': instance.name,
      'category': instance.category,
      'image': instance.image,
      'rating': instance.rating,
      'location': instance.location,
      'priceRange': instance.priceRange,
      'description': instance.description,
    };
