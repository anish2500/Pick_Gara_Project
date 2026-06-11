import 'package:equatable/equatable.dart';

class PlaceEntity extends Equatable {
  final String placeId;
  final String name;
  final String category;
  final String image;
  final double rating;
  final String location;
  final String priceRange;
  final String description;

  const PlaceEntity({
    required this.placeId,
    required this.name,
    required this.category,
    required this.image,
    required this.rating,
    required this.location,
    required this.priceRange,
    required this.description,
  });

  @override
  List<Object?> get props => [
    placeId,
    name,
    category,
    image,
    rating,
    location,
    priceRange,
    description,
  ];
}
