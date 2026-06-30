import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mero_choice_application/core/api/api_client.dart';
import 'package:mero_choice_application/core/api/api_endpoints.dart';
import 'package:mero_choice_application/features/match/data/datasources/match_datasource.dart';
import 'package:mero_choice_application/features/match/data/models/match_api_model.dart';

final matchRemoteDatasourceProvider = Provider<MatchRemoteDatasource>((ref) {
  return MatchRemoteDatasource(dio: ref.read(apiClientProvider));
});


class MatchRemoteDatasource implements IMatchRemoteDataSource {
  final Dio _dio;
  MatchRemoteDatasource({required Dio dio}) : _dio = dio;

  @override
  Future<void> completeRoom(String roomId) async {
    await _dio.post(ApiEndpoints.completeRoom(roomId));
  }

  @override
  Future<List<MatchApiModel>> getCompletedRooms() async {
    final response = await _dio.get(ApiEndpoints.completedRooms);

    final list = response.data['completedRooms'] as List<dynamic>? ?? [];

    return list
        .where((e) => (e as Map<String, dynamic>)['winnerId'] != null)
        .map((e) => MatchApiModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }


}
