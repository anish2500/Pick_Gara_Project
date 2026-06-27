import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mero_choice_application/core/error/failures.dart';
import 'package:mero_choice_application/core/usecases/usecase.dart';
import 'package:mero_choice_application/features/bookmark/data/repositories/bookmark_repository.dart';
import 'package:mero_choice_application/features/bookmark/domain/repositories/bookmark_repository.dart';

final toggleBookmarkUsecaseProvider = Provider<ToggleBookmarkUsecase>((ref) {
  return ToggleBookmarkUsecase(ref.read(bookmarkRepositoryProvider));
});

class ToggleBookmarkUsecase implements UsecaseWithParams<bool, String> {
  final IBookmarkRepository _repo;
  ToggleBookmarkUsecase(this._repo);

  @override
  Future<Either<Failure, bool>> call(String params) =>
      _repo.toggleBookmark(params);
}
