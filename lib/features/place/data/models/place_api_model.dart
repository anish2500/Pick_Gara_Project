import 'package:json_annotation/json_annotation.dart';
import 'package:mero_choice_application/features/place/domain/entities/place_entity.dart';


part 'place_api_model.g.dart';

@JsonSerializable()
class PlaceApiModel {
  @JsonKey(name: '_id')
  final String placeId;
  final String name;
  final String category;
  final String image;
  final double rating;
  final String location;
  final String priceRange;
  final String description;

  const PlaceApiModel({
    required this.placeId,
    required this.name,
    required this.category,
    required this.image,
    required this.rating,
    required this.location,
    required this.priceRange,
    required this.description,
  });

  factory PlaceApiModel.fromJson(Map<String, dynamic> json) =>
      _$PlaceApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$PlaceApiModelToJson(this);

  PlaceEntity toEntity() => PlaceEntity(
        placeId: placeId,
        name: name,
        category: category,
        image: image,
        rating: rating,
        location: location,
        priceRange: priceRange,
        description: description,
      );
}
