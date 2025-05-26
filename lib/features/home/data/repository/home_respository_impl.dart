import 'package:ping/features/auth/data/models/user_model.dart';
import 'package:ping/features/home/data/datasources/home_remote_data_source.dart';
import 'package:ping/features/home/data/repository/home_repository.dart';

class HomeRespositoryImpl extends HomeRepository {
  final HomeRemoteDataSource homeRemoteDataSource;
  HomeRespositoryImpl({required this.homeRemoteDataSource});
  @override
  Future<List<UserModel>> searchUsers(String queryString) {
    return homeRemoteDataSource.searchUsers(queryString);
  }
}
