import 'dart:io';

/// 커스텀 아이콘 관리를 위한 Repository 인터페이스
abstract class CustomIconRepository {
  /// 이미지 파일을 아이콘 크기로 리사이즈하고 저장
  /// [imageFile] 갤러리에서 선택한 이미지 파일
  /// Returns: 저장된 파일의 경로
  Future<String> saveCustomIcon(File imageFile);

  /// 모든 커스텀 아이콘 경로 목록 가져오기 (최근 사용 순)
  List<String> getAllCustomIconPaths();

  /// 커스텀 아이콘의 마지막 사용 시간 업데이트
  Future<void> updateLastUsed(String iconPath);

  /// 커스텀 아이콘 삭제
  Future<void> deleteCustomIcon(String iconPath);

  /// 커스텀 아이콘인지 확인
  bool isCustomIcon(String? iconPath);
}

