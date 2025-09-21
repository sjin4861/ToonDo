import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:domain/entities/goal.dart';
import 'package:domain/usecases/goal/create_goal_remote.dart';
import 'package:domain/usecases/goal/save_goal_local.dart';
import 'package:domain/usecases/goal/update_goal_remote.dart';
import 'package:domain/usecases/goal/update_goal_local.dart';
import 'package:presentation/designsystem/components/calendars/calendar_bottom_sheet.dart';
import 'package:uuid/uuid.dart';
import 'package:injectable/injectable.dart';
import 'package:get_it/get_it.dart';
import 'package:presentation/viewmodels/home/home_viewmodel.dart';

@LazySingleton()
class GoalInputViewModel extends ChangeNotifier {
  final TextEditingController goalNameController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final DateFormat dateFormat = DateFormat('yyyy년 M월 d일');

  DateTime? startDate;
  DateTime? endDate;
  String? selectedIcon;

  String? goalNameError;
  String? dateError;

  bool withoutDeadline = false;
  // TODO: UX 개선 - showOnHome 기본값을 true로 변경 고려
  // TODO: 현재 false로 설정되어 있어 사용자가 명시적으로 토글을 켜야 메인화면에 표시됨
  // TODO: true로 변경하면 모든 새 목표가 기본적으로 메인화면에 표시되어 더 직관적
  // TODO: 단점: 메인화면이 복잡해질 수 있음, 사용자 선택권 감소
  bool showOnHome = false; // 기본값 유지 (변경 시 true로 수정)

  final Goal? targetGoal;
  final CreateGoalRemoteUseCase createGoalRemoteUseCase;
  final SaveGoalLocalUseCase saveGoalLocalUseCase;
  final UpdateGoalRemoteUseCase updateGoalRemoteUseCase;
  final UpdateGoalLocalUseCase updateGoalLocalUseCase;
  final bool isFromOnboarding;

  GoalInputViewModel({
    required this.createGoalRemoteUseCase,
    required this.saveGoalLocalUseCase,
    required this.updateGoalRemoteUseCase,
    required this.updateGoalLocalUseCase,
    this.targetGoal,
    this.isFromOnboarding = false,
  }) {
    if (targetGoal != null) {
      goalNameController.text = targetGoal!.name;
      startDate = targetGoal!.startDate;
      endDate = targetGoal!.endDate;
      selectedIcon = targetGoal!.icon;
      showOnHome = targetGoal!.showOnHome;
      // 마감일 없이 할래요 상태 설정: endDate가 null이면 withoutDeadline을 true로 설정
      withoutDeadline = targetGoal!.endDate == null;
    }
  }

  @override
  void dispose() {
    goalNameController.dispose();
    super.dispose();
  }

  Future<Goal?> saveGoal(BuildContext context) async {
    if (!validateInput()) {
      try {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('입력한 정보를 확인해주세요.')));
      } catch (_) {}
      return null;
    }

    const String defaultIconPath = 'assets/icons/ic_100point.svg';
    
    // TODO: 메인화면 노출 문제 디버깅 - 목표 생성 시 showOnHome 값 로깅
    print('🔍 목표 생성 시 showOnHome 값: $showOnHome');
    
    final newGoal = Goal(
      id: targetGoal?.id ?? const Uuid().v4(),
      name: goalNameController.text,
      icon: selectedIcon ?? defaultIconPath,
      startDate: startDate!,
      // 마감일 없이 할래요 기능: withoutDeadline이 true이면 endDate를 null로 설정
      endDate: withoutDeadline ? null : endDate,
      progress: targetGoal?.progress ?? 0.0,
      showOnHome: showOnHome,
    );

    print('🔍 생성된 목표 정보: ${newGoal.name}, showOnHome: ${newGoal.showOnHome}');

    try {
      if (targetGoal == null) {
        final created = await createGoalRemoteUseCase(newGoal);
        await saveGoalLocalUseCase(created);
        
        // 홈 뷰모델 동기화 - 목표 생성 후 홈 화면 업데이트
        try {
          await GetIt.instance<HomeViewModel>().loadGoals();
          print('🔄 목표 생성 후 홈 뷰모델 동기화 완료');
        } catch (e) {
          print('⚠️ 홈 뷰모델 동기화 실패: $e');
        }
        
        try {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('목표가 성공적으로 저장되었습니다.')));
        } catch (_) {}
        // Reset input fields for new goal.
        goalNameController.clear();
        startDate = null;
        endDate = null;
        selectedIcon = null;
        notifyListeners();
        return created;
      } else {
        await updateGoalRemoteUseCase(newGoal);
        await updateGoalLocalUseCase(newGoal);
        
        // 홈 뷰모델 동기화 - 목표 수정 후 홈 화면 업데이트
        try {
          await GetIt.instance<HomeViewModel>().loadGoals();
          print('🔄 목표 수정 후 홈 뷰모델 동기화 완료');
        } catch (e) {
          print('⚠️ 홈 뷰모델 동기화 실패: $e');
        }
        
        try {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('목표가 성공적으로 수정되었습니다.')));
        } catch (_) {}
        return newGoal;
      }
    } catch (e) {
      try {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('목표 저장 중 오류가 발생했습니다.')));
      } catch (_) {}
      print('Error saving goal: $e');
      return null;
    }
  }

  bool validateInput() {
    bool isValid = true;
    if (goalNameController.text.isEmpty) {
      goalNameError = '목표 이름을 입력해주세요.';
      isValid = false;
    } else {
      goalNameError = null;
    }
    // TODO: '마감일 없이 할래요' 기능 - 유효성 검사에서 마감일 없는 목표 허용
    if (startDate == null) {
      dateError = '시작일을 선택해주세요.';
      isValid = false;
    } else if (!withoutDeadline && endDate == null) {
      dateError = '마감일을 선택해주세요.';
      isValid = false;
    } else if (!withoutDeadline && endDate != null && endDate!.isBefore(startDate!)) {
      dateError = '마감일은 시작일 이후여야 합니다.';
      isValid = false;
    } else {
      dateError = null;
    }
    notifyListeners();
    return isValid;
  }

  void selectIcon(String iconPath) {
    selectedIcon = iconPath;
    notifyListeners();
  }

  void selectStartDate(DateTime date) {
    startDate = date;
    // TODO: '마감일 없이 할래요' 기능 - 마감일이 설정된 경우에만 검증
    if (!withoutDeadline && endDate != null && startDate!.isAfter(endDate!)) {
      endDate = startDate;
    }
    notifyListeners();
  }

  void selectEndDate(DateTime date) {
    endDate = date;
    // TODO: '마감일 없이 할래요' 기능 - 시작일과 마감일 관계 검증
    if (startDate != null && endDate!.isBefore(startDate!)) {
      startDate = endDate;
    }
    notifyListeners();
  }

  Future<void> selectDate(
    BuildContext context, {
    required bool isStartDate,
  }) async {
    DateTime initialDate = DateTime.now();
    if (isStartDate && startDate != null) {
      initialDate = startDate!;
    } else if (!isStartDate && endDate != null) {
      initialDate = endDate!;
    }
    DateTime? pickedDate = await showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0x00000000),
      builder: (context) => SelectDateBottomSheet(initialDate: initialDate),
    );
    if (pickedDate != null) {
      if (isStartDate) {
        selectStartDate(pickedDate);
      } else {
        selectEndDate(pickedDate);
      }
    }
  }

  void toggleWithoutDeadline(bool value) {
    withoutDeadline = value;
    // TODO: '마감일 없이 할래요' 기능 구현
    // 1. 체크 시 마감일 입력 필드 비활성화 (애니메이션 효과 포함)
    // 2. 체크 해제 시 마감일 입력 필드 다시 활성화
    // 3. withoutDeadline이 true일 때 endDate를 null로 설정
    if (value) {
      endDate = null; // 마감일 없는 목표로 설정
    } else {
      // 마감일 다시 활성화 시 기본값 설정
      endDate = startDate?.add(const Duration(days: 30)) ?? DateTime.now().add(const Duration(days: 30));
    }
    notifyListeners();
  }

  void toggleShowOnHome(bool value) {
    showOnHome = value;
    // TODO: 메인화면 노출 기능 개선사항
    // TODO: showOnHome 기본값이 false로 설정되어 있어 사용자가 명시적으로 토글을 켜야 메인화면에 노출됨
    // TODO: UX 개선 고려사항: 기본값을 true로 변경하거나 사용자에게 명확한 안내 제공
    // TODO: 저장 시 로깅 추가로 실제 값이 제대로 저장되는지 확인
    print('🔍 목표 showOnHome 토글 변경: $value');
    notifyListeners();
  }
}
