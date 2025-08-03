import 'package:flutter/material.dart';
import 'package:presentation/viewmodels/settings/delete_account_viewmodel.dart';
import 'package:provider/provider.dart';

class DeleteAccountBody extends StatelessWidget {
  const DeleteAccountBody({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DeleteAccountViewModel>();

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          const Text(
            '정말 계정을 탈퇴하시겠어요?',
            style: TextStyle(
              color: Color(0xFF1C1D1B),
              fontSize: 20,
              fontFamily: 'Pretendard Variable',
              fontWeight: FontWeight.w700,
              letterSpacing: 0.30,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '계정을 탈퇴하면 다음 정보들이 모두 삭제됩니다:',
            style: TextStyle(
              color: Color(0xFF1C1D1B),
              fontSize: 14,
              fontFamily: 'Pretendard Variable',
              fontWeight: FontWeight.w400,
              letterSpacing: 0.21,
            ),
          ),
          const SizedBox(height: 16),
          ...[
            '• 모든 개인 정보 및 설정',
            '• 작성한 할 일 및 목표',
            '• 캐릭터 및 포인트',
            '• 앱 사용 기록',
          ].map(_buildWarningItem).toList(),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF4E6),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFFFB800)),
            ),
            child: Row(
              children: const [
                Icon(Icons.warning, color: Color(0xFFFFB800), size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '삭제된 데이터는 복구할 수 없습니다.',
                    style: TextStyle(
                      color: Color(0xFF1C1D1B),
                      fontSize: 12,
                      fontFamily: 'Pretendard Variable',
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.18,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (viewModel.errorMessage != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFEBEB),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFEE0F12)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error, color: Color(0xFFEE0F12), size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      viewModel.errorMessage!,
                      style: const TextStyle(
                        color: Color(0xFFEE0F12),
                        fontSize: 12,
                        fontFamily: 'Pretendard Variable',
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildWarningItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF666666),
          fontSize: 12,
          fontFamily: 'Pretendard Variable',
          fontWeight: FontWeight.w400,
          letterSpacing: 0.18,
        ),
      ),
    );
  }
}
