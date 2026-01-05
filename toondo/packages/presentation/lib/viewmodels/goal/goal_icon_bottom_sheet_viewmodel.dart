import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:domain/repositories/custom_icon_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:presentation/views/goal/widget/image_crop_screen.dart';

@injectable
class GoalIconBottomSheetViewModel extends ChangeNotifier {
  final CustomIconRepository _customIconRepository;
  final ImagePicker _imagePicker = ImagePicker();

  GoalIconBottomSheetViewModel(this._customIconRepository) {
    loadCustomIcons();
  }

  List<String> _customIconPaths = [];
  List<String> get customIconPaths => _customIconPaths;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// 커스텀 아이콘 목록 로드
  void loadCustomIcons() {
    _customIconPaths = _customIconRepository.getAllCustomIconPaths();
    notifyListeners();
  }

  /// 갤러리에서 이미지 선택 및 저장
  Future<String?> pickImageFromGallery(BuildContext context) async {
    try {
      _errorMessage = null;
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
      );

      if (image == null) {
        return null;
      }

      // 원형 크롭 화면으로 이동
      final File imageFile = File(image.path);
      final String? croppedImagePath = await Navigator.of(context).push<String>(
        MaterialPageRoute(
          builder: (context) => ImageCropScreen(imageFile: imageFile),
          fullscreenDialog: true,
        ),
      );

      if (croppedImagePath == null) {
        return null;
      }

      final File croppedImageFile = File(croppedImagePath);
      // 이미지 저장 및 리사이즈
      final savedPath = await _customIconRepository.saveCustomIcon(croppedImageFile);

      // 임시 파일 삭제
      try {
        await croppedImageFile.delete();
      } catch (_) {
        // 삭제 실패해도 무시
      }

      // 목록 새로고침
      loadCustomIcons();

      // 사용 시간 업데이트
      await _customIconRepository.updateLastUsed(savedPath);

      return savedPath;
    } catch (e) {
      _errorMessage = '이미지 선택 실패: $e';
      notifyListeners();
      return null;
    }
  }

  /// 커스텀 아이콘 사용 시간 업데이트
  Future<void> updateLastUsed(String iconPath) async {
    await _customIconRepository.updateLastUsed(iconPath);
    notifyListeners();
  }

  /// 커스텀 아이콘 삭제
  Future<void> deleteCustomIcon(String iconPath) async {
    try {
      _errorMessage = null;
      await _customIconRepository.deleteCustomIcon(iconPath);
      loadCustomIcons();
    } catch (e) {
      _errorMessage = '아이콘 삭제 실패: $e';
      notifyListeners();
    }
  }
}

