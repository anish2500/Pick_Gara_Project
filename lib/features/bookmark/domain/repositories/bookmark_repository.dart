import 'package:dartz/dartz.dart';
import 'package:mero_choice_application/core/error/failures.dart';

abstract interface class IBookmarkRepository {
  Future<Either<Failure, List<String>>> getBookmarkedIds();
  Future<Either<Failure, bool>> toggleBookmark(String placeId);
}
