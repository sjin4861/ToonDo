import 'package:domain/usecases/user/get_user.dart';
import 'package:domain/usecases/user/update_nickname.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:presentation/models/account_setting_user_ui_model.dart';

@injectable
class AccountSettingViewModel extends ChangeNotifier {
  final GetUserUseCase getUserUseCase;
  final UpdateNickNameUseCase updateNickNameUseCase;

  AccountSettingViewModel({
    required this.getUserUseCase,
    required this.updateNickNameUseCase,
  });

  String? _errorMessage;
  bool _isLoading = false;

  String? get errorMessage => _errorMessage;

  bool get isLoading => _isLoading;

  AccountSettingUserUiModel? _userUiModel;

  AccountSettingUserUiModel? get userUiModel => _userUiModel;

  Future<void> loadUser() async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = await getUserUseCase();
      _userUiModel = AccountSettingUserUiModel(
        nickname: user.nickname ?? '', // todo 기본값 추후 수정
        phoneNumber: user.phoneNumber ?? '010-1234-5678', // todo 기본값 추후 수정
      );
      _errorMessage = null;
    } catch (e) {
      _errorMessage = '유저 정보를 불러오는 데 실패했습니다.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String? _nicknameErrorMessage;

  String? get nicknameErrorMessage => _nicknameErrorMessage;

  Future<bool> updateNickname(String newNickname) async {
    if (newNickname.trim().isEmpty) {
      _nicknameErrorMessage = '신규 닉네임을 입력해주세요';
      notifyListeners();
      return false;
    }

    try {
      final updatedUser = await updateNickNameUseCase(newNickname);
      _userUiModel = AccountSettingUserUiModel.fromDomain(updatedUser);
      _nicknameErrorMessage = null;
      notifyListeners();
      return true;
    } catch (e) {
      _nicknameErrorMessage = '닉네임 변경에 실패했습니다';
      notifyListeners();
      return false;
    }
  }
}
