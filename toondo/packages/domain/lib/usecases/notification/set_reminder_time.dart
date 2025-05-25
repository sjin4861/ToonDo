import 'package:domain/repositories/notification_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class SetReminderTime {
  final NotificationSettingRepository repository;
  SetReminderTime(this.repository);
  Future<void> call(String time) => repository.setReminderTime(time);
}