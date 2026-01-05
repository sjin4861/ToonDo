import 'dart:io';
import 'dart:typed_data';
import 'package:hive/hive.dart';
import 'package:data/models/custom_icon_model.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;

/// 커스텀 아이콘의 로컬 파일 저장 및 관리를 담당하는 DataSource
@LazySingleton()
class CustomIconLocalDatasource {
  final Box<CustomIconModel> customIconBox;
  static const String _customIconsDirName = 'custom_icons';
  static const int _thumbnailSize = 256; // 썸네일 크기 (256x256) - 정사각형 센터 크롭 후 리사이즈

  CustomIconLocalDatasource(this.customIconBox);

  /// 커스텀 아이콘 디렉토리 경로 가져오기
  Future<Directory> _getCustomIconsDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final customIconsDir = Directory('${appDir.path}/$_customIconsDirName');
    if (!await customIconsDir.exists()) {
      await customIconsDir.create(recursive: true);
    }
    return customIconsDir;
  }

  /// 이미지를 정사각형 센터 크롭 후 썸네일로 리사이즈하고 저장
  /// [imageBytes] 원본 이미지 바이트
  /// [fileName] 저장할 파일명 (확장자 포함)
  /// Returns: 저장된 파일의 경로
  Future<String> saveCustomIcon(Uint8List imageBytes, String fileName) async {
    try {
      // 이미지 디코딩
      final originalImage = img.decodeImage(imageBytes);
      if (originalImage == null) {
        throw Exception('이미지를 디코딩할 수 없습니다.');
      }

      // 정사각형 센터 크롭
      final croppedImage = _cropCenterSquare(originalImage);

      // 썸네일 크기로 리사이즈 (256x256)
      final resizedImage = img.copyResize(
        croppedImage,
        width: _thumbnailSize,
        height: _thumbnailSize,
        interpolation: img.Interpolation.cubic,
      );

      // PNG로 인코딩
      final pngBytes = Uint8List.fromList(img.encodePng(resizedImage));

      // 파일 저장
      final customIconsDir = await _getCustomIconsDirectory();
      final file = File('${customIconsDir.path}/$fileName');
      await file.writeAsBytes(pngBytes);

      // Hive에 메타데이터 저장
      final model = CustomIconModel.fromFilePath(file.path);
      await customIconBox.put(model.id, model);

      return file.path;
    } catch (e) {
      throw Exception('커스텀 아이콘 저장 실패: $e');
    }
  }

  /// 이미지를 정사각형으로 센터 크롭
  /// [image] 원본 이미지
  /// Returns: 정사각형으로 크롭된 이미지
  img.Image _cropCenterSquare(img.Image image) {
    final int size = image.width < image.height ? image.width : image.height;
    final int offsetX = (image.width - size) ~/ 2;
    final int offsetY = (image.height - size) ~/ 2;
    return img.copyCrop(
      image,
      x: offsetX,
      y: offsetY,
      width: size,
      height: size,
    );
  }

  /// 이미지 파일을 아이콘 크기로 리사이즈하고 저장
  /// [imageFile] 원본 이미지 파일
  /// Returns: 저장된 파일의 경로
  Future<String> saveCustomIconFromFile(File imageFile) async {
    final imageBytes = await imageFile.readAsBytes();
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
    return saveCustomIcon(imageBytes, fileName);
  }

  /// 모든 커스텀 아이콘 목록 가져오기 (최근 사용 순)
  List<CustomIconModel> getAllCustomIcons() {
    final icons = customIconBox.values.toList();
    // 최근 사용 순으로 정렬
    icons.sort((a, b) {
      final aTime = a.lastUsedAt ?? a.createdAt;
      final bTime = b.lastUsedAt ?? b.createdAt;
      return bTime.compareTo(aTime);
    });
    return icons;
  }

  /// 커스텀 아이콘의 마지막 사용 시간 업데이트
  Future<void> updateLastUsed(String iconId) async {
    final model = customIconBox.get(iconId);
    if (model != null) {
      model.updateLastUsed();
      await customIconBox.put(iconId, model);
    }
  }

  /// 커스텀 아이콘 삭제
  Future<void> deleteCustomIcon(String iconId) async {
    final model = customIconBox.get(iconId);
    if (model != null) {
      // 파일 삭제
      final file = File(model.filePath);
      if (await file.exists()) {
        await file.delete();
      }
      // Hive에서 삭제
      await customIconBox.delete(iconId);
    }
  }

  /// 파일 경로로 커스텀 아이콘 찾기
  CustomIconModel? getCustomIconByPath(String filePath) {
    try {
      return customIconBox.values.firstWhere(
        (icon) => icon.filePath == filePath,
      );
    } catch (_) {
      return null;
    }
  }

  /// 커스텀 아이콘인지 확인 (경로로 판단)
  bool isCustomIcon(String? iconPath) {
    if (iconPath == null) return false;
    try {
      getCustomIconByPath(iconPath);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// 모든 커스텀 아이콘 삭제 (초기화용)
  Future<void> clearAllCustomIcons() async {
    // 모든 파일 삭제
    final customIconsDir = await _getCustomIconsDirectory();
    if (await customIconsDir.exists()) {
      await customIconsDir.delete(recursive: true);
    }
    // Hive에서 삭제
    await customIconBox.clear();
  }
}

