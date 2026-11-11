import 'package:flutter/material.dart';

import 'app_bottom_nav.dart';

/// Tab 轻点由子项处理；超过滑动阈值后才跟手拖胶囊，松手再落定。
class TabBarSlideHandler extends StatefulWidget {
  const TabBarSlideHandler({
    super.key,
    required this.tabCount,
    required this.onSlideAnchor,
    required this.onSlideBegin,
    required this.onSlide,
    required this.onSlideEnd,
    required this.child,
  });

  final int tabCount;
  final double Function() onSlideAnchor;
  final VoidCallback onSlideBegin;
  final ValueChanged<double> onSlide;
  final VoidCallback onSlideEnd;
  final Widget child;

  static const tapSlop = 14.0;

  @override
  State<TabBarSlideHandler> createState() => _TabBarSlideHandlerState();
}

class _TabBarSlideHandlerState extends State<TabBarSlideHandler> {
  double? _startLocalX;
  double _startTabPosition = 0;
  double _horizontalTravel = 0;
  bool _sliding = false;

  double _tabWidth(double barWidth) => barWidth / widget.tabCount;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final barWidth = constraints.maxWidth;

        return Listener(
          behavior: HitTestBehavior.deferToChild,
          onPointerDown: (event) {
            _startLocalX = event.localPosition.dx;
            _startTabPosition = widget.onSlideAnchor();
            _horizontalTravel = 0;
            _sliding = false;
          },
          onPointerMove: (event) {
            if (_startLocalX == null) return;

            _horizontalTravel += event.delta.dx.abs();
            if (!_sliding && _horizontalTravel > TabBarSlideHandler.tapSlop) {
              _sliding = true;
              widget.onSlideBegin();
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
            if (_sliding) widget.onSlideEnd();
            _startLocalX = null;
            _sliding = false;
            _horizontalTravel = 0;
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
}
