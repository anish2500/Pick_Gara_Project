import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mero_choice_application/features/bookmark/presentation/page/bookmarks_page.dart';
import 'package:mero_choice_application/features/bookmark/presentation/state/bookmark_state.dart';
import 'package:mero_choice_application/features/bookmark/presentation/view_model/bookmark_view_model.dart';
import 'package:mero_choice_application/features/place/domain/entities/place_entity.dart';

class MockEmptyBookmarkViewModel extends BookmarkViewModel {
  @override
  BookmarkState build() => const BookmarkState();

  @override
  Future<void> loadBookmarkedPlaces() async {}

  @override
  Future<void> loadBookmarks() async {}

  @override
  Future<bool?> toggle(String placeId) async => null;
}

class MockLoadedBookmarkViewModel extends BookmarkViewModel {
  @override
  BookmarkState build() => const BookmarkState(
    bookmarkedPlaces: [
      PlaceEntity(
        placeId: 'p1',
        name: 'Mountain Momo',
        category: 'momo',
        image: '',
        rating: 4.5,
        location: 'Thamel, Kathmandu',
        priceRange: '\$',
        description: 'Delicious momos',
      ),
    ],
    bookmarkedIds: {'p1'},
  );

  @override
  Future<void> loadBookmarkedPlaces() async {}

  @override
  Future<void> loadBookmarks() async {}

  @override
  Future<bool?> toggle(String placeId) async => null;
}

void main() {
  testWidgets('BookmarksPage shows empty state when no bookmarks', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          bookmarkViewModelProvider.overrideWith(
            MockEmptyBookmarkViewModel.new,
          ),
        ],
        child: const MaterialApp(home: BookmarksPage()),
      ),
    );

    await tester.pump();
    expect(find.text('No bookmarks yet'), findsOneWidget);
  });

  testWidgets('BookmarksPage shows place name when bookmarks exist', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          bookmarkViewModelProvider.overrideWith(
            MockLoadedBookmarkViewModel.new,
          ),
        ],
        child: const MaterialApp(home: BookmarksPage()),
      ),
    );

    await tester.pump();

    expect(find.text('Mountain Momo'), findsOneWidget);
    expect(find.text('Thamel, Kathmandu'), findsOneWidget);
  });
}
