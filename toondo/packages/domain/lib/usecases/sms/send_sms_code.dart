import 'package:domain/repositories/sms_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class SendSmsCode {
  final SmsRepository repository;

  SendSmsCode(this.repository);

  Future<String> call(String phoneNumber) {
    return repository.sendSmsCode(phoneNumber);
  }
}
