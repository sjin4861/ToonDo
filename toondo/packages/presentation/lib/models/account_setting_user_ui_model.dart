import 'package:domain/entities/user.dart';

class AccountSettingUserUiModel {
  final String nickname;
  final String loginId;

  const AccountSettingUserUiModel({
    required this.nickname,
    required this.loginId,
  });

  factory AccountSettingUserUiModel.fromDomain(User user) {
    return AccountSettingUserUiModel(
      nickname: user.nickname ?? '익명',
      loginId: user.loginId,
    );
  }
}
