import 'package:domain/usecases/character/toggle_chat_mode.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
import 'package:presentation/viewmodels/character/chat_viewmodel.dart';
import 'package:presentation/widgets/character/slime_area.dart';
import 'package:presentation/widgets/character/chat_input_bar.dart'; // 아래 3‑항 참조
import 'package:presentation/widgets/home/home_background.dart';

class SlimeChatPage extends StatelessWidget {
  const SlimeChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: GetIt.I<ChatViewModel>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('대화모드'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.black87),
            onPressed: () async {
              await GetIt.I<ToggleChatModeUseCase>()(false); // 상태 OFF
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
            },
          ),
        ),
        body: const _ChatScreen(),
      ),
    );
  }
}

class _ChatScreen extends StatelessWidget {
  const _ChatScreen();

  // SlimeArea 크기 조절
  static const double _slimeHeight = 360;
  static const double _inputBarH  = 84;

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ChatViewModel>();
    final viewInsets = MediaQuery.of(context).viewInsets;
    final keyboard = viewInsets.bottom;

    return Scaffold(
      body: Stack(
        children: [
          const HomeBackground(),

          // ─── (1) 채팅 리스트 ─────────────────────────────
          Padding(
            padding: EdgeInsets.only(
              top: 60,
              bottom: _slimeHeight + _inputBarH,
            ),
            child: ListView.builder(
              reverse: true,
              itemCount: vm.messages.length,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (_, i) {
                final msg = vm.messages.reversed.elementAt(i);
                final isUser = i.isOdd;
                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.center,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isUser
                          ? const Color(0xfffef3d4)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      msg.message ?? '',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                );
              },
            ),
          ),

          // ─── (2) 슬라임 + 그림자 ─────────────────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: _inputBarH + keyboard, // 키보드 뜨면 자동 위로
            height: _slimeHeight,
            child: Center(
              child: SizedBox(
                height: _slimeHeight,
                width: _slimeHeight,
                child: SlimeArea(),
              ),
            ),
          ),

          // ─── (3) 입력 바 ────────────────────────────────
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: AnimatedPadding(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.only(bottom: keyboard),
                child: ChatInputBar(
                  onSend: (t, g, d) =>
                      vm.send(text: t, goals: g, todos: d),
                  isSending: vm.isSending,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
