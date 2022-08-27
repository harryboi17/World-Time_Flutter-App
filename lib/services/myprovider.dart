import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:world_time/pages/home.dart';
import 'package:world_time/objects/enum.dart';
import 'package:world_time/models/menu_info.dart';

class ProviderClass extends StatelessWidget {
  const ProviderClass({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MenuInfo>(
        create: (context) => MenuInfo(MenuType.clock, title: "Clock", imageSource: 0xe73b, background: 'afternoon.jpg'),
        child: Home()
    );
  }
}
