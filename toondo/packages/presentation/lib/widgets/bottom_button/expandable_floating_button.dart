import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:presentation/views/todo/todo_manage_view.dart';
import 'package:presentation/viewmodels/character/slime_character_viewmodel.dart';
// import 'package:toondo/views/todo/todo_submission_screen.dart';

class ExpandableFab extends StatefulWidget {
  const ExpandableFab({Key? key}) : super(key: key);

  @override
  _ExpandableFabState createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  bool _isOpen = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    if (_isOpen) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    setState(() {
      _isOpen = !_isOpen;
    });
  }

  // 공통 FAB 디자인 위젯 생성
  Widget _buildFab({required Widget icon, required VoidCallback onPressed, bool mini = true}) {
    final double size = mini ? 32 : 40; // 미니 FAB는 약간 작은 사이즈
    return FloatingActionButton(
      heroTag: null,
      onPressed: onPressed,
      backgroundColor: Colors.white,
      elevation: 0,
      mini: mini,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(1000), // 변경된 부분
        side: const BorderSide(width: 0.5, color: Color(0x3F1B1C1B)),
      ),
      child: SizedBox(
        width: size - 8, // 내부 패딩 고려
        height: size - 8,
        child: Center(child: icon),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final slimeVM =
        Provider.of<SlimeCharacterViewModel>(context, listen: false);

    return SizedBox(
      width: 100,
      height: 100,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // 캐릭터 상호작용 옵션 (오른쪽 위에 위치)
          Positioned(
            bottom: 0,
            right: 50,
            child: ScaleTransition(
              scale: _animation,
              child: _buildFab(
                mini: true,
                icon: const Icon(Icons.tag_faces, color: Colors.blueAccent, size: 16),
                onPressed: () {
                  final animations = <void Function()>[
                    slimeVM.setAngry,
                    slimeVM.setHappy,
                    slimeVM.setShine,
                    slimeVM.setMelt,
                  ];
                  final randomAnimation = animations[Random().nextInt(animations.length)];
                  randomAnimation();
                  _toggle();
                },
              ),
            ),
          ),
          // 투두 작성 옵션 (왼쪽 위에 위치)
          Positioned(
            bottom: 0,
            left: 50,
            child: ScaleTransition(
              scale: _animation,
              child: _buildFab(
                mini: true,
                icon: const Icon(Icons.check_box, color: Colors.blueAccent, size: 16),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TodoManageView()),
                  );
                  _toggle();
                },
              ),
            ),
          ),
          // 메인 FAB (하단 중앙)
          Positioned(
            bottom: 20,
            child: _buildFab(
              mini: false,
              icon: SvgPicture.asset(
                'assets/icons/ic_plus.svg',
                width: 20,
                height: 20,
                color: Colors.blueAccent,
              ),
              onPressed: _toggle,
            ),
          ),
        ],
      ),
    );
  }
}