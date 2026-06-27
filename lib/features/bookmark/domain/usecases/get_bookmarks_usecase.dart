import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mero_choice_application/core/error/failures.dart';
import 'package:mero_choice_application/features/bookmark/data/repositories/bookmark_repository.dart';
import 'package:mero_choice_application/features/bookmark/domain/repositories/bookmark_repository.dart';

final getBookmarksUsecaseProvider = Provider<GetBookmarksUsecase>((ref) {
  return GetBookmarksUsecase(ref.read(bookmarkRepositoryProvider));
});

class GetBookmarksUsecase {
  final IBookmarkRepository _repo;
  GetBookmarksUsecase(this._repo);
  Future<Either<Failure, List<String>>> call() => _repo.getBookmarkedIds();
}
