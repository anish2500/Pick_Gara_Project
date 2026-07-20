import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mero_choice_application/core/api/api_client.dart';
import 'package:mero_choice_application/core/api/api_endpoints.dart';
import 'package:mero_choice_application/features/friend/data/datasources/friend_datasource.dart';
import 'package:mero_choice_application/features/friend/data/models/friend_api_model.dart';
import 'package:mero_choice_application/features/friend/domain/entities/friend_entity.dart';

final friendRemoteDatasourceProvider = Provider<FriendRemoteDatasource>((ref) {
  return FriendRemoteDatasource(dio: ref.read(apiClientProvider));
});

class FriendRemoteDatasource implements IFriendRemoteDataSource {
  final Dio _dio;

  FriendRemoteDatasource({required Dio dio}) : _dio = dio;

  @override
  Future<({List<FriendApiModel> friends, FriendStatsEntity stats})>
  getFriendsWithStats() async {
    final response = await _dio.get(ApiEndpoints.friends);

    final data = response.data as Map<String, dynamic>;

    final statsJson = data['stats'] as Map<String, dynamic>;

    final stats = FriendStatsEntity(
      totalFriends: statsJson['totalFriends'] as int,
      totalSharedActivities: statsJson['totalSharedActivities'] as int,
    );

    final friendsList = (data['friends'] as List<dynamic>)
        .map((f) => FriendApiModel.fromJson(f as Map<String, dynamic>))
        .toList();

    return (stats: stats, friends: friendsList);
  }
}
