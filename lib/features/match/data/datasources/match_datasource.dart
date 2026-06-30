import 'package:mero_choice_application/features/match/data/models/match_api_model.dart';

abstract interface class IMatchRemoteDataSource {
  Future<List<MatchApiModel>> getCompletedRooms();
  Future<void> completeRoom(String roomId);
}
