import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mero_choice_application/core/error/failures.dart';
import 'package:mero_choice_application/features/room/data/datasources/remote/room_remote_datasource.dart';
import 'package:mero_choice_application/features/room/domain/entities/room_entity.dart';
import 'package:mero_choice_application/features/room/domain/repositories/room_repository.dart';

final roomRepositoryProvider = Provider<IRoomRepository>((ref) {
  return RoomRepository(
    remoteDatasource: ref.read(roomRemoteDatasourceProvider),
  );
});

class RoomRepository implements IRoomRepository {
  final RoomRemoteDatasource _remoteDatasource;

  RoomRepository({required RoomRemoteDatasource remoteDatasource})
      : _remoteDatasource = remoteDatasource;

  @override
  Future<Either<Failure, RoomEntity>> createRoom(
    String name,
    String category,
  ) async {
    try {
      final model = await _remoteDatasource.createRoom(name, category);
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message:
              (e.response?.data is Map ? e.response?.data['message'] : null) ??
              e.message ??
              'Failed to create room',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
