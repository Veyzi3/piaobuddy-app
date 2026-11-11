import 'package:flutter/material.dart';

import 'app_bottom_nav.dart';

/// 主 Tab 子页滚动区：布局仍全屏延伸，仅给滚动内容底部留白以避开浮动 TabBar。
class TabPageScrollView extends StatelessWidget {
  const TabPageScrollView({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
    this.controller,
    this.physics,
    this.primary,
  });

  final Widget child;
  final EdgeInsets padding;
  final ScrollController? controller;
  final ScrollPhysics? physics;
  final bool? primary;

  @override
  Widget build(BuildContext context) {
    final tabBarInset = AppBottomNav.tabContentBottomInset(context);
    return SingleChildScrollView(
      controller: controller,
      physics: physics,
      primary: primary,
      padding: padding.copyWith(bottom: padding.bottom + tabBarInset),
      child: child,
    );
  }
}
