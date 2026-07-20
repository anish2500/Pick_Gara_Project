import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mero_choice_application/core/error/failures.dart';
import 'package:mero_choice_application/features/friend/data/datasources/remote/friend_remote_datasource.dart';
import 'package:mero_choice_application/features/friend/domain/entities/friend_entity.dart';
import 'package:mero_choice_application/features/friend/domain/repositories/friend_repository.dart';

final friendRepositoryProvider = Provider<IFriendRepository>((ref) {
  return FriendRepository(
    remoteDatasource: ref.read(friendRemoteDatasourceProvider),
  );
});

class FriendRepository implements IFriendRepository {
  final FriendRemoteDatasource _remote;
  FriendRepository({required FriendRemoteDatasource remoteDatasource})
    : _remote = remoteDatasource;

  @override
  Future<Either<Failure, FriendListResult>> getFriendsWithStats() async {
    try {
      final result = await _remote.getFriendsWithStats();
      return Right(
        FriendListResult(
          stats: result.stats,
          friends: result.friends.map((f) => f.toEntity()).toList(),
        ),
      );
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message:
              (e.response?.data is Map ? e.response?.data['message'] : null) ??
              e.message ??
              'Failed to load friends',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
