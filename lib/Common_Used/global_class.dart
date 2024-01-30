import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:responsive_builder/responsive_builder.dart';

class GlobalClass {
  static SizingInformation sizingInformation = SizingInformation(
      deviceScreenType: DeviceScreenType.mobile,
      refinedSize: RefinedSize.normal,
      screenSize: Size.zero,
      localWidgetSize: Size.zero);
  static ZoomDrawerController drawerController = ZoomDrawerController();
  static List<MenuOption> menuOptionsMobile = [];
}

class MenuOption {
  MenuOption({required this.menuTitle, required this.onMenuTapButton});
  final String menuTitle;
  final Function onMenuTapButton;
}
