import 'dart:io';
import 'package:data/datasources/local/custom_icon_local_datasource.dart';
import 'package:domain/repositories/custom_icon_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: CustomIconRepository)
class CustomIconRepositoryImpl implements CustomIconRepository {
  final CustomIconLocalDatasource localDatasource;

  CustomIconRepositoryImpl(this.localDatasource);

  @override
  Future<String> saveCustomIcon(File imageFile) async {
    return await localDatasource.saveCustomIconFromFile(imageFile);
  }

  @override
  List<String> getAllCustomIconPaths() {
    final icons = localDatasource.getAllCustomIcons();
    return icons.map((icon) => icon.filePath).toList();
  }

  @override
  Future<void> updateLastUsed(String iconPath) async {
    final icon = localDatasource.getCustomIconByPath(iconPath);
    if (icon != null) {
      await localDatasource.updateLastUsed(icon.id);
    }
  }

  @override
  Future<void> deleteCustomIcon(String iconPath) async {
    final icon = localDatasource.getCustomIconByPath(iconPath);
    if (icon != null) {
      await localDatasource.deleteCustomIcon(icon.id);
    }
  }

  @override
  bool isCustomIcon(String? iconPath) {
    return localDatasource.isCustomIcon(iconPath);
  }
}

