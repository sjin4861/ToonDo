import 'package:domain/entities/user.dart';

class MyPageUserUiModel {
  final String displayName;
  final String joinedDaysText;

  const MyPageUserUiModel({
    required this.displayName,
    required this.joinedDaysText,
  });

  factory MyPageUserUiModel.fromDomain(User user) {
    final displayName = user.nickname ?? user.loginId;
    final days = DateTime.now().difference(user.createdAt).inDays;
    return MyPageUserUiModel(
      displayName: displayName,
      joinedDaysText: '$days',
    );
  }
}
