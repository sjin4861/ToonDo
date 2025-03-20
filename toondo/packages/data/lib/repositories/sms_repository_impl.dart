import 'package:domain/repositories/sms_repository.dart';
import 'package:data/datasources/remote/sms_remote_datasource.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: SmsRepository)
class SmsRepositoryImpl implements SmsRepository {
  final SmsRemoteDataSource smsRemoteDataSource;

  SmsRepositoryImpl(this.smsRemoteDataSource);

  @override
  Future<String> sendSmsCode(String phoneNumber) async {
    return await smsRemoteDataSource.sendSmsCode(phoneNumber);
  }

  @override
  Future<String> verifySmsCode(String phoneNumber, String code) async {
    return await smsRemoteDataSource.verifySmsCode(phoneNumber, code);
  }
}
