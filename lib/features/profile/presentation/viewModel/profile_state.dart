part of 'profile_cubit.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}
final class ProfileLoading extends ProfileState {}
final class ProfileSuccess extends ProfileState {
  final UserInfoModel user;

  ProfileSuccess(this.user);
}
final class ProfileFailure extends ProfileState {
  final String message;

  ProfileFailure(this.message);
}
final class ProfileUpdating extends ProfileState {}
final class ProfileUpdated extends ProfileState {
  final String message;
  ProfileUpdated(this.message);
}
class ProfileImageUpdated extends ProfileState {
  final String imageUrl;
  ProfileImageUpdated(this.imageUrl);
}