part of 'my_orders_cubit.dart';

@immutable
sealed class MyOrdersState {}

final class MyOrdersInitial extends MyOrdersState {}

class ApiLoadingState extends MyOrdersState {}

class ApiFailureState extends MyOrdersState {}

class DioExceptionFailureState extends MyOrdersState {}

class ServerFailureState extends MyOrdersState {}

class ConnectionFailureState extends MyOrdersState {}

class MyOrderSuccessState extends MyOrdersState {}

class RetrieveDataSuccessfully extends MyOrdersState {}