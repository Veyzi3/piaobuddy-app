import 'package:flutter/material.dart';

class AppTabScope extends InheritedWidget {
  const AppTabScope({
    super.key,
    required this.selectTab,
    required super.child,
  });

  final ValueChanged<int> selectTab;

  static AppTabScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppTabScope>();
  }

  static void go(BuildContext context, int index) {
    maybeOf(context)?.selectTab(index);
  }

  @override
  bool updateShouldNotify(AppTabScope oldWidget) =>
      oldWidget.selectTab != selectTab;
}
