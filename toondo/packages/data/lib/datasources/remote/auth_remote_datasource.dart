import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:data/models/user_model.dart';
import 'package:toondo/constants.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> registerUser(String phoneNumber, String password);
  Future<UserModel> login(String phoneNumber, String password);
  Future<bool> isPhoneNumberRegistered(String phoneNumber);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client httpClient;
  AuthRemoteDataSourceImpl(this.httpClient);

  static const String baseUrl = Constants.baseUrl;

  @override
  Future<UserModel> registerUser(String phoneNumber, String password) async {
    final url = Uri.parse('$baseUrl/users/signup');
    final response = await httpClient.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'loginId': phoneNumber, 'password': password}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      return UserModel.fromJson(responseData);
    } else {
      throw Exception('회원가입 실패: ${response.body}');
    }
  }

  @override
  Future<UserModel> login(String phoneNumber, String password) async {
    final url = Uri.parse('$baseUrl/users/login');
    final response = await httpClient.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'loginId': phoneNumber, 'password': password}),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return UserModel.fromJson(responseData);
    } else {
      throw Exception('로그인 실패: ${response.body}');
    }
  }

  @override
  Future<bool> isPhoneNumberRegistered(String phoneNumber) async {
    final url = Uri.parse('$baseUrl/users/check-phone-number');
    final response = await httpClient.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'loginId': phoneNumber}),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['exists'];
    } else {
      throw Exception('휴대폰 번호 확인 실패');
    }
  }
}