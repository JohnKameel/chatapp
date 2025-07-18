part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}
final class AuthLoading extends AuthState {}
final class AuthSuccess extends AuthState {
  final String email;
  AuthSuccess({required this.email});
}
final class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);
}
final class AuthLogoutSuccess extends AuthState {}
