import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mero_choice_application/features/place/domain/usecases/get_places_usecase.dart';
import 'package:mero_choice_application/features/place/presentation/state/explore_state.dart';

final exploreViewModelProvider =
    NotifierProvider<ExploreViewModel, ExploreState>(ExploreViewModel.new);

class ExploreViewModel extends Notifier<ExploreState> {
  @override
  ExploreState build() => ExploreState.initial();

  Future<void> loadPlaces() async {
    if (state.status == ExploreStatus.loading) return;

    state = state.copyWith(status: ExploreStatus.loading);

    final result = await ref.read(getPlacesUsecaseProvider).call();

    result.fold(
      (failure) => state = state.copyWith(
        status: ExploreStatus.error,
        errorMessage: failure.message,
      ),
      (places) => state = state.copyWith(
        status: ExploreStatus.loaded,
        allPlaces: places,
      ),
    );
  }

  void selectCategory(String category) {
    state = state.copyWith(selectedCategory: category);
  }

  void updateSearch(String query) {
    state = state.copyWith(searchQuery: query);
  }
}
