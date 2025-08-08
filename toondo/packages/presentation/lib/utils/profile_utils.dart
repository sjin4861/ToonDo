import 'package:common/gen/assets.gen.dart';

String getProfileImageAssetByJoinedDays(int joinedDays) {
  if (joinedDays <= 10) {
    return Assets.images.imgProfile1.path;
  } else if (joinedDays <= 30) {
    return Assets.images.imgProfile2.path;
  } else {
    return Assets.images.imgProfile3.path;
  }
}
