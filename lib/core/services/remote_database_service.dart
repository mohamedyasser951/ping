import 'package:cloud_firestore/cloud_firestore.dart';

abstract class RemoteDatabaseService {
  Future<T> get<T>(
    String path,
    T Function(Map<String, dynamic>) fromMap,
  );
  Future<void> set<T>(
      String path, T data, Map<String, dynamic> Function(T) toMap);

  Future<void> delete(String path);
}

class FirebaseRemoteDatabaseService implements RemoteDatabaseService {
  FirebaseFirestore firestore;
  FirebaseRemoteDatabaseService({
    required this.firestore,
  });

  @override
  Future<T> get<T>(
      String path, T Function(Map<String, dynamic> p1) fromMap) async {
    final snapshot = await firestore.doc(path).get();
    if (!snapshot.exists) throw Exception('Document does not exist');
    return fromMap(snapshot.data()!);
  }

  @override
  Future<void> set<T>(
      String path, T data, Map<String, dynamic> Function(T) toMap) async {
    return await firestore.doc(path).set(toMap(data));
  }

  @override
  Future<void> delete(String path) {
    return firestore.doc(path).delete();
  }
}
