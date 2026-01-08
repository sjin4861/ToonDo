import 'package:domain/entities/user.dart';
import 'package:domain/repositories/user_repository.dart';
import 'package:data/datasources/remote/user_remote_datasource.dart';
import 'package:data/datasources/local/user_local_datasource.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDatasource remoteDatasource;
  final UserLocalDatasource localDatasource;

  UserRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
  });

  @override
  Future<User> updateNickName(String newNickName) async {
    print('[UserRepository] 닉네임 변경 시작: $newNickName');
    try {
      // 실제 서버에 닉네임 변경 요청
      final updatedNickname = await remoteDatasource.changeNickName(
        newNickName,
      );
      // 현재 사용자 정보 가져오기
      final currentUser = await localDatasource.getUser();
      // 업데이트된 사용자 정보 생성
      final updatedUser = User(
        id: currentUser.id,
        nickname: updatedNickname,
        loginId: currentUser.loginId,
        createdAt: currentUser.createdAt,
      );
      // 로컬에도 변경된 정보 저장
      await localDatasource.saveUser(updatedUser);
      print('[UserRepository] 닉네임 변경 성공: $updatedNickname');
      return updatedUser;
    } catch (e) {
      print('[UserRepository] 닉네임 변경 실패: $e');
      rethrow;
    }
  }

  @override
  Future<String?> getUserNickname() async {
    return localDatasource.getUserNickname();
  }

  @override
  Future<User> getUser() async {
    try {
      final remoteUser = await remoteDatasource.getUserMe();
      await localDatasource.saveUser(remoteUser);
      return remoteUser;
    } catch (e) {
      // 인증 만료/네트워크 오류 등으로 원격 조회가 실패해도 UI가 깨지지 않도록 로컬 캐시로 fallback
      return await localDatasource.getUser();
    }
  }

  @override
  Future<void> updatePassword(String newPassword) async {
    await remoteDatasource.updatePassword(newPassword);
  }

  @override
  Future<void> deleteAccount() async {
    // 서버에서 계정 삭제
    await remoteDatasource.deleteAccount();

    // 로컬 데이터 삭제
    await localDatasource.clearUser();
    print('[UserRepository] 계정 삭제 완료');
  }
}
