import 'package:flutter_test/flutter_test.dart';
import 'package:mero_choice_application/features/friend/domain/entities/friend_entity.dart';
import 'package:mero_choice_application/features/friend/presentation/state/friend_state.dart';

void main() {
  // Test 4
  test('FriendState.copyWith updates specified fields and preserves the rest', () {
    const original = FriendState(
      status: FriendStatus.loaded,
      friends: [
        FriendEntity(
          userId: 'u1',
          fullName: 'Aarav Sharma',
          sharedActivities: 2,
        ),
      ],
      totalFriends: 1,
      totalSharedActivities: 2,
    );

    final updated = original.copyWith(
      totalFriends: 5,
      totalSharedActivities: 8,
    );

    expect(updated.totalFriends, 5);
    expect(updated.totalSharedActivities, 8);
    expect(updated.status, FriendStatus.loaded);   // preserved
    expect(updated.friends.length, 1);              // preserved
    expect(updated.friends.first.fullName, 'Aarav Sharma'); // preserved
  });
}
