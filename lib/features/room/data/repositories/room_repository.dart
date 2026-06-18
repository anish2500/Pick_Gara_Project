import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mero_choice_application/core/error/failures.dart';
import 'package:mero_choice_application/features/place/data/models/place_api_model.dart';
import 'package:mero_choice_application/features/room/data/datasources/remote/room_remote_datasource.dart';
import 'package:mero_choice_application/features/room/data/models/room_api_model.dart';
import 'package:mero_choice_application/features/room/domain/entities/room_detail_entity.dart';
import 'package:mero_choice_application/features/room/domain/entities/room_entity.dart';
import 'package:mero_choice_application/features/room/domain/repositories/room_repository.dart';
import 'package:mero_choice_application/features/vote/data/models/vote_stats_api_model.dart';

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

  @override
  Future<Either<Failure, RoomEntity>> joinRoom(String pin) async {
    try {
      final model = await _remoteDatasource.joinRoom(pin);
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message:
              (e.response?.data is Map ? e.response?.data['message'] : null) ??
              e.message ??
              'Failed to join room',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, RoomDetailEntity>> getRoomDetail(String roomId) async {
    try {
      final data = await _remoteDatasource.getRoomDetail(roomId);

      final roomJson = data['room'] as Map<String, dynamic>;
      final membersRaw = roomJson['members'] as List<dynamic>;
      final memberCount = membersRaw.length;

      final memberIds = membersRaw.map((m) {
        if (m is Map) return (m['_id'] ?? '').toString();
        return m.toString();
      }).toList();

      final roomModel = RoomApiModel.fromJson({
        ...roomJson,
        'members': memberIds,
      });

      final placesRaw = data['places'] as List<dynamic>;

      final places = placesRaw
          .map(
            (p) => PlaceApiModel.fromJson(p as Map<String, dynamic>).toEntity(),
          )
          .toList();

      final voteStats = data['voteStats'] != null
          ? VoteStatsApiModel.fromJson(
              data['voteStats'] as Map<String, dynamic>,
            ).toEntity()
          : null;

      return Right(
        RoomDetailEntity(
          room: roomModel.toEntity(),
          places: places,
          memberCount: memberCount,
          voteStats: voteStats,
        ),
      );
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message:
              (e.response?.data is Map ? e.response?.data['message'] : null) ??
              e.message ??
              'Failed to load room',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteRoom(String roomId) async {
    try {
      await _remoteDatasource.deleteRoom(roomId);
      return const Right(unit);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message:
              (e.response?.data is Map ? e.response?.data['message'] : null) ??
              e.message ??
              'Failed to delete room',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<RoomEntity>>> getActiveRooms() async {
    try {
      final models = await _remoteDatasource.getActiveRooms();
      return Right(models.map((m) => m.toEntity()).toList());
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message:
              (e.response?.data is Map ? e.response?.data['message'] : null) ??
              e.message ??
              'Failed to load rooms',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
