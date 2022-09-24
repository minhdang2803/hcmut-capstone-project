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

  final User? user;

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

  final User? user;

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