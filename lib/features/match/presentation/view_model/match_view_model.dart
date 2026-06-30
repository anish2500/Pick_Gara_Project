import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mero_choice_application/features/match/domain/usecases/get_matches_usecase.dart';
import 'package:mero_choice_application/features/match/presentation/state/match_state.dart';

final matchViewModelProvider =
    NotifierProvider<MatchViewModel, MatchState>(MatchViewModel.new);

class MatchViewModel extends Notifier<MatchState> {
  @override
  MatchState build() => MatchState.initial();

  Future<void> loadMatches() async {
    if (state.status == MatchStatus.loading) return;
    state = state.copyWith(status: MatchStatus.loading);
    final result = await ref.read(getMatchesUsecaseProvider).call();
    result.fold(
      (failure) => state = state.copyWith(
        status: MatchStatus.error,
        errorMessage: failure.message,
      ),
      (matches) => state = state.copyWith(
        status: MatchStatus.loaded,
        matches: matches,
      ),
    );
  }
}
