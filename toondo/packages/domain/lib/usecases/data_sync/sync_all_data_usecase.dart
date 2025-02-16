import 'package:domain/repositories/data_sync_repository.dart';

class SyncAllDataUseCase {
  final DataSyncRepository repository;

  SyncAllDataUseCase(this.repository);

  Future<void> call() async {
    await repository.syncAllData();
  }
}
