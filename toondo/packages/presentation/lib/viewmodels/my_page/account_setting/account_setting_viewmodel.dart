import 'package:domain/usecases/user/get_user.dart';
import 'package:domain/usecases/user/update_nickname.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:presentation/models/account_setting_user_ui_model.dart';
import 'package:presentation/viewmodels/my_page/my_page_viewmodel.dart';

@injectable
class AccountSettingViewModel extends ChangeNotifier {
  final GetUserUseCase getUserUseCase;
  final UpdateNickNameUseCase updateNickNameUseCase;
  final MyPageViewModel myPageViewModel;

  AccountSettingViewModel({
    required this.getUserUseCase,
    required this.updateNickNameUseCase,
    required this.myPageViewModel,
  });

  String? _errorMessage;
  bool _isLoading = false;

  String? get errorMessage => _errorMessage;

  bool get isLoading => _isLoading;

  AccountSettingUserUiModel? _userUiModel;

  AccountSettingUserUiModel? get userUiModel => _userUiModel;

  /// 휴대전화 번호를 보기 좋은 형태로 포맷팅
  String _formatPhoneNumber(String phoneNumber) {
    // 숫자만 추출
    final digits = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    
    // 11자리 휴대전화 번호인지 확인
    if (digits.length == 11 && digits.startsWith('010')) {
      return '${digits.substring(0, 3)}-${digits.substring(3, 7)}-${digits.substring(7)}';
    }
    
    // 원본 반환 (포맷팅 불가능한 경우)
    return phoneNumber;
  }

  Future<void> loadUser() async {
    print('[AccountSettingViewModel] 사용자 정보 로드 시작');
    _isLoading = true;
    notifyListeners();

    try {
      final user = await getUserUseCase();
      print('[AccountSettingViewModel] 로드된 사용자 정보:');
      print('  - 닉네임: ${user.nickname}');
      print('  - 휴대전화: ${user.phoneNumber}');
      print('  - ID: ${user.id}');
      print('  - loginId: ${user.loginId}');
      
      _userUiModel = AccountSettingUserUiModel(
        nickname: user.nickname ?? '닉네임 없음',
        phoneNumber: user.phoneNumber != null 
            ? _formatPhoneNumber(user.phoneNumber!) 
            : _formatPhoneNumber(user.loginId),
      );
      print('[AccountSettingViewModel] UI 모델 생성 완료: ${_userUiModel?.nickname}, ${_userUiModel?.phoneNumber}');
      _errorMessage = null;
    } catch (e) {
      print('[AccountSettingViewModel] 사용자 정보 로드 실패: $e');
      _errorMessage = '유저 정보를 불러오는 데 실패했습니다.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String? _nicknameErrorMessage;

  String? get nicknameErrorMessage => _nicknameErrorMessage;

  Future<bool> updateNickname(String newNickname) async {
    print('[AccountSettingViewModel] 닉네임 변경 요청: $newNickname');
    
    if (newNickname.trim().isEmpty) {
      _nicknameErrorMessage = '신규 닉네임을 입력해주세요';
      notifyListeners();
      return false;
    }

    if (newNickname.length < 2) {
      _nicknameErrorMessage = '닉네임은 2글자 이상이어야 합니다';
      notifyListeners();
      return false;
    }

    if (newNickname.length > 10) {
      _nicknameErrorMessage = '닉네임은 10글자 이하여야 합니다';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _nicknameErrorMessage = null;
    notifyListeners();

    try {
      print('[AccountSettingViewModel] UseCase 호출 시작...');
      final updatedUser = await updateNickNameUseCase(newNickname);
      print('[AccountSettingViewModel] UseCase 호출 성공: ${updatedUser.nickname}');
      
      _userUiModel = AccountSettingUserUiModel.fromDomain(updatedUser);
      print('[AccountSettingViewModel] UI 모델 업데이트 완료');
      
      // MyPageViewModel도 새로고침
      print('[AccountSettingViewModel] MyPageViewModel 새로고침...');
      myPageViewModel.loadUser();
      
      return true;
    } catch (e) {
      print('[AccountSettingViewModel] 닉네임 변경 실패: $e');
      _nicknameErrorMessage = '닉네임 변경에 실패했습니다: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
