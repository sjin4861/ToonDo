import 'dart:convert';
import 'package:data/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:data/constants.dart';
import 'package:domain/entities/user.dart';
import 'package:get_it/get_it.dart';
import 'package:domain/usecases/auth/get_token.dart'; // reuse if token retrieval similar

class UserRemoteDatasource {
  http.Client client = http.Client();
  final GetTokenUseCase getTokenUseCase = GetIt.instance<GetTokenUseCase>();

  Future<User> changeNickName(User user, String newNickName) async {
    final token = await getTokenUseCase();
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

  Future<User> updateUserPoints(User user, int delta) async {
    final token = await getTokenUseCase();
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
