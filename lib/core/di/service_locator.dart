import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:ping/core/services/cache_service.dart';
import 'package:ping/core/services/remote_auth_services.dart';
import 'package:ping/core/services/remote_database_service.dart';
import 'package:ping/features/Chats/data/repositories/chat_repo_implm.dart';
import 'package:ping/features/Chats/data/repositories/chats_repo.dart';
import 'package:ping/features/Chats/presentation/cubit/chats_cubit.dart';
import 'package:ping/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:ping/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:ping/features/auth/data/datasources/auth_remote_database_source.dart';
import 'package:ping/features/auth/data/repositories/auth_repo.dart';
import 'package:ping/features/auth/data/repositories/auth_repo_implem.dart';
import 'package:ping/features/auth/presentation/cubit/auth_cubit.dart';

GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  //CUBITS
  getIt.registerFactory<AuthCubit>(() => AuthCubit(authRepo: getIt()));
  getIt.registerFactory<ChatsCubit>(() => ChatsCubit(chatsRepo: getIt()),);
  //REPOSITORIES
  getIt.registerLazySingleton<AuthRepo>(() => AuthRepoImplem(
      authRemoteDataSource: getIt(),
      authLocalDataSource: getIt(),
      authRemoteDatabaseSource: getIt()));

    getIt.registerLazySingleton<ChatsRepo>(() => FirebaseChatRepositoryImplem(),);
  //DATASOURCES
  getIt.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(remoteAuthServices: getIt()));
  getIt.registerLazySingleton<AuthRemoteDatabaseSource>(
      () => AuthRemoteDatabaseSourceImpl(remoteDatabaseService: getIt()));

  //lOCAL DATASOURCE
  getIt.registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(cacheService: getIt()));

  //SERVICES
  getIt.registerLazySingleton<RemoteAuthServices>(
      () => RemoteAuthServicesImpl(firebaseAuth: FirebaseAuth.instance));

  getIt.registerLazySingleton<RemoteDatabaseService>(() =>
      FirebaseRemoteDatabaseService(firestore: FirebaseFirestore.instance));

  getIt.registerLazySingleton<CacheService>(() {
    return CacheServiceImpl();
  });
}
