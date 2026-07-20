import 'package:flutter_test/flutter_test.dart';
import 'package:mero_choice_application/features/place/domain/entities/place_entity.dart';
import 'package:mero_choice_application/features/place/presentation/state/explore_state.dart';

PlaceEntity _makePlace({
  required String placeId,
  required String name,
  required String category,
  String location = 'Kathmandu',
}) {
  return PlaceEntity(
    placeId: placeId,
    name: name,
    category: category,
    image: '',
    rating: 4.0,
    location: location,
    priceRange: '\$',
    description: 'Test',
  );
}

void main() {
  final testPlaces = [
    _makePlace(placeId: '1', name: 'Kailash Cafe', category: 'cafe'),
    _makePlace(
      placeId: '2',
      name: 'Hike Shivapuri',
      category: 'hiking',
      location: 'Shivapurit',
    ),
    _makePlace(placeId: '3', name: 'Momo Palace', category: 'momo'),
  ];

  test(
    'filteredPlaces returns all places when category is all and search is empty',
    () {
      final state = ExploreState(
        status: ExploreStatus.loaded,
        allPlaces: testPlaces,
      );

      expect(state.filteredPlaces.length, 3);
      expect(state.filteredPlaces, equals(testPlaces));
    },
  );

  test('filteredPlaces returns only places matching selected category', () {
    final state = ExploreState(
      status: ExploreStatus.loaded,
      allPlaces: testPlaces,
      selectedCategory: 'cafe',
    );
    final result = state.filteredPlaces;

    expect(result.length, 1);
    expect(result.first.name, 'Kailash Cafe');
  });

  test(
    'filteredPlaces filters by search query matching name, location, and category',
    () {
      final byName = ExploreState(
        status: ExploreStatus.loaded,
        allPlaces: testPlaces,
        searchQuery: 'momo',
      );

      final byLocation = ExploreState(
        status: ExploreStatus.loaded,
        allPlaces: testPlaces,
        searchQuery: 'shivapuri',
      );

      expect(byName.filteredPlaces.length, 1);
      expect(byName.filteredPlaces.first.name, 'Momo Palace');

      expect(byLocation.filteredPlaces.length, 1);
      expect(byLocation.filteredPlaces.first.name, 'Hike Shivapuri');
    },
  );
}
