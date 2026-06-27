import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mero_choice_application/core/error/failures.dart';
import 'package:mero_choice_application/features/bookmark/data/datasources/remote/bookmark_remote_datasource.dart';
import 'package:mero_choice_application/features/bookmark/domain/repositories/bookmark_repository.dart';

final bookmarkRepositoryProvider = Provider<IBookmarkRepository>((ref) {
  return BookmarkRepository(
    remoteDatasource: ref.read(bookmarkRemoteDatasourceProvider),
  );
});

class BookmarkRepository implements IBookmarkRepository {
  final BookmarkRemoteDatasource _remote;
  BookmarkRepository({required BookmarkRemoteDatasource remoteDatasource})
    : _remote = remoteDatasource;
  @override
  Future<Either<Failure, List<String>>> getBookmarkedIds() async {
    try {
      return Right(await _remote.getBookmarkedIds());
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message:
              (e.response?.data is Map ? e.response?.data['message'] : null) ??
              e.message ??
              'Failed to load bookmarks',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> toggleBookmark(String placeId) async {
    try {
      return Right(await _remote.toggleBookmark(placeId));
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message:
              (e.response?.data is Map ? e.response?.data['message'] : null) ??
              e.message ??
              'Failed to toggle bookmark',
          statusCode: e.response?.statusCode,
        ),
      );
    }
  }
}
