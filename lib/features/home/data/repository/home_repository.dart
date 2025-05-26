import 'package:ping/features/auth/data/models/user_model.dart';

abstract class HomeRepository {
  Future<List<UserModel>> searchUsers(String queryString);
}
