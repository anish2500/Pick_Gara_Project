import 'package:dartz/dartz.dart';
import 'package:mero_choice_application/core/error/failures.dart';
import 'package:mero_choice_application/features/place/domain/entities/place_entity.dart';

abstract interface class IBookmarkRepository {
  Future<Either<Failure, List<String>>> getBookmarkedIds();
  Future<Either<Failure, bool>> toggleBookmark(String placeId);
  Future<Either<Failure, List<PlaceEntity>>> getBookmarkedPlaces();
}
