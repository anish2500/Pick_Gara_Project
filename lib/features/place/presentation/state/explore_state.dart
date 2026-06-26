import 'package:equatable/equatable.dart';
import 'package:mero_choice_application/features/place/domain/entities/place_entity.dart';

enum ExploreStatus { initial, loading, loaded, error }

class ExploreState extends Equatable {
  final ExploreStatus status;
  final List<PlaceEntity> allPlaces;
  final String selectedCategory;
  final String searchQuery;
  final String? errorMessage;

  const ExploreState({
    required this.status,
    this.allPlaces = const [],
    this.selectedCategory = 'all',
    this.searchQuery = '',
    this.errorMessage,
  });

  factory ExploreState.initial() =>
      const ExploreState(status: ExploreStatus.initial);

  // unique categories derived from data, with 'all' always first
  List<String> get categories {
    // Always show these 3 known categories even when no places exist yet
    const known = ['all', 'momo', 'cafe', 'hiking'];
    // Also surface any future categories added to the backend
    final fromData = allPlaces.map((p) => p.category).toSet();
    final extra = fromData.where((c) => !known.contains(c)).toList();
    return [...known, ...extra];
  }

  // applies both category filter and search query
  List<PlaceEntity> get filteredPlaces {
    var result = allPlaces;
    if (selectedCategory != 'all') {
      result = result.where((p) => p.category == selectedCategory).toList();
    }
    if (searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      result = result
          .where(
            (p) =>
                p.name.toLowerCase().contains(q) ||
                p.location.toLowerCase().contains(q) ||
                p.category.toLowerCase().contains(q),
          )
          .toList();
    }
    return result;
  }

  ExploreState copyWith({
    ExploreStatus? status,
    List<PlaceEntity>? allPlaces,
    String? selectedCategory,
    String? searchQuery,
    String? errorMessage,
  }) {
    return ExploreState(
      status: status ?? this.status,
      allPlaces: allPlaces ?? this.allPlaces,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    allPlaces,
    selectedCategory,
    searchQuery,
    errorMessage,
  ];
}
