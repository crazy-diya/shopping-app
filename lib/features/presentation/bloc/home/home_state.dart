part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class SignInInitial extends HomeState {}

class ApiLoadingState extends HomeState {}

class ApiFailureState extends HomeState {}

class DioExceptionFailureState extends HomeState {}

class ServerFailureState extends HomeState {}

class ConnectionFailureState extends HomeState {}

class GetAllDataSuccessState extends HomeState {
  final List<ItemsResponseModel> ?list;

  GetAllDataSuccessState({this.list});
}
