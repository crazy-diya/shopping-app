part of 'signin_cubit.dart';

@immutable
sealed class SignInState {}

final class SignInInitial extends SignInState {}

class ApiLoadingState extends SignInState {}

class ApiFailureState extends SignInState {}

class DioExceptionFailureState extends SignInState {}

class ServerFailureState extends SignInState {}

class ConnectionFailureState extends SignInState {}

class SignInSuccessState extends SignInState {}
