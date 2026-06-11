import 'package:mero_choice_application/features/room/data/models/room_api_model.dart';

abstract interface class IRoomRemoteDataSource {
  Future<RoomApiModel> createRoom(String name, String category);
  Future<RoomApiModel> joinRoom(String pin);
  Future<Map<String, dynamic>> getRoomDetail(String roomId);
}
