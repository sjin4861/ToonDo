import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class SecureLocalDataSource {
  final FlutterSecureStorage secureStorage;

  SecureLocalDataSource(this.secureStorage);

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  // legacy key (backward compatible)
  static const _legacyJwtTokenKey = 'jwt_token';
  static const _passwordKeyPrefix = 'local_password_';

  Future<void> saveToken(String token) async {
    // Backward compatible: treat "token" as accessToken.
    await saveAccessToken(token);
  }

  Future<String?> getToken() async {
    return await getAccessToken();
  }

  Future<void> deleteToken() async {
    await deleteAccessToken();
  }

  Future<void> saveAccessToken(String token) async {
    await secureStorage.write(key: _accessTokenKey, value: token);
    // Also write legacy key so older reads (if any) still work.
    await secureStorage.write(key: _legacyJwtTokenKey, value: token);
  }

  Future<String?> getAccessToken() async {
    // Prefer new key; fall back to legacy.
    return await secureStorage.read(key: _accessTokenKey) ??
        await secureStorage.read(key: _legacyJwtTokenKey);
  }

  Future<void> deleteAccessToken() async {
    await secureStorage.delete(key: _accessTokenKey);
    await secureStorage.delete(key: _legacyJwtTokenKey);
  }

  Future<void> saveRefreshToken(String token) async {
    await secureStorage.write(key: _refreshTokenKey, value: token);
  }

  Future<String?> getRefreshToken() async {
    return await secureStorage.read(key: _refreshTokenKey);
  }

  Future<void> deleteRefreshToken() async {
    await secureStorage.delete(key: _refreshTokenKey);
  }

  Future<void> clearAuthTokens() async {
    await deleteAccessToken();
    await deleteRefreshToken();
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

  String _passwordKey(String loginId) => '$_passwordKeyPrefix$loginId';

  Future<void> saveUserPassword(String loginId, String password) async {
    await secureStorage.write(key: _passwordKey(loginId), value: password);
  }

  Future<String?> getUserPassword(String loginId) async {
    return secureStorage.read(key: _passwordKey(loginId));
  }

  Future<void> deleteUserPassword(String loginId) async {
    await secureStorage.delete(key: _passwordKey(loginId));
  }
}
