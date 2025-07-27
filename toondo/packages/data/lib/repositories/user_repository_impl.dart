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
      // 임시 테스트를 위해 로컬에서만 업데이트하는 방식으로 변경
      print('[UserRepository] 로컬 데이터소스에서 닉네임 업데이트 중...');
      await localDatasource.setNickName(newNickName);
      
      // 현재 사용자 정보를 가져와서 업데이트된 정보 반환
      final updatedUser = await localDatasource.getUser();
      print('[UserRepository] 닉네임 변경 성공: ${updatedUser.nickname}');
      
      // 나중에 서버 연동이 필요할 때 주석 해제
      // final updatedUser = await remoteDatasource.changeNickName(newNickName);
      // await localDatasource.setNickName(newNickName);
      
      return updatedUser;
    } catch (e) {
      print('[UserRepository] 닉네임 변경 실패: $e');
      rethrow;
    }
  }

  @override
  Future<User> updateUserPoints(int newPoint) async {
    final updatedUser = await remoteDatasource.updateUserPoints(newPoint);
    await localDatasource.updateUserPoints(newPoint);
    return updatedUser;
  }

  @override
  Future<String?> getUserNickname() async {
    return localDatasource.getUserNickname();
  }

  @override
  Future<User> getUser() {
    final model = localDatasource.getUser();
    return model;
  }

  @override
  Future<void> deleteAccount() async {
    // TODO: 백엔드 API 호출로 계정 삭제
    // await remoteDatasource.deleteAccount();
    
    // 로컬 데이터 삭제
    await localDatasource.clearUser();
    print('[UserRepository] 계정 삭제 완료');
  }
}
