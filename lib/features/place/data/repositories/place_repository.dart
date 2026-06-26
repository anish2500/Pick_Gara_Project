import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mero_choice_application/core/error/failures.dart';
import 'package:mero_choice_application/features/place/data/datasources/remote/place_remote_datasource.dart';
import 'package:mero_choice_application/features/place/domain/entities/place_entity.dart';
import 'package:mero_choice_application/features/place/domain/repositories/place_repository.dart';

final placeRepositoryProvider = Provider<IPlaceRepository>((ref) {
  return PlaceRepository(
    remoteDatasource: ref.read(placeRemoteDatasourceProvider),
  );
});

class PlaceRepository implements IPlaceRepository {
  final PlaceRemoteDatasource _remoteDatasource;

  PlaceRepository({required PlaceRemoteDatasource remoteDatasource})
    : _remoteDatasource = remoteDatasource;

  @override
  Future<Either<Failure, List<PlaceEntity>>> getPlaces() async {
    try {
      final models = await _remoteDatasource.getPlaces();
      return Right(models.map((m) => m.toEntity()).toList());
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message:
              (e.response?.data is Map ? e.response?.data['message'] : null) ??
              e.message ??
              'Failed to load places',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
