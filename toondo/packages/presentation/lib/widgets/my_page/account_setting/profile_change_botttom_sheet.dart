import 'package:flutter/material.dart';
import 'package:presentation/widgets/bottom_sheet/common_bottom_sheet.dart';

class ProfileChangeBotttomSheet extends StatelessWidget {
  const ProfileChangeBotttomSheet({super.key});

  // TODO: 추후 ViewModel로 대체 예정
  void _takePhoto() {
    debugPrint('사진찍기 눌림');
  }

  void _choosePhoto() {
    debugPrint('앨범선택 눌림');
  }

  @override
  Widget build(BuildContext context) {
    return CommonBottomSheet(
      title: '프로필 바꾸기',
      buttons: [
        CommonBottomSheetButtonData(
          label: '사진찍기',
          filled: true,
          onPressed: _takePhoto,
        ),
        CommonBottomSheetButtonData(
          label: '앨범선택',
          filled: false,
          onPressed: _choosePhoto,
        ),
      ],
    );
  }
}
