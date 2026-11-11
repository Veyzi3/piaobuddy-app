import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';
import 'app_bottom_nav.dart';
import 'tab_bar_slide_handler.dart';

class AppShell extends StatelessWidget {
  const AppShell({
    super.key,
    required this.indicatorPosition,
    required this.selectedIndex,
    required this.isInteracting,
    required this.onTabSlideStart,
    required this.onTabSlide,
    required this.onTabSlideEnd,
    required this.onTabTap,
    required this.child,
  });

  final double indicatorPosition;
  final int selectedIndex;
  final bool isInteracting;
  final double Function() onTabSlideStart;
  final ValueChanged<double> onTabSlide;
  final VoidCallback onTabSlideEnd;
  final ValueChanged<int> onTabTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final bottom = 12.0 + MediaQuery.paddingOf(context).bottom;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        extendBody: true,
        body: Stack(
          fit: StackFit.expand,
          children: [
            SafeArea(
              bottom: false,
              child: child,
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: bottom,
              child: TabBarSlideHandler(
                tabCount: 4,
                onSlideStart: onTabSlideStart,
                onSlide: onTabSlide,
                onSlideEnd: onTabSlideEnd,
                onTapTab: onTabTap,
                child: AppBottomNav(
                  indicatorPosition: indicatorPosition,
                  selectedIndex: selectedIndex,
                  isInteracting: isInteracting,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
