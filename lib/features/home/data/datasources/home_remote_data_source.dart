import 'package:ping/core/services/remote_database_service.dart';
import 'package:ping/features/auth/data/models/user_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<UserModel>> searchUsers(String query);
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  RemoteDatabaseService remoteDatabaseService;
  HomeRemoteDataSourceImpl({required this.remoteDatabaseService});

  @override
  Future<List<UserModel>> searchUsers(String queryString) async {
    return remoteDatabaseService.getCollectionPaginated(
        "users", UserModel.fromMap,
        queryBuilder: (query) =>
            query.where("name", isGreaterThanOrEqualTo: queryString));
  }
}
