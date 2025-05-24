import 'package:domain/entities/notification_settings.dart';
import 'package:domain/repositories/notification_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class SetNotificationSettingsUseCase {
  final NotificationSettingRepository repository;
  SetNotificationSettingsUseCase(this.repository);
  Future<void> call(NotificationSettings settings) => repository.setSettings(settings);
}