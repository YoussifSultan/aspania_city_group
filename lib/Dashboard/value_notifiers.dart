import 'package:flutter/material.dart';

class TabOpenedInTheMainScreenValueNotifier extends ValueNotifier<int> {
  TabOpenedInTheMainScreenValueNotifier(this.selectedTab) : super(selectedTab);
  int selectedTab;
  void changeSelectedTabInMainScreen(int newValue) {
    selectedTab = newValue;
    notifyListeners();
  }
}

class OnHoverOnButtonValueNotifier extends ValueNotifier<bool> {
  OnHoverOnButtonValueNotifier(this.onHover) : super(onHover);
  bool onHover;
  void changeOnHoverState(bool newValue) {
    onHover = newValue;
    notifyListeners();
  }
}
