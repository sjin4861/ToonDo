import 'package:domain/entities/todo_filter_option.dart';

extension TodoFilterOptionX on TodoFilterOption {
  int toIndex() {
    switch (this) {
      case TodoFilterOption.all: return 0;
      case TodoFilterOption.goal: return 1;
      case TodoFilterOption.importance: return 2;
      case TodoFilterOption.dDay:
        // TODO: Handle this case.
        throw UnimplementedError();
      case TodoFilterOption.daily:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }
}

extension IntX on int {
  TodoFilterOption toFilter() {
    switch (this) {
      case 0: return TodoFilterOption.all;
      case 1: return TodoFilterOption.goal;
      case 2: return TodoFilterOption.importance;
      default: return TodoFilterOption.all;
    }
  }
}
