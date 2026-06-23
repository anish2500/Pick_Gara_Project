import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mero_choice_application/features/auth/domain/usecases/upload_avatar_usecase.dart';
import 'package:mero_choice_application/features/room/presentation/view_model/active_rooms_view_model.dart';
import 'package:mero_choice_application/features/room/presentation/view_model/room_view_model.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/get_current_usecase.dart';
import '../state/auth_state.dart';

final authViewModelProvider = NotifierProvider<AuthViewModel, AuthState>(
  AuthViewModel.new,
);

class AuthViewModel extends Notifier<AuthState> {
  @override
  AuthState build() => AuthState.initial();

  Future<void> login(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading);

    final result = await ref
        .read(loginUsecaseProvider)
        .call(LoginUsecaseParams(email: email, password: password));

    result.fold(
      (failure) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      ),
      (user) => state = state.copyWith(
        status: AuthStatus.authenticated,
        authEntity: user,
      ),
    );
  }

  Future<void> register(String fullName, String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading);

    final result = await ref
        .read(registerUsecaseProvider)
        .call(
          RegisterUsecaseParams(
            fullName: fullName,
            email: email,
            password: password,
          ),
        );

    result.fold(
      (failure) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      ),
      (_) => state = state.copyWith(status: AuthStatus.registered),
    );
  }

  Future<void> getCurrentUser() async {
    final result = await ref.read(getCurrentUserUsecaseProvider).call();
    result.fold(
      (_) => state = state.copyWith(status: AuthStatus.unauthenticated),
      (user) => state = state.copyWith(
        status: AuthStatus.authenticated,
        authEntity: user,
      ),
    );
  }

  Future<void> logout() async {
    state = state.copyWith(status: AuthStatus.loading);
    final result = await ref.read(logoutUsecaseProvider).call();
    result.fold(
      (failure) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      ),
      (_) {
        ref.read(activeRoomsViewModelProvider.notifier).reset();
        ref.read(roomViewModelProvider.notifier).resetState();
        state = state.copyWith(status: AuthStatus.unauthenticated);
      },
    );
  }

  Future<String?> uploadAvatar(XFile xFile) async {
    final result = await ref.read(uploadAvatarUsecaseProvider).call(xFile);
    return result.fold(
      (failure) {
        state = state.copyWith(errorMessage: failure.message);
        return null;
      },
      (url) {
        final updated = state.authEntity?.copyWith(profileImage: url);
        state = state.copyWith(authEntity: updated, errorMessage: null);
        return url;
      },
    );
  }

  void resetState() => state = AuthState.initial();
}
