import 'package:flutter/material.dart';
import 'package:domain/usecases/character/toggle_chat_mode.dart';
import 'package:get_it/get_it.dart';
import 'package:presentation/navigation/route_paths.dart';

class ChatToggleButton extends StatelessWidget {
  final bool enabled;
  const ChatToggleButton({super.key, required this.enabled});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(enabled ? Icons.chat_bubble : Icons.chat_bubble_outline),
      onPressed: () async {
        if (enabled) {
          // OFF → 홈 복귀는 SlimeChatPage 의 close 버튼이 담당
          return;
        }
        // 1) 상태 ON
        await GetIt.I<ToggleChatModeUseCase>()(true);
        // 2) 화면 전환
        // ignore: use_build_context_synchronously
        Navigator.pushNamed(context, RoutePaths.slimeChat);
      },
    );
  }
}
