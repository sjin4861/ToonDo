import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
import 'package:presentation/viewmodels/settings/delete_account_viewmodel.dart';
import 'package:presentation/views/welcome/welcome_screen.dart';

class DeleteAccountScreen extends StatelessWidget {
  const DeleteAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DeleteAccountViewModel>.value(
      value: GetIt.instance<DeleteAccountViewModel>(),
      child: Consumer<DeleteAccountViewModel>(
        builder: (context, viewModel, child) {
          // 계정 탈퇴 완료 시 Welcome 화면으로 이동
          if (viewModel.isDeleted) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => WelcomeScreen()),
                (route) => false,
              );
            });
          }

          return Scaffold(
            backgroundColor: Color(0xFFFCFCFC),
            appBar: AppBar(
              backgroundColor: Color(0xFFFCFCFC),
              elevation: 0.5,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Color(0xFF1C1D1B)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Text(
                '계정 탈퇴',
                style: TextStyle(
                  color: Color(0xFF1C1D1B),
                  fontSize: 16,
                  fontFamily: 'Pretendard Variable',
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.24,
                ),
              ),
              centerTitle: false,
            ),
            body: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 32),
                  Text(
                    '정말 계정을 탈퇴하시겠어요?',
                    style: TextStyle(
                      color: Color(0xFF1C1D1B),
                      fontSize: 20,
                      fontFamily: 'Pretendard Variable',
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.30,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '계정을 탈퇴하면 다음 정보들이 모두 삭제됩니다:',
                    style: TextStyle(
                      color: Color(0xFF1C1D1B),
                      fontSize: 14,
                      fontFamily: 'Pretendard Variable',
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.21,
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildWarningItem('• 모든 개인 정보 및 설정'),
                  _buildWarningItem('• 작성한 할 일 및 목표'),
                  _buildWarningItem('• 캐릭터 및 포인트'),
                  _buildWarningItem('• 앱 사용 기록'),
                  SizedBox(height: 24),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFFFFF4E6),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Color(0xFFFFB800)),
                    ),
                    child: Row(
                      children: [
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
                    SizedBox(height: 16),
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color(0xFFFFEBEB),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Color(0xFFEE0F12)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error, color: Color(0xFFEE0F12), size: 16),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              viewModel.errorMessage!,
                              style: TextStyle(
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
                  Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: viewModel.isLoading ? null : () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFEEEEEE),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(1000),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(
                            '취소',
                            style: TextStyle(
                              color: Color(0xFF1C1D1B),
                              fontSize: 16,
                              fontFamily: 'Pretendard Variable',
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.24,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: viewModel.isLoading ? null : () {
                            _showDeleteConfirmDialog(context, viewModel);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFEE0F12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(1000),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: viewModel.isLoading
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : Text(
                                  '탈퇴하기',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'Pretendard Variable',
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.24,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWarningItem(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Text(
        text,
        style: TextStyle(
          color: Color(0xFF666666),
          fontSize: 12,
          fontFamily: 'Pretendard Variable',
          fontWeight: FontWeight.w400,
          letterSpacing: 0.18,
        ),
      ),
    );
  }

  void _showDeleteConfirmDialog(BuildContext context, DeleteAccountViewModel viewModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            '최종 확인',
            style: TextStyle(
              color: Color(0xFF1C1D1B),
              fontSize: 18,
              fontFamily: 'Pretendard Variable',
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            '정말로 계정을 탈퇴하시겠습니까?\n\n이 작업은 되돌릴 수 없습니다.',
            style: TextStyle(
              color: Color(0xFF1C1D1B),
              fontSize: 14,
              fontFamily: 'Pretendard Variable',
              fontWeight: FontWeight.w400,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                '취소',
                style: TextStyle(
                  color: Color(0xFF666666),
                  fontSize: 14,
                  fontFamily: 'Pretendard Variable',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await viewModel.deleteAccount();
              },
              child: Text(
                '탈퇴',
                style: TextStyle(
                  color: Color(0xFFEE0F12),
                  fontSize: 14,
                  fontFamily: 'Pretendard Variable',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
