import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class SecureLocalDataSource {
  final FlutterSecureStorage secureStorage;

  SecureLocalDataSource(this.secureStorage);

  Future<void> saveToken(String token) async {
    await secureStorage.write(key: 'jwt_token', value: token);
  }

  Future<String?> getToken() async {
    return await secureStorage.read(key: 'jwt_token');
  }

  Future<void> deleteToken() async {
    await secureStorage.delete(key: 'jwt_token');
  }

  Future<void> saveUserNumericId(int id) async {
    await secureStorage.write(key: 'user_numeric_id', value: id.toString());
  }

  Future<int?> getUserNumericId() async {
    final v = await secureStorage.read(key: 'user_numeric_id');
    if (v == null) return null;
    return int.tryParse(v);
  }

  Future<void> deleteUserNumericId() async {
    await secureStorage.delete(key: 'user_numeric_id');
  }
}
