class Goal {
  final String id;
  final String name;
  final String? icon;
  final double progress;
  final DateTime startDate;
  final DateTime endDate;

  Goal({
    required this.id,
    required this.name,
    this.icon,
    this.progress = 0.0,
    required this.startDate,
    required this.endDate,
  });
}
