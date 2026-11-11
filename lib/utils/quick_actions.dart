import 'package:flutter/material.dart';

import '../models/vehicle_state.dart';
import '../widgets/app_dialog.dart';
import '../widgets/app_toast.dart';

abstract final class QuickActions {
  static Future<void> run(
    BuildContext context,
    VehicleState vehicle,
    QuickControlId id,
  ) async {
    switch (id) {
      case QuickControlId.doorLock:
        if (vehicle.locked) {
          final ok = await AppDialog.confirm(
            context,
            title: '解锁车门',
            message: '解锁后车辆可被开启，请确认周围环境安全。',
            confirmLabel: '解锁',
            icon: Icons.lock_open_rounded,
          );
          if (!ok || !context.mounted) return;
        }
        vehicle.triggerQuickAction(QuickControlId.doorLock);
        if (!context.mounted) return;
        AppToast.show(
          context,
          vehicle.locked ? '车门已上锁' : '车门已解锁',
          icon: Icons.lock_outline_rounded,
        );
      case QuickControlId.window:
        vehicle.triggerQuickAction(QuickControlId.window);
        if (!context.mounted) return;
        AppToast.show(
          context,
          vehicle.windowVent ? '车窗通风已开启' : '车窗已全部关闭',
          icon: Icons.vertical_split_rounded,
        );
      case QuickControlId.trunk:
        if (!vehicle.trunkOpen) {
          final ok = await AppDialog.confirm(
            context,
            title: '打开后备箱',
            message: '确认打开尾门？请注意后方行人。',
            confirmLabel: '打开',
            icon: Icons.luggage_outlined,
          );
          if (!ok || !context.mounted) return;
        }
        vehicle.triggerQuickAction(QuickControlId.trunk);
        if (!context.mounted) return;
        AppToast.show(
          context,
          vehicle.trunkOpen ? '后备箱已打开' : '后备箱已关闭',
          icon: Icons.luggage_outlined,
        );
      case QuickControlId.findCar:
        vehicle.triggerQuickAction(QuickControlId.findCar);
        if (!context.mounted) return;
        AppToast.show(context, '车辆正在鸣笛闪灯', icon: Icons.volume_up_outlined);
    }
  }
}
