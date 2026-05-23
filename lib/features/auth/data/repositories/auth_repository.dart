import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mero_choice_application/core/error/failures.dart';
import 'package:mero_choice_application/core/services/storage/token_service.dart';
import 'package:mero_choice_application/core/services/storage/user_session_service.dart';
import 'package:mero_choice_application/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:mero_choice_application/features/auth/data/models/auth_api_model.dart';
import 'package:mero_choice_application/features/auth/domain/entities/auth_entity.dart';
import 'package:mero_choice_application/features/auth/domain/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  return AuthRepository(
    remoteDatasource: ref.read(authRemoteDatasourceProvider),
    tokenService: ref.read(tokenServiceProvider),
    userSessionServce: ref.read(userSessionServiceProvider),
  );
});

class AuthRepository implements IAuthRepository {
  final AuthRemoteDatasource _remoteDatasource;
  final TokenService _tokenService;
  final UserSessionService _userSessionService;

  AuthRepository({
    required AuthRemoteDatasource remoteDatasource,
    required TokenService tokenService,
    required UserSessionService userSessionServce,
  }) : _remoteDatasource = remoteDatasource,
       _tokenService = tokenService,
       _userSessionService = userSessionServce;
  @override
  Future<Either<Failure, AuthEntity>> getCurrentUser() async {
    try {
      if (!_userSessionService.isLoggedIn()) {
        return const Left(LocalDatabaseFailure(message: 'No active session'));
      }
      final entity = AuthEntity(
        authId: _userSessionService.getUserId(),
        fullName: _userSessionService.getFullName() ?? '',
        email: _userSessionService.getUserEmail() ?? '',
      );
      return Right(entity);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> login(
    String email,
    String password,
  ) async {
    try {
      final model = await _remoteDatasource.login(email, password);
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message:
              (e.response?.data is Map ? e.response?.data['message'] : null) ??
              e.message ??
              'Login Failed',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      await _tokenService.removeToken();
      await _userSessionService.clearUserSession();
      return const Right(true);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> register(AuthEntity entity) async {
    try {
      final model = AuthApiModel.fromEntity(entity);
      await _remoteDatasource.register(model);
      return const Right(true);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message:
              (e.response?.data is Map ? e.response?.data['message'] : null) ??
              e.message ??
              'Registration failed',
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
