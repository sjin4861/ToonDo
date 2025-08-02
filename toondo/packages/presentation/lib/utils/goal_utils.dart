import 'package:common/gen/assets.gen.dart';
import 'package:domain/entities/goal.dart';
import 'package:intl/intl.dart';
import 'package:domain/entities/status.dart';

/// 날짜를 문자열로 반환
String buildGoalSubtitle(DateTime startDate, DateTime endDate) {
  final start = DateFormat('yyyy.MM.dd').format(startDate);
  final end = DateFormat('yyyy.MM.dd').format(endDate);
  return '$start ~ $end';
}

/// 목표가 완료 상태인지 여부
bool isGoalChecked(Status status) {
  return status == Status.completed;
}

/// 목표 종료일 기준 D-Day 계산
int calculateDDay(DateTime endDate) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final diff = endDate.difference(today).inDays;
  return diff >= 0 ? diff : 0;
}

/// 아이콘 이름이 비어 있거나 경로가 이상할 경우 경로 보정
String resolveGoalIconPath(String? iconName) {
  if (iconName == null || iconName.isEmpty) {
    return Assets.icons.icHelpCircle.path;
  }

  final fileName = iconName.split('/').last;
  final normalized = fileName.startsWith('ic_') ? fileName : 'ic_$fileName';
  return 'assets/icons/$normalized';
}

Map<String, List<Goal>> groupGoalsByCompletion(List<Goal> goals) {
  final now = DateTime.now();

  final succeeded = goals
      .where((g) => g.status == Status.completed)
      .toList();
  final failed = goals
      .where((g) => g.status == Status.active && g.endDate.isBefore(now))
      .toList();
  final givenUp = goals
      .where((g) => g.status == Status.givenUp)
      .toList();

  return {
    '성공': succeeded,
    '실패': failed,
    '포기': givenUp,
  };
}
