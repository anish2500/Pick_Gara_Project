
import 'package:mero_choice_application/features/friend/data/models/friend_api_model.dart';
import 'package:mero_choice_application/features/friend/domain/entities/friend_entity.dart';

abstract interface class IFriendRemoteDataSource {
  Future<({FriendStatsEntity stats, List<FriendApiModel> friends})>
      getFriendsWithStats();
}
