import 'package:flutter/material.dart';

import 'app_bottom_nav.dart';

/// TabBar 跟手滑动：激活背景随手指连续移动，松手后落位；轻点仍可选中某一格。
class TabBarSlideHandler extends StatefulWidget {
  const TabBarSlideHandler({
    super.key,
    required this.tabCount,
    required this.onSlideStart,
    required this.onSlide,
    required this.onSlideEnd,
    required this.onTapTab,
    required this.child,
  });

  final int tabCount;
  final double Function() onSlideStart;
  final ValueChanged<double> onSlide;
  final VoidCallback onSlideEnd;
  final ValueChanged<int> onTapTab;
  final Widget child;

  static const tapSlop = 10.0;

  @override
  State<TabBarSlideHandler> createState() => _TabBarSlideHandlerState();
}

class _TabBarSlideHandlerState extends State<TabBarSlideHandler> {
  double? _startLocalX;
  double _startTabPosition = 0;
  double _totalMovement = 0;
  bool _sliding = false;

  double _tabWidth(double barWidth) => barWidth / widget.tabCount;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final barWidth = constraints.maxWidth;

        return Listener(
          behavior: HitTestBehavior.opaque,
          onPointerDown: (event) {
            _startLocalX = event.localPosition.dx;
            _startTabPosition = widget.onSlideStart();
            _totalMovement = 0;
            _sliding = false;
          },
          onPointerMove: (event) {
            if (_startLocalX == null) return;

            _totalMovement += event.delta.dx.abs() + event.delta.dy.abs();
            if (!_sliding && _totalMovement > TabBarSlideHandler.tapSlop) {
              _sliding = true;
            }
            if (!_sliding) return;

            final dx = event.localPosition.dx - _startLocalX!;
            final tabWidth = _tabWidth(barWidth);
            final next = (_startTabPosition + dx / tabWidth).clamp(
              0.0,
              (widget.tabCount - 1).toDouble(),
            );
            widget.onSlide(next);
          },
          onPointerUp: (_) {
            if (_sliding) {
              widget.onSlideEnd();
            } else if (_startLocalX != null) {
              widget.onTapTab(_tabIndexAt(_startLocalX!, barWidth));
            }
            _startLocalX = null;
            _sliding = false;
            _totalMovement = 0;
          },
          onPointerCancel: (_) {
            if (_sliding) widget.onSlideEnd();
            _startLocalX = null;
            _sliding = false;
          },
          child: widget.child,
        );
      },
    );
  }

  int _tabIndexAt(double localX, double barWidth) {
    final tabWidth = _tabWidth(barWidth);
    return (localX / tabWidth).floor().clamp(0, widget.tabCount - 1);
  }
}
