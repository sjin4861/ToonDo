import 'package:common/gen/assets.gen.dart';
import 'package:domain/entities/user.dart';

class MyPageUserUiModel {
  final String displayName;
  final String joinedDaysText;
  final String profileImagePath;

  const MyPageUserUiModel({
    required this.displayName,
    required this.joinedDaysText,
    required this.profileImagePath,
  });

  factory MyPageUserUiModel.fromDomain(User user) {
    final displayName = user.nickname ?? user.loginId;
    final joinedDays = DateTime.now().difference(user.createdAt).inDays;

    String profileImagePath;
    if (joinedDays < 7) {
      profileImagePath = Assets.images.imgProfile1.path;
    } else if (joinedDays < 30) {
      profileImagePath = Assets.images.imgProfile2.path;
    } else {
      profileImagePath = Assets.images.imgProfile3.path;
    }

    return MyPageUserUiModel(
      displayName: displayName,
      joinedDaysText: '$joinedDays',
      profileImagePath: profileImagePath,
    );
  }
}
