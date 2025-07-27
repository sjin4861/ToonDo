import 'package:hive/hive.dart';
import 'package:data/models/user_model.dart';
import 'package:domain/entities/user.dart';
import 'package:injectable/injectable.dart';
@LazySingleton()
class UserLocalDatasource {
  Box<UserModel> userBox;

  UserLocalDatasource(this.userBox);

  Future<void> saveUser(User user) async {
    final model = UserModel.fromEntity(user);
    // Assuming user.id is unique and non-null.
    await userBox.put('currentUser', model);
  }

  Future<String?> getUserNickname() async {
    final model = userBox.get('currentUser');
    return model?.getNickname();
  }

  Future<User> getUser() async {
    final model = userBox.get('currentUser');
    if (model == null) {
      print('[UserLocalDatasource] 현재 사용자 정보가 없습니다. 기본 사용자 생성');
      // 기본 사용자 정보 생성
      final defaultUser = User(
        id: 1,
        nickname: '사용자',
        loginId: 'default_user',
        points: 0,
        phoneNumber: '010-0000-0000', // 기본 휴대전화 번호 추가
      );
      await saveUser(defaultUser);
      return defaultUser;
    }
    print('[UserLocalDatasource] 현재 사용자 정보: ${model.nickname}');
    return model.toEntity();
  }

  Future<void> updateUserPoints(int newPoint) async {
    final model = userBox.get('currentUser');
    if (model != null) {
      model.points += newPoint;
      await userBox.put('currentUser', model);
    }
  }

  Future<void> setNickName(String newNickName) async {
    print('[UserLocalDatasource] 닉네임 설정 시작: $newNickName');
    final model = userBox.get('currentUser');
    if (model != null) {
      model.nickname = newNickName;
      await userBox.put('currentUser', model);
      print('[UserLocalDatasource] 닉네임 설정 완료: ${model.nickname}');
    } else {
      print('[UserLocalDatasource] 사용자 모델이 null입니다. 새로 생성합니다.');
      final newUser = User(
        id: 1,
        nickname: newNickName,
        loginId: 'default_user',
        points: 0,
        phoneNumber: '010-0000-0000', // 기본 휴대전화 번호 추가
      );
      await saveUser(newUser);
    }
  }

  Future<void> setPhoneNumber(String newPhoneNumber) async {
    print('[UserLocalDatasource] 휴대전화 번호 설정 시작: $newPhoneNumber');
    final model = userBox.get('currentUser');
    if (model != null) {
      model.phoneNumber = newPhoneNumber;
      await userBox.put('currentUser', model);
      print('[UserLocalDatasource] 휴대전화 번호 설정 완료: ${model.phoneNumber}');
    } else {
      print('[UserLocalDatasource] 사용자 모델이 null입니다. 새로 생성합니다.');
      final newUser = User(
        id: 1,
        nickname: '사용자',
        loginId: 'default_user',
        points: 0,
        phoneNumber: newPhoneNumber,
      );
      await saveUser(newUser);
    }
  }
}
