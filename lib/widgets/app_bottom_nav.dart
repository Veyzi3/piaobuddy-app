import 'dart:ui';

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.indicatorPosition,
    required this.selectedIndex,
    required this.isInteracting,
  });

  /// 胶囊横向位置，0..3，支持小数跟手。
  final double indicatorPosition;
  final int selectedIndex;
  final bool isInteracting;

  static const outerRadius = 28.0;
  static const barHeight = 64.0;
  /// 胶囊相对每一格左右的内缩，与 [TabBarSlideHandler] 算宽一致。
  static const pillInset = 6.0;

  static const _items = [
    (label: '座驾', icon: Icons.directions_car_rounded),
    (label: '充电', icon: Icons.ev_station_outlined),
    (label: '发现', icon: Icons.explore_outlined),
    (label: '我的', icon: Icons.person_outline_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 0,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(outerRadius),
          boxShadow: [
            BoxShadow(
              color: AppColors.textPrimary.withValues(alpha: 0.1),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(outerRadius),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 42, sigmaY: 42),
            child: Container(
              height: barHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(outerRadius),
                color: Colors.white.withValues(alpha: 0.16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final tabW = constraints.maxWidth / _items.length;
                  final pillW = tabW - pillInset * 2;
                  final clamped = indicatorPosition.clamp(0.0, (_items.length - 1).toDouble());
                  // 以格中心为锚点，跟手时在两格之间平滑过渡
                  final pillLeft = (clamped + 0.5) * tabW - pillW / 2;

                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        left: pillLeft,
                        top: 6,
                        width: pillW,
                        height: barHeight - 12,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: AppColors.accentLime.withValues(alpha: 0.92),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.accentLime.withValues(alpha: 0.35),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          for (var i = 0; i < _items.length; i++)
                            Expanded(
                              child: _NavItem(
                                label: _items[i].label,
                                icon: _items[i].icon,
                                selected: isInteracting
                                    ? _emphasisFor(i, clamped) > 0.5
                                    : i == selectedIndex,
                                emphasis: isInteracting ? _emphasisFor(i, clamped) : (i == selectedIndex ? 1.0 : 0.0),
                              ),
                            ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  double _emphasisFor(int index, double position) {
    return (1 - (position - index).abs()).clamp(0.0, 1.0);
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    required this.icon,
    required this.selected,
    required this.emphasis,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final double emphasis;

  @override
  Widget build(BuildContext context) {
    final color = Color.lerp(AppColors.textSecondary, AppColors.textPrimary, emphasis)!;
    final iconSize = selected ? 24.0 : 22.0;
    final weight = selected ? FontWeight.w700 : FontWeight.w400;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: iconSize, color: color),
        const SizedBox(height: 3),
        Text(
          label,
          style: TextStyle(fontSize: 10, fontWeight: weight, color: color, height: 1.1),
        ),
      ],
    );
  }
}
