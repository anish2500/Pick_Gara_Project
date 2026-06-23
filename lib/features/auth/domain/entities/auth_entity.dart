import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String? authId;
  final String fullName;
  final String email;
  final String? password;
  final String? profileImage; 

  const AuthEntity({
    this.authId,
    required this.fullName,
    required this.email,
    this.password,
    this.profileImage, 
  });

  AuthEntity copyWith({
    String? authId,
    String? fullName,
    String? email,
    String? password,
    String? profileImage,
  }) {
    return AuthEntity(
      authId: authId ?? this.authId,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      password: password ?? this.password,
      profileImage: profileImage ?? this.profileImage,
    );
  }


  @override
  List<Object?> get props => [authId, fullName, email, password, profileImage];
}
