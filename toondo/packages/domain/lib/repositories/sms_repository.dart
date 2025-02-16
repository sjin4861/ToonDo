abstract class SmsRepository {
  Future<String> sendSmsCode(String phoneNumber);
  Future<String> verifySmsCode(String phoneNumber, String code);
}
