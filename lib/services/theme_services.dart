// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeServices {
  final GetStorage _getStorage=GetStorage();
  final _key="modeTheme";
  _saveInGetStorage(bool isDarkMode)=> _getStorage.write(_key, isDarkMode);
  bool _loadFromGetStorage() => _getStorage.read(_key)?? false;

  ThemeMode get theme=> _loadFromGetStorage()? ThemeMode.dark:ThemeMode.light;

 void switchTheme(){
    Get.changeThemeMode(_loadFromGetStorage()? ThemeMode.light:ThemeMode.dark );
    _saveInGetStorage(!_loadFromGetStorage());
  }


}
