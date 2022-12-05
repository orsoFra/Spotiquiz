import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class IStorage {
  Future<void> saveToken(String token);
  Future<String?> read({required String key});
}

class MyStorage implements IStorage {
  MyStorage(this._storage);
  final FlutterSecureStorage _storage;

  @override
  Future<void> saveToken(String token) =>
      _storage.write(key: 'token', value: token);
  @override
  Future<String?> read({required String key}) => _storage.read(key: key);
}
