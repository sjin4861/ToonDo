import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';

@injectable
class HelpGuideViewModel extends ChangeNotifier {
  String _version = '';
  String get appVersion => _version;

  HelpGuideViewModel() {
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    _version = '${info.version} (${info.buildNumber})';
    notifyListeners();
  }

  // TODO 구현해야함
  void openTerms() {}
  void openAppReview() {}
  void openPrivacyPolicy() {}
}
