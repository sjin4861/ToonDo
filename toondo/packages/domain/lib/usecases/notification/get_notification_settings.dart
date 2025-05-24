import 'package:domain/entities/notification_settings.dart';
import 'package:domain/repositories/notification_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetNotificationSettingsUseCase {
  final NotificationSettingRepository repository;
  GetNotificationSettingsUseCase(this.repository);
  Future<NotificationSettings> call() => repository.getSettings();
}
