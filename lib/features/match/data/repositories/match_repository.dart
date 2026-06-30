import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mero_choice_application/core/error/failures.dart';
import 'package:mero_choice_application/features/match/data/datasources/remote/match_remote_datasource.dart';
import 'package:mero_choice_application/features/match/domain/entities/match_entity.dart';
import 'package:mero_choice_application/features/match/domain/repositories/match_repository.dart';

final matchRepositoryProvider = Provider<IMatchRepository>((ref) {
  return MatchRepository(
    remoteDatasource: ref.read(matchRemoteDatasourceProvider),
  );
});

class MatchRepository implements IMatchRepository {
  final MatchRemoteDatasource _remote;

  MatchRepository({required MatchRemoteDatasource remoteDatasource})
    : _remote = remoteDatasource;
  @override
  Future<Either<Failure, Unit>> completeRoom(String roomId) async {
    try {
      await _remote.completeRoom(roomId);
      return const Right(unit);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message:
              (e.response?.data is Map ? e.response?.data['message'] : null) ??
              e.message ??
              'Failed to complete room',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MatchEntity>>> getCompletedRooms() async {
    try {
      final models = await _remote.getCompletedRooms();
      return Right(models.map((m) => m.toEntity()).toList());
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message:
              (e.response?.data is Map ? e.response?.data['message'] : null) ??
              e.message ??
              'Failed to load matches',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
