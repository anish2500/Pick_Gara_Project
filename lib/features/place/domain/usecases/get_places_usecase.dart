import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mero_choice_application/core/error/failures.dart';
import 'package:mero_choice_application/core/usecases/usecase.dart';
import 'package:mero_choice_application/features/place/data/repositories/place_repository.dart';
import 'package:mero_choice_application/features/place/domain/entities/place_entity.dart';
import 'package:mero_choice_application/features/place/domain/repositories/place_repository.dart';

final getPlacesUsecaseProvider = Provider<GetPlacesUsecase>((ref) {
  return GetPlacesUsecase(
    placeRepository: ref.read(placeRepositoryProvider),
  );
});

class GetPlacesUsecase implements UsecaseWithoutParams<List<PlaceEntity>> {
  final IPlaceRepository _placeRepository;

  GetPlacesUsecase({required IPlaceRepository placeRepository})
      : _placeRepository = placeRepository;

  @override
  Future<Either<Failure, List<PlaceEntity>>> call() {
    return _placeRepository.getPlaces();
  }
}
