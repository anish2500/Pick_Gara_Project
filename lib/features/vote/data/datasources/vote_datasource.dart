import 'package:mero_choice_application/features/vote/data/models/vote_stats_api_model.dart';

abstract interface class IVoteRemoteDataSource {
  Future<VoteStatsApiModel> castVote(
    String roomId,
    String placeId,
    String vote,
  );
}
