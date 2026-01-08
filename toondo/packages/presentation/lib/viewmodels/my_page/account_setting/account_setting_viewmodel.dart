import 'package:common/constants/auth_constraints.dart';
import 'package:domain/usecases/user/get_user.dart';
import 'package:domain/usecases/user/update_password.dart';
import 'package:domain/usecases/user/update_nickname.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:presentation/models/my_page_user_ui_model.dart';
import 'package:presentation/viewmodels/my_page/my_page_viewmodel.dart';

@injectable
class AccountSettingViewModel extends ChangeNotifier {
  final GetUserUseCase getUserUseCase;
  final UpdateNickNameUseCase updateNickNameUseCase;
  final UpdatePasswordUseCase updatePasswordUseCase;
  final MyPageViewModel myPageViewModel;

  AccountSettingViewModel({
    required this.getUserUseCase,
    required this.updateNickNameUseCase,
    required this.updatePasswordUseCase,
    required this.myPageViewModel,
  });

  Future<void> logout() async {
    await myPageViewModel.logout();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  MyPageUserUiModel? _userUiModel;
  MyPageUserUiModel? get userUiModel => _userUiModel;

  String? _nicknameErrorMessage;
  String? get nicknameErrorMessage => _nicknameErrorMessage;

  String? _currentPasswordError;
  String? _newPasswordError;
  String? _confirmPasswordError;

  String? get currentPasswordError => _currentPasswordError;
  String? get newPasswordError => _newPasswordError;
  String? get confirmPasswordError => _confirmPasswordError;

  Future<void> loadUser() async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = await getUserUseCase();
      _userUiModel = MyPageUserUiModel.fromDomain(user);
    } catch (e) {
      // Handle user load error if needed
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateNickname(String newNickname) async {
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
      final updatedUser = await updateNickNameUseCase(newNickname);
      _userUiModel = MyPageUserUiModel.fromDomain(updatedUser);
      myPageViewModel.loadUser();
      return true;
    } catch (e) {
      _nicknameErrorMessage = '닉네임 변경에 실패했습니다: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updatePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    if (!validatePasswordChangeInputs(
      currentPassword,
      newPassword,
      confirmPassword,
    )) {
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      await updatePasswordUseCase(newPassword);
      return true;
    } catch (e) {
      _currentPasswordError = '비밀번호 변경에 실패했습니다.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool validatePasswordChangeInputs(
    String current,
    String newPwd,
    String confirmPwd,
  ) {
    _currentPasswordError = null;
    _newPasswordError = null;
    _confirmPasswordError = null;

    if (current.isEmpty) {
      _currentPasswordError = AuthConstraints.passwordEmptyError;
    }

    if (newPwd.isEmpty) {
      _newPasswordError = AuthConstraints.passwordEmptyError;
    } else {
      if (newPwd.length < AuthConstraints.passwordMinLength ||
          newPwd.length > AuthConstraints.passwordMaxLength) {
        _newPasswordError = AuthConstraints.passwordLengthError;
      } else if (!RegExp(AuthConstraints.passwordPattern).hasMatch(newPwd)) {
        _newPasswordError = AuthConstraints.passwordFormatError;
      }
    }

    if (confirmPwd.isEmpty) {
      _confirmPasswordError = AuthConstraints.confirmPasswordEmptyError;
    } else if (newPwd != confirmPwd) {
      _confirmPasswordError = AuthConstraints.confirmPasswordMismatchError;
    }

    notifyListeners();

    return _currentPasswordError == null &&
        _newPasswordError == null &&
        _confirmPasswordError == null;
  }
}
