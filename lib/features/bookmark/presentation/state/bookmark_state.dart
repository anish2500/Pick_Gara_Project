import 'package:equatable/equatable.dart';

class BookmarkState extends Equatable {
  final Set<String> bookmarkedIds;
  final bool isLoading;

  const BookmarkState({this.bookmarkedIds = const {}, this.isLoading = false});

  factory BookmarkState.initial() => const BookmarkState();

  bool isBookmarked(String placeId) => bookmarkedIds.contains(placeId);

  BookmarkState copyWith({Set<String>? bookmarkedIds, bool? isLoading}) {
    return BookmarkState(
      bookmarkedIds: bookmarkedIds ?? this.bookmarkedIds,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [bookmarkedIds, isLoading];
}
