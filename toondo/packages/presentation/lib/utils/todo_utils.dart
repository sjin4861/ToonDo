import 'package:domain/entities/todo_filter_option.dart';

extension TodoFilterOptionX on TodoFilterOption {
  int toIndex() {
    switch (this) {
      case TodoFilterOption.all:
        return 0;
      case TodoFilterOption.goal:
        return 1;
      // eisenhower 기반 중요도 필터
      case TodoFilterOption.importance:
        return 2;
      case TodoFilterOption.dDay:
        return 3;
      case TodoFilterOption.daily:
        return 4;
    }
  }
}

extension IntX on int {
  TodoFilterOption toFilter() {
    switch (this) {
      case 0:
        return TodoFilterOption.all;
      case 1:
        return TodoFilterOption.goal;
      // eisenhower 기반 중요도 필터
      case 2:
        return TodoFilterOption.importance;
      case 3:
        return TodoFilterOption.dDay;
      case 4:
        return TodoFilterOption.daily;
      default:
        return TodoFilterOption.all;
    }
  }
}
