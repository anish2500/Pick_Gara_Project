import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mero_choice_application/core/api/api_client.dart';
import 'package:mero_choice_application/core/api/api_endpoints.dart';
import 'package:mero_choice_application/features/room/data/datasources/room_datasource.dart';
import 'package:mero_choice_application/features/room/data/models/room_api_model.dart';

final roomRemoteDatasourceProvider = Provider<RoomRemoteDatasource>((ref) {
  return RoomRemoteDatasource(dio: ref.read(apiClientProvider));
});

class RoomRemoteDatasource implements IRoomRemoteDataSource {
  final Dio _dio;

  RoomRemoteDatasource({required Dio dio}) : _dio = dio;

  @override
  Future<RoomApiModel> createRoom(String name, String category) async {
    final response = await _dio.post(
      ApiEndpoints.rooms,
      data: {'name': name, 'category': category},
    );
    final roomJson = response.data['room'] as Map<String, dynamic>;
    return RoomApiModel.fromJson(roomJson);
  }

  @override
  Future<RoomApiModel> joinRoom(String pin) async {
    final response = await _dio.post(
      '${ApiEndpoints.rooms}/join',
      data: {'pin': pin},
    );

    final roomJson = response.data['room'] as Map<String, dynamic>;
    return RoomApiModel.fromJson(roomJson);
  }

  @override
  Future<Map<String, dynamic>> getRoomDetail(String roomId) async {
    final response = await _dio.get('${ApiEndpoints.rooms}/$roomId');
    return response.data as Map<String, dynamic>; 
  }
}
