import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toondo/services/data_sync_service.dart';

class DataSyncInitializer extends StatelessWidget {
  final bool isNewLogin;
  const DataSyncInitializer({Key? key, required this.isNewLogin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isNewLogin) {
      // build 완료 후 한 번만 동기화 호출
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<DataSyncService>(context, listen: false).syncAllData();
      });
    }
    return const SizedBox.shrink();
  }
}
