import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mero_choice_application/core/api/api_client.dart';
import 'package:mero_choice_application/core/api/api_endpoints.dart';
import 'package:mero_choice_application/features/vote/data/datasources/vote_datasource.dart';
import 'package:mero_choice_application/features/vote/data/models/vote_stats_api_model.dart';

final voteRemoteDatasourceProvider = Provider<VoteRemoteDatasource>((ref) {
  return VoteRemoteDatasource(dio: ref.read(apiClientProvider));
});


class VoteRemoteDatasource implements IVoteRemoteDataSource {
  final Dio _dio;

  VoteRemoteDatasource({required Dio dio}) : _dio = dio;
  @override
  Future<VoteStatsApiModel> castVote(
    String roomId,
    String placeId,
    String vote,
  ) async {
    final response = await _dio.post(
      ApiEndpoints.voteForRoom(roomId),
      data: {'placeId': placeId, 'vote': vote},
    );

    final statsJson = response.data['voteStats'] as Map<String, dynamic>;
    return VoteStatsApiModel.fromJson(statsJson); 
  }
}
