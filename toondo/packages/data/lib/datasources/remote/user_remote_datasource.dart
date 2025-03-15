import 'dart:convert';
import 'package:data/models/user_model.dart';
import 'package:domain/repositories/auth_repository.dart';
import 'package:http/http.dart' as http;
import 'package:data/constants.dart';
import 'package:domain/entities/user.dart';
import 'package:injectable/injectable.dart'; // reuse if token retrieval similar

@LazySingleton()
class UserRemoteDatasource {
  http.Client client;
  final AuthRepository authRepository;

  UserRemoteDatasource(this.client, this.authRepository);

  Future<User> changeNickName(String newNickName) async {
    final token = await authRepository.getToken();
    if (token == null) throw Exception('JWT 토큰이 없습니다.');
    final url = Uri.parse('${Constants.baseUrl}/users/save-nickname');
    final requestBody = {'nickname': newNickName};
    final response = await client.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Assumes the API returns a full user update.
      return UserModel.fromJson(data).toEntity();
    }
    throw Exception('Failed to update nickname: ${response.body}');
  }

  // Todo: 아직 벡엔드에서 구현 x
  Future<User> updateUserPoints(int delta) async {
    final token = await authRepository.getToken();
    if (token == null) throw Exception('JWT 토큰이 없습니다.');
    final url = Uri.parse('${Constants.baseUrl}/users/points');
    final requestBody = {'delta': delta};
    final response = await client.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return UserModel.fromJson(data).toEntity();
    }
    throw Exception('Failed to update points: ${response.body}');
  }
}
