import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/auth_entity.dart';
import '../repositories/auth_repository.dart';
import '../../data/repositories/auth_repository.dart';

final registerUsecaseProvider = Provider<RegisterUsecase>((ref) {
  return RegisterUsecase(authRepository: ref.read(authRepositoryProvider));
});

class RegisterUsecaseParams extends Equatable {
  final String fullName;
  final String email;
  final String password;

  const RegisterUsecaseParams({
    required this.fullName,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [fullName, email, password];
}

class RegisterUsecase
    implements UsecaseWithParams<bool, RegisterUsecaseParams> {
  final IAuthRepository _authRepository;

  RegisterUsecase({required IAuthRepository authRepository})
      : _authRepository = authRepository;

  @override
  Future<Either<Failure, bool>> call(RegisterUsecaseParams params) {
    final entity = AuthEntity(
      fullName: params.fullName,
      email: params.email,
      password: params.password,
    );
    return _authRepository.register(entity);
  }
}
