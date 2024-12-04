import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopingapp/features/domain/usecases/profile_update_usecase.dart';
import 'package:shopingapp/features/domain/usecases/signin_usecase.dart';
import 'package:shopingapp/features/domain/usecases/store_shopping_item_usecase.dart';
import 'package:shopingapp/features/domain/usecases/user_profile_usecase.dart';
import 'package:shopingapp/features/presentation/bloc/home/home_cubit.dart';
import 'package:shopingapp/features/presentation/bloc/login/signin_cubit.dart';
import 'package:shopingapp/features/presentation/bloc/my_orders/my_orders_cubit.dart';
import 'package:shopingapp/features/presentation/bloc/profile/profile_cubit.dart';

import '../../features/data/datasources/remote_datasource.dart';
import '../../features/data/datasources/shared_preference.dart';
import '../../features/data/repository/repository_impl.dart';
import '../../features/domain/repository/repository.dart';
import '../../features/domain/usecases/get_all_items_usecase.dart';
import '../../features/domain/usecases/retrive_data_usecase.dart';
import '../../features/presentation/bloc/splash/splash_cubit.dart';
import '../network/api_helper.dart';
import '../network/network_info.dart';

final injection = GetIt.instance;

Future<dynamic> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  injection.registerLazySingleton(() => sharedPreferences);
  injection.registerSingleton(Dio());
  injection.registerLazySingleton<APIHelper>(() => APIHelper(dio: injection()));
  injection.registerLazySingleton(() => Connectivity());
  injection.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(connectivity: injection()));

  injection.registerSingleton(AppSharedData(injection()));

  final firebaseFirestore = FirebaseFirestore.instance;
  final firebaseAuth = FirebaseAuth.instance;
  final firebaseStorage = FirebaseStorage.instance;

  injection.registerLazySingleton(() => firebaseFirestore);
  injection.registerLazySingleton(() => firebaseAuth);
  injection.registerLazySingleton(() => firebaseStorage);

  //RemoteDataSource
  injection.registerLazySingleton<RemoteDatasource>(() => RemoteDatasourceImpl(
      apiHelper: injection(),
      firestore: injection(),
      auth: injection(),
      sharedData: injection(),
      storage: injection()));

  //Repository
  injection.registerLazySingleton<Repository>(() =>
      RepositoryImpl(remoteDatasource: injection(), networkInfo: injection()));

  //UseCase
  injection
      .registerLazySingleton(() => GetAllItemsUseCase(repository: injection()));
  injection.registerLazySingleton(() => Signin(repository: injection()));
  injection.registerLazySingleton(() => RetriveDataUseCase(repository: injection()));
  injection.registerLazySingleton(
      () => ProfileUpdateUseCase(repository: injection()));
  injection.registerLazySingleton(
      () => StoreShoppingItemsUseCase(repository: injection()));
  injection
      .registerLazySingleton(() => UserProfileUSeCase(repository: injection()));

  //Bloc
  injection.registerFactory(() => SplashCubit(appSharedData: injection()));
  injection.registerFactory(
      () => MyOrdersCubit(storeShoppingItemsUseCase: injection(),retriveDataUseCase: injection()));
  injection.registerFactory(() => ProfileCubit(
      userProfileUSeCase: injection(), profileUpdateUseCase: injection()));
  injection.registerFactory(() => HomeCubit(getAllItemsUseCase: injection()));
  injection.registerFactory(() => SignInCubit(
        signin: injection(),
        appSharedData: injection(),
        userProfileUSeCase: injection(),
      ));
}
