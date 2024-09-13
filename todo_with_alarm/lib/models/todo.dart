// models/todo.dart

class Todo {
  String title; // 투두 제목
  String status; // 'O', 'X', 'U' 중 하나
  String comment; // 코멘트
  DateTime date; // 투두의 날짜

  Todo({
    required this.title,
    required this.date,
    this.status = '', // 기본값은 빈 문자열
    this.comment = '', // 기본값은 빈 문자열
  });

  // JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'status': status,
      'comment': comment,
      'date': date.toIso8601String(),
    };
  }

  // JSON에서 객체로 변환하는 메서드
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      title: json['title'],
      date: DateTime.parse(json['date']),
      status: json['status'],
      comment: json['comment'],
    );
  }
}