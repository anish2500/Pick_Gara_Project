import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mero_choice_application/core/error/failures.dart';
import 'package:mero_choice_application/core/usecases/usecase.dart';
import 'package:mero_choice_application/features/auth/data/repositories/auth_repository.dart';
import 'package:mero_choice_application/features/auth/domain/repositories/auth_repository.dart';

final uploadAvatarUsecaseProvider = Provider<UploadAvatarUsecase>((ref) {
  return UploadAvatarUsecase(authRepository: ref.read(authRepositoryProvider));
});

class UploadAvatarUsecase implements UsecaseWithParams<String, XFile> {
  final IAuthRepository _authRepository;

  UploadAvatarUsecase({required IAuthRepository authRepository})
      : _authRepository = authRepository;

  @override
  Future<Either<Failure, String>> call(XFile xFile) {
    return _authRepository.uploadAvatar(xFile);
  }
}
