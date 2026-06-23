import 'package:image_picker/image_picker.dart';
import 'package:mero_choice_application/features/auth/data/models/auth_api_model.dart';

abstract interface class IAuthRemoteDataSource {
  Future<AuthApiModel> register(AuthApiModel model);
  Future<AuthApiModel> login(String email, String password);
  Future<String> uploadAvatar(XFile xFile);
}
