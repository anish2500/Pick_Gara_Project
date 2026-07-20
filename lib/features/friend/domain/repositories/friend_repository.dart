import 'package:dartz/dartz.dart';
import 'package:mero_choice_application/core/error/failures.dart';
import 'package:mero_choice_application/features/friend/domain/entities/friend_entity.dart';

abstract interface class IFriendRepository {
  Future<Either<Failure, FriendListResult>> getFriendsWithStats();
}
