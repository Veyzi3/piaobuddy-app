import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../navigation/app_tab_scope.dart';
import '../widgets/app_shell.dart';
import 'charge_page.dart';
import 'discover_page.dart';
import 'home_page.dart';
import 'profile_page.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> with SingleTickerProviderStateMixin {
  static const _tabCount = 4;

  int _committedTab = 0;
  double _pagePosition = 0;
  bool _isDragging = false;

  AnimationController? _snapController;
  Animation<double>? _snapAnimation;
  double _snapTarget = 0;

  static const _pages = [
    HomePage(),
    ChargePage(),
    DiscoverPage(),
    ProfilePage(),
  ];

  bool get _isInteracting => _isDragging || (_snapController?.isAnimating ?? false);

  double get _indicatorPosition {
    if (_isInteracting) return _pagePosition;
    return _committedTab.toDouble();
  }

  @override
  void dispose() {
    _snapController?.dispose();
    super.dispose();
  }

  void _cancelSnap() {
    _snapController?.dispose();
    _snapController = null;
    _snapAnimation = null;
  }

  void _animatePositionTo(double target) {
    _cancelSnap();
    _snapTarget = target;
    final from = _pagePosition;
    if ((from - target).abs() < 0.001) {
      setState(() => _pagePosition = target);
      return;
    }

    _snapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _snapAnimation = Tween<double>(begin: from, end: target).animate(
      CurvedAnimation(parent: _snapController!, curve: Curves.easeOutCubic),
    );
    _snapController!.addListener(() {
      setState(() => _pagePosition = _snapAnimation!.value);
    });
    _snapController!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _pagePosition = _snapTarget);
        _cancelSnap();
      }
    });
    _snapController!.forward();
  }

  void _selectTab(int index) {
    index = index.clamp(0, _tabCount - 1);
    if (_committedTab == index && !_isInteracting && (_pagePosition - index).abs() < 0.01) {
      return;
    }
    HapticFeedback.selectionClick();
    setState(() => _committedTab = index);
    _animatePositionTo(index.toDouble());
  }

  double _onTabSlideAnchor() {
    return _committedTab.toDouble();
  }

  void _onTabSlideBegin() {
    _cancelSnap();
    setState(() {
      _isDragging = true;
      _pagePosition = _committedTab.toDouble();
    });
  }

  void _onTabSlide(double position) {
    setState(() => _pagePosition = position);
  }

  void _onTabSlideEnd() {
    final target = _pagePosition.round().clamp(0, _tabCount - 1);
    setState(() => _isDragging = false);
    if (target != _committedTab) {
      HapticFeedback.lightImpact();
      setState(() => _committedTab = target);
    }
    _animatePositionTo(target.toDouble());
  }

  @override
  Widget build(BuildContext context) {
    return AppTabScope(
      selectTab: _selectTab,
      child: AppShell(
        indicatorPosition: _indicatorPosition,
        selectedIndex: _committedTab,
        isInteracting: _isInteracting,
        onTabSlideAnchor: _onTabSlideAnchor,
        onTabSlideBegin: _onTabSlideBegin,
        onTabSlide: _onTabSlide,
        onTabSlideEnd: _onTabSlideEnd,
        onTabTap: _selectTab,
        child: IndexedStack(
          index: _committedTab,
          sizing: StackFit.expand,
          children: _pages,
        ),
      ),
    );
  }
}
