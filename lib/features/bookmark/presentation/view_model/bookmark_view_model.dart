import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mero_choice_application/features/bookmark/domain/usecases/get_bookmarked_places_usecase.dart';
import 'package:mero_choice_application/features/bookmark/domain/usecases/get_bookmarks_usecase.dart';
import 'package:mero_choice_application/features/bookmark/domain/usecases/toggle_bookmark_usecase.dart';
import 'package:mero_choice_application/features/bookmark/presentation/state/bookmark_state.dart';

final bookmarkViewModelProvider =
    NotifierProvider<BookmarkViewModel, BookmarkState>(BookmarkViewModel.new);

class BookmarkViewModel extends Notifier<BookmarkState> {
  @override
  BookmarkState build() => BookmarkState.initial();

  Future<void> loadBookmarks() async {
    state = state.copyWith(isLoading: true);
    final result = await ref.read(getBookmarksUsecaseProvider).call();
    result.fold(
      (_) => state = state.copyWith(isLoading: false),
      (ids) => state = state.copyWith(
        isLoading: false,
        bookmarkedIds: ids.toSet(),
      ),
    );
  }

  // Returns true = added, false = removed, null = error
  Future<bool?> toggle(String placeId) async {
    // Optimistic update
    final current = Set<String>.from(state.bookmarkedIds);
    final wasBookmarked = current.contains(placeId);
    if (wasBookmarked) {
      current.remove(placeId);
    } else {
      current.add(placeId);
    }
    state = state.copyWith(bookmarkedIds: current);

    bool? outcome;
    final result = await ref.read(toggleBookmarkUsecaseProvider).call(placeId);
    result.fold(
      (_) {
        // Revert on error
        final reverted = Set<String>.from(state.bookmarkedIds);
        if (wasBookmarked) {
          reverted.add(placeId);
        } else {
          reverted.remove(placeId);
        }
        state = state.copyWith(bookmarkedIds: reverted);
        outcome = null;
      },
      (isBookmarked) {
        // Sync with server truth
        final synced = Set<String>.from(state.bookmarkedIds);
        if (isBookmarked) {
          synced.add(placeId);
        } else {
          synced.remove(placeId);
        }
        state = state.copyWith(bookmarkedIds: synced);
        outcome = isBookmarked;
      },
    );
    return outcome;
  }


  Future<void> loadBookmarkedPlaces() async {
  state = state.copyWith(isLoading: true);
  final result = await ref.read(getBookmarkedPlacesUsecaseProvider).call();
  result.fold(
    (_) => state = state.copyWith(isLoading: false),
    (places) => state = state.copyWith(
      isLoading: false,
      bookmarkedPlaces: places,
      bookmarkedIds: places.map((p) => p.placeId).toSet(),
    ),
  );
}

}
