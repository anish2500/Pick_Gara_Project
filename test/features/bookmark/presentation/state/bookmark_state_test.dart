import 'package:flutter_test/flutter_test.dart';
import 'package:mero_choice_application/features/bookmark/presentation/state/bookmark_state.dart';

void main() {
  // Test 5
  test('BookmarkState.isBookmarked returns true for bookmarked place and false otherwise', () {
    const state = BookmarkState(
      bookmarkedIds: {'place_1', 'place_2'},
    );

    expect(state.isBookmarked('place_1'), isTrue);
    expect(state.isBookmarked('place_2'), isTrue);
    expect(state.isBookmarked('place_3'), isFalse);
    expect(state.isBookmarked(''), isFalse);
  });
}
