part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();
}

class AuthInitial extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthLoading extends AuthState {
  @override
  List<Object> get props => [];
}

class LoginSuccess extends AuthState {
  const LoginSuccess(this.user);

  final AppUser? user;

  @override
  List<Object?> get props => [user];
}

class LoginFailure extends AuthState {
  const LoginFailure(this.errorMessage, {this.errorCode});

  final int? errorCode;
  final String errorMessage;

  @override
  List<Object?> get props => [errorCode, errorMessage];
}

class RegisterSuccess extends AuthState {
  const RegisterSuccess(this.user);

  final AppUser? user;

  @override
  List<Object?> get props => [user];
}

class RegisterFailure extends AuthState {
  const RegisterFailure(this.errorMessage, {this.errorCode});

  final int? errorCode;
  final String errorMessage;

  @override
  List<Object?> get props => [errorCode, errorMessage];
}

class ResetPasswordSuccess extends AuthState {
  const ResetPasswordSuccess(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class ResetPasswordFailure extends AuthState {
  const ResetPasswordFailure(this.errorMessage, {this.errorCode});

  final int? errorCode;
  final String errorMessage;

  @override
  List<Object?> get props => [errorCode, errorMessage];
}

class EmailVerifySuccess extends AuthState {
  const EmailVerifySuccess(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class EmailVerifyFailure extends AuthState {
  const EmailVerifyFailure(this.errorMessage, {this.errorCode});

  final int? errorCode;
  final String errorMessage;

  @override
  List<Object?> get props => [errorCode, errorMessage];
}

class CheckEmailVerifySuccess extends AuthState {
  const CheckEmailVerifySuccess(this.acessToken);

  final String? acessToken;

  @override
  List<Object?> get props => [acessToken];
}

class CheckEmailVerifyFailure extends AuthState {
  const CheckEmailVerifyFailure(this.errorMessage, {this.errorCode});

  final int? errorCode;
  final String errorMessage;

  @override
  List<Object?> get props => [errorCode, errorMessage];
}
