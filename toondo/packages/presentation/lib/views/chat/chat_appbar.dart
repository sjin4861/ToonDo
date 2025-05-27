import 'package:domain/entities/llm_engine.dart';
import 'package:domain/usecases/character/toggle_chat_mode.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:presentation/viewmodels/character/chat_viewmodel.dart';
import 'package:provider/provider.dart';

/* ───────────────────────── AppBar 분리 ───────────────────────── */
class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ChatViewModel>();

    return AppBar(
      title: Text(
        vm.engine == LlmEngine.gpt ? 'GPT 대화' : 'Gemma 대화',
        style: const TextStyle(color: Colors.black87),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.close, color: Colors.black87),
        onPressed: () async {
          await GetIt.I<ToggleChatModeUseCase>()(false);
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
        },
      ),

      /* ▼▼▼ ① 엔진 선택 드롭다운 ▼▼▼ */
      actions: [
        DropdownButtonHideUnderline(
          child: DropdownButton<LlmEngine>(
            value: vm.engine,
            borderRadius: BorderRadius.circular(12),
            onChanged: (e) {
              if (e != null) vm.changeEngine(e);
            },
            items: LlmEngine.values.map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text(e.name.toUpperCase()),
              ),
            ).toList(),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}