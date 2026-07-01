import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mero_choice_application/core/error/failures.dart';
import 'package:mero_choice_application/core/usecases/usecase.dart';
import 'package:mero_choice_application/features/bookmark/data/repositories/bookmark_repository.dart';
import 'package:mero_choice_application/features/bookmark/domain/repositories/bookmark_repository.dart';
import 'package:mero_choice_application/features/place/domain/entities/place_entity.dart';

final getBookmarkedPlacesUsecaseProvider =
    Provider<GetBookmarkedPlacesUsecase>((ref) {
  return GetBookmarkedPlacesUsecase(ref.read(bookmarkRepositoryProvider));
});

class GetBookmarkedPlacesUsecase
    implements UsecaseWithoutParams<List<PlaceEntity>> {
  final IBookmarkRepository _repo;
  GetBookmarkedPlacesUsecase(this._repo);

  @override
  Future<Either<Failure, List<PlaceEntity>>> call() =>
      _repo.getBookmarkedPlaces();
}
