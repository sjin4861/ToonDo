import 'package:flutter/material.dart';
import 'package:domain/usecases/auth/delete_account.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class DeleteAccountViewModel extends ChangeNotifier {
  final DeleteAccountUseCase deleteAccountUseCase;

  DeleteAccountViewModel({required this.deleteAccountUseCase});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isDeleted = false;
  bool get isDeleted => _isDeleted;

  Future<bool> deleteAccount() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await deleteAccountUseCase();
      _isDeleted = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = '계정 탈퇴 중 오류가 발생했습니다: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
