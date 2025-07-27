import 'package:domain/entities/goal.dart';
import 'package:domain/entities/todo.dart';

class PromptBuilder {
  static String build(String userText, {List<Goal>? goals, List<Todo>? todos}) {
    final sb = StringBuffer()..writeln(userText);
    if (goals != null && goals.isNotEmpty) {
      sb.writeln('\n[⚑ Goals]');
      for (var g in goals) {
        sb.writeln('- ${g.name} : ${g.progress}%');
      }
    }
    if (todos != null && todos.isNotEmpty) {
      sb.writeln('\n[✓ Todos]');
      for (var t in todos) {
        sb.writeln('- ${t.title} : ${t.status}%');
      }
    }
    return sb.toString();
  }
}