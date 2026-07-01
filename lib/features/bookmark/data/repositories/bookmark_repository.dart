import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mero_choice_application/core/error/failures.dart';
import 'package:mero_choice_application/features/bookmark/data/datasources/remote/bookmark_remote_datasource.dart';
import 'package:mero_choice_application/features/bookmark/domain/repositories/bookmark_repository.dart';
import 'package:mero_choice_application/features/place/data/models/place_api_model.dart';
import 'package:mero_choice_application/features/place/domain/entities/place_entity.dart';

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

  @override
  Future<Either<Failure, List<PlaceEntity>>> getBookmarkedPlaces() async {
    try {
      final rawList = await _remote.getBookmarkedPlaces();
      final places = rawList
          .map((p) => PlaceApiModel.fromJson(p).toEntity())
          .toList();
      return Right(places);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message:
              (e.response?.data is Map ? e.response?.data['message'] : null) ??
              e.message ??
              'Failed to load bookmarked places',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
