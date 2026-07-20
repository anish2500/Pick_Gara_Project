import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mero_choice_application/features/friend/domain/entities/friend_entity.dart';
import 'package:mero_choice_application/features/friend/presentation/pages/friends_list_page.dart';
import 'package:mero_choice_application/features/friend/presentation/state/friend_state.dart';
import 'package:mero_choice_application/features/friend/presentation/view_model/friend_view_model.dart';

class MockFriendViewModel extends FriendViewModel {
  @override
  FriendState build() => const FriendState(
        status: FriendStatus.loaded,
        friends: [
          FriendEntity(
            userId: 'u1',
            fullName: 'Aarav Sharma',
            sharedActivities: 3,
          ),
        ],
        totalFriends: 1,
        totalSharedActivities: 3,
      );

  @override
  Future<void> loadFriends() async {}
}

void main() {
  // Test 5
  testWidgets('FriendsListPage shows total friends count and friend name', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          friendViewModelProvider.overrideWith(MockFriendViewModel.new),
        ],
        child: const MaterialApp(home: FriendsListPage()),
      ),
    );

    await tester.pump();

    expect(find.text('1'), findsOneWidget);
    expect(find.text('FRIENDS'), findsOneWidget);
    expect(find.text('Aarav Sharma'), findsOneWidget);
  });
}
