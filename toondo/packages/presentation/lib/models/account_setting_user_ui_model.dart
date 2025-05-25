import 'package:domain/entities/user.dart';

class AccountSettingUserUiModel {
  final String nickname;
  final String phoneNumber;

  const AccountSettingUserUiModel({
    required this.nickname,
    required this.phoneNumber,
  });

  factory AccountSettingUserUiModel.fromDomain(User user) {
    return AccountSettingUserUiModel(
      nickname: user.nickname ?? '익명',
      phoneNumber: user.phoneNumber ?? '미등록',
    );
  }
}
