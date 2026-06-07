import 'package:mero_choice_application/features/room/data/models/room_api_model.dart';

abstract interface class IRoomRemoteDataSource {
  Future<RoomApiModel> createRoom(String name, String category);
}
