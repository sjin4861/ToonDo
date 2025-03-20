import 'package:domain/repositories/sms_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class VerifySmsCode {
  final SmsRepository repository;

  VerifySmsCode(this.repository);

  Future<String> call(String phoneNumber, String code) {
    return repository.verifySmsCode(phoneNumber, code);
  }
}
