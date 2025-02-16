import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
}
