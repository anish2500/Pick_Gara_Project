import 'package:equatable/equatable.dart';
import 'package:mero_choice_application/features/match/domain/entities/match_entity.dart';

enum MatchStatus { initial, loading, loaded, error }

class MatchState extends Equatable {
  final MatchStatus status;
  final List<MatchEntity> matches;
  final String? errorMessage;

  const MatchState({
    required this.status,
    this.matches = const [],
    this.errorMessage,
  });

  factory MatchState.initial() => const MatchState(status: MatchStatus.initial);

  MatchState copyWith({
    MatchStatus? status,
    List<MatchEntity>? matches,
    String? errorMessage,
  }) {
    return MatchState(
      status: status ?? this.status,
      matches: matches ?? this.matches,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, matches, errorMessage]; 
}
