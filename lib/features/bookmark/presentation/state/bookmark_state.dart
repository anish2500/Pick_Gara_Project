import 'package:equatable/equatable.dart';
import 'package:mero_choice_application/features/place/domain/entities/place_entity.dart';

class BookmarkState extends Equatable {
  final Set<String> bookmarkedIds;
  final bool isLoading;
  final List<PlaceEntity> bookmarkedPlaces; 

  const BookmarkState({this.bookmarkedIds = const {}, this.isLoading = false, this.bookmarkedPlaces = const []});

  factory BookmarkState.initial() => const BookmarkState();

  bool isBookmarked(String placeId) => bookmarkedIds.contains(placeId);

  BookmarkState copyWith({Set<String>? bookmarkedIds, bool? isLoading, List<PlaceEntity>? bookmarkedPlaces}) {
    return BookmarkState(
      bookmarkedIds: bookmarkedIds ?? this.bookmarkedIds,
      isLoading: isLoading ?? this.isLoading,
      bookmarkedPlaces: bookmarkedPlaces ?? this.bookmarkedPlaces
    );
  }

  @override
  List<Object?> get props => [bookmarkedIds, isLoading, bookmarkedPlaces];
}
