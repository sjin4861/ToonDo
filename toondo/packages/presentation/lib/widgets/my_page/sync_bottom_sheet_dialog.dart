import 'package:flutter/material.dart';
import 'package:presentation/widgets/bottom_sheet/common_bottom_sheet.dart';

class SyncBottomSheetDialog extends StatelessWidget {
  const SyncBottomSheetDialog({super.key});

  // TODO: 추후 ViewModel로 대체 예정
  void _handleLoad() {
    debugPrint('불러오기 눌림');
  }

  void _handleSave() {
    debugPrint('저장하기 눌림');
  }

  @override
  Widget build(BuildContext context) {
    return CommonBottomSheet(
      title: '동기화 하기',
      buttons: [
        CommonBottomSheetButtonData(
          label: '불러오기',
          filled: true,
          onPressed: _handleLoad,
        ),
        CommonBottomSheetButtonData(
          label: '저장하기',
          filled: false,
          onPressed: _handleSave,
        ),
      ],
    );
  }
}
