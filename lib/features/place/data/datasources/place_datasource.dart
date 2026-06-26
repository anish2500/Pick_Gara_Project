import 'package:mero_choice_application/features/place/data/models/place_api_model.dart';

abstract interface class IPlaceRemoteDataSource {
  Future<List<PlaceApiModel>> getPlaces();
}
