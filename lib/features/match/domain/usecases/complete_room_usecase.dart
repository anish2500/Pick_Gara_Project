import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mero_choice_application/core/error/failures.dart';
import 'package:mero_choice_application/core/usecases/usecase.dart';
import 'package:mero_choice_application/features/match/data/repositories/match_repository.dart';
import 'package:mero_choice_application/features/match/domain/repositories/match_repository.dart';

final completeRoomUsecaseProvider = Provider<CompleteRoomUsecase>((ref) {
  return CompleteRoomUsecase(ref.read(matchRepositoryProvider));
});

class CompleteRoomUsecase implements UsecaseWithParams<Unit, String> {
  final IMatchRepository _repo;
  CompleteRoomUsecase(this._repo); 


  @override   
  Future<Either<Failure, Unit>> call (String params) => 
    _repo.completeRoom(params); 
  }

