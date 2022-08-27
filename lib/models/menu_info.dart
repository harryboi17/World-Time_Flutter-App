import 'package:world_time/objects/enum.dart';
import 'package:flutter/foundation.dart';

class MenuInfo extends ChangeNotifier{
  MenuType menuType;
  String title;
  int imageSource;
  String background;

  MenuInfo(this.menuType, {required this.title, required this.imageSource, required this.background});

  updateMenu(MenuInfo menuInfo){
    this.menuType = menuInfo.menuType;
    this.title = menuInfo.title;
    this.imageSource = menuInfo.imageSource;

    notifyListeners();
  }

  updateBackground(String background){
    this.background = background;
    notifyListeners();
  }
}