import 'package:flutter/material.dart';

import 'vehicle_state.dart';

class VehicleStateScope extends InheritedNotifier<VehicleState> {
  const VehicleStateScope({
    super.key,
    required VehicleState super.notifier,
    required super.child,
  });

  static VehicleState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<VehicleStateScope>();
    assert(scope != null, 'VehicleStateScope not found');
    return scope!.notifier!;
  }
}
