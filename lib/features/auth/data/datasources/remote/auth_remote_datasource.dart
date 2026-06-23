import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mero_choice_application/core/api/api_client.dart';
import 'package:mero_choice_application/core/api/api_endpoints.dart';
import 'package:mero_choice_application/core/services/storage/token_service.dart';
import 'package:mero_choice_application/core/services/storage/user_session_service.dart';
import 'package:mero_choice_application/features/auth/data/datasources/auth_datasource.dart';
import 'package:mero_choice_application/features/auth/data/models/auth_api_model.dart';

final authRemoteDatasourceProvider = Provider<AuthRemoteDatasource>((ref) {
  return AuthRemoteDatasource(
    dio: ref.read(apiClientProvider),
    tokenService: ref.read(tokenServiceProvider),
    userSessionService: ref.read(userSessionServiceProvider),
  );
});

class AuthRemoteDatasource implements IAuthRemoteDataSource {
  final Dio _dio;
  final TokenService _tokenService;
  final UserSessionService _userSessionService;

  AuthRemoteDatasource({
    required Dio dio,
    required TokenService tokenService,
    required UserSessionService userSessionService,
  }) : _dio = dio,
       _tokenService = tokenService,
       _userSessionService = userSessionService;
  @override
  Future<AuthApiModel> login(String email, String password) async {
    final response = await _dio.post(
      ApiEndpoints.login,
      data: {'email': email, 'password': password},
    );

    final token = response.data['token'] as String;
    final userData = response.data['user'] as Map<String, dynamic>;
    final model = AuthApiModel.fromJson(userData);

    await _tokenService.saveToken(token);
    await _userSessionService.saveUserSession(
      userId: model.authId ?? '',
      email: model.email,
      fullName: model.fullName,
      profileImage: model.profileImage,
    );

    return model;
  }

  @override
  Future<AuthApiModel> register(AuthApiModel model) async {
    final response = await _dio.post(
      ApiEndpoints.register,
      data: {
        'fullName': model.fullName,
        'email': model.email,
        'password': model.password,
      },
    );

    final userData = response.data['user'] as Map<String, dynamic>;

    return AuthApiModel.fromJson(userData);
  }
  
  @override
  Future<String> uploadAvatar(XFile xFile) async {
    final MultipartFile multipartFile;
    if (kIsWeb) {
      final bytes = await xFile.readAsBytes();
      final filename = xFile.name.isNotEmpty ? xFile.name : 'avatar.jpg';
      multipartFile = MultipartFile.fromBytes(bytes, filename: filename);
    } else {
      multipartFile = await MultipartFile.fromFile(xFile.path);
    }
    final formData = FormData.fromMap({'avatar': multipartFile});
    final response = await _dio.post('/auth/upload-avatar', data: formData);
    final url = response.data['profileImage'] as String;
    await _userSessionService.saveProfileImage(url);
    return url;
  }
}
