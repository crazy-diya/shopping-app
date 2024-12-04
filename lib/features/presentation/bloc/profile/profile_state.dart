part of 'profile_cubit.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class SignInInitial extends ProfileState {}

class ApiLoadingState extends ProfileState {}

class ApiFailureState extends ProfileState {}

class DioExceptionFailureState extends ProfileState {}

class ServerFailureState extends ProfileState {}

class ConnectionFailureState extends ProfileState {}

class ProfileSuccessState extends ProfileState {
  final UserProfileResponse? userProfileResponse;

  ProfileSuccessState({this.userProfileResponse});
}

class ProfileUpdateSuccessState extends ProfileState {
  final UserProfileResponse? userProfileResponse;

  ProfileUpdateSuccessState({this.userProfileResponse});
}
