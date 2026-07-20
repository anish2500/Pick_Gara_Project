import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mero_choice_application/core/error/failures.dart';
import 'package:mero_choice_application/core/usecases/usecase.dart';
import 'package:mero_choice_application/features/friend/data/repositories/friend_repository.dart';
import 'package:mero_choice_application/features/friend/domain/entities/friend_entity.dart';
import 'package:mero_choice_application/features/friend/domain/repositories/friend_repository.dart';

final getFriendsUsecaseProvider = Provider<GetFriendsUsecase>((ref) {
  return GetFriendsUsecase(ref.read(friendRepositoryProvider));
});

class GetFriendsUsecase implements UsecaseWithoutParams<FriendListResult> {
  final IFriendRepository _repo;
  GetFriendsUsecase(this._repo);

  @override
  Future<Either<Failure, FriendListResult>> call() =>
      _repo.getFriendsWithStats();
}
