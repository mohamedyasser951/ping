import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:ping/core/services/cache_service.dart';
import 'package:ping/core/services/remote_auth_services.dart';
import 'package:ping/core/services/remote_database_service.dart';
import 'package:ping/features/Chats/data/datasources/chats_remote_data_source.dart';
import 'package:ping/features/Chats/data/repositories/chat_repo_implm.dart';
import 'package:ping/features/Chats/data/repositories/chats_repo.dart';
import 'package:ping/features/Chats/presentation/controllers/cubit/chat_room_cubit.dart';
import 'package:ping/features/home/presentation/controller/chat_cubit/chat_cubit.dart';
import 'package:ping/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:ping/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:ping/features/auth/data/datasources/auth_remote_database_source.dart';
import 'package:ping/features/auth/data/repositories/auth_repo.dart';
import 'package:ping/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:ping/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:ping/features/home/data/datasources/home_remote_data_source.dart';
import 'package:ping/features/home/data/repository/home_repository.dart';
import 'package:ping/features/home/data/repository/home_respository_impl.dart';
import 'package:ping/features/home/presentation/controller/search_users_bloc/search_users_bloc.dart';

GetIt sl = GetIt.instance;

void setupServiceLocator() {
  //CUBITS
  sl.registerFactory<AuthCubit>(() => AuthCubit(authRepo: sl()));
  sl.registerFactory<SearchUsersBloc>(
      () => SearchUsersBloc(homeRepository: sl()));
  sl.registerFactory<ChatsCubit>(() => ChatsCubit(chatRepository: sl()));
  sl.registerFactory(() => ChatRoomCubit(chatRepository: sl()));

  //REPOSITORIES
  sl.registerLazySingleton<AuthRepo>(() => AuthRepoImplem(
      authRemoteDataSource: sl(),
      authLocalDataSource: sl(),
      authRemoteDatabaseSource: sl()));
  sl.registerLazySingleton<HomeRepository>(
      () => HomeRespositoryImpl(homeRemoteDataSource: sl()));
  sl.registerLazySingleton<ChatRepository>(
      () => ChatRepositoryImpl(chatRemoteDataSource: sl()));

  //DATASOURCES
  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(remoteAuthServices: sl()));
  sl.registerLazySingleton<AuthRemoteDatabaseSource>(
      () => AuthRemoteDatabaseSourceImpl(remoteDatabaseService: sl()));

  sl.registerLazySingleton<HomeRemoteDataSource>(
      () => HomeRemoteDataSourceImpl(remoteDatabaseService: sl()));

  sl.registerLazySingleton<ChatRemoteDataSource>(
      () => ChatRemoteDataSourceImpl(remoteDatabaseService: sl()));

  //lOCAL DATASOURCE
  sl.registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(cacheService: sl()));

  //SERVICES
  sl.registerLazySingleton<RemoteAuthServices>(
      () => RemoteAuthServicesImpl(firebaseAuth: FirebaseAuth.instance));

  sl.registerLazySingleton<RemoteDatabaseService>(
      () => RemoteDatabaseServiceImpl(firestore: FirebaseFirestore.instance));

  sl.registerLazySingleton<CacheService>(() {
    return CacheServiceImpl();
  });
}
