// Simple server connectivity health check
// How to run:
//   dart run tools/health_check.dart
//
// It will call backend endpoints and print status codes and cookies.

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

const String baseUrl = 'http://3.36.80.237:8083';

Future<void> main(List<String> args) async {
  final client = http.Client();
  try {
    // 1) Ping login endpoint (POST) with dummy creds (will likely 400 if invalid)
    final loginUri = Uri.parse('$baseUrl/login');
    final loginResp = await client.post(
      loginUri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': 'healthcheck', 'password': 'invalid'}),
    );
    _printResponse('POST /login', loginResp);

    // 2) Signup endpoint shape check (won't actually create user, just connectivity)
    final signupUri = Uri.parse('$baseUrl/api/v1/users/signup');
    final signupResp = await client.post(
      signupUri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'loginId': 'healthcheck_${DateTime.now().millisecondsSinceEpoch}',
        'password': '12345678Aa!',
        'phoneNumber': '01012341234',
        'nickname': 'health',
      }),
    );
    _printResponse('POST /api/v1/users/signup', signupResp);

    // 3) Refresh token endpoint (expect 401 without cookies). Used to verify routing.
    final refreshUri = Uri.parse('$baseUrl/api/v1/auth/refreshToken');
    final refreshResp = await client.post(refreshUri);
    _printResponse('POST /api/v1/auth/refreshToken', refreshResp);

    // 4) Logout (expect 401 without session)
    final logoutUri = Uri.parse('$baseUrl/logout');
    final logoutResp = await client.post(logoutUri);
    _printResponse('POST /logout', logoutResp);

    _printSummary([loginResp, signupResp, refreshResp, logoutResp]);
  } on SocketException catch (e) {
    stderr.writeln('[NETWORK] Unable to reach server: ${e.message}');
    exitCode = 2;
  } catch (e, st) {
    stderr.writeln('[ERROR] $e');
    stderr.writeln(st);
    exitCode = 1;
  } finally {
    client.close();
  }
}

void _printResponse(String label, http.Response r) {
  final cookies = r.headers['set-cookie'] ?? r.headers['Set-Cookie'];
  print('--- $label');
  print('Status: ${r.statusCode}');
  if (cookies != null) print('Set-Cookie: $cookies');
  print('Body: ${_trim(r.body)}');
}

void _printSummary(List<http.Response> resps) {
  print('\n===== SUMMARY =====');
  for (final r in resps) {
    print('${r.request?.method} ${r.request?.url} -> ${r.statusCode}');
  }
}

String _trim(String s, {int max = 300}) {
  if (s.length <= max) return s;
  return s.substring(0, max) + '...';
}
