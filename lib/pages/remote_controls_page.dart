import 'package:flutter/material.dart';

import '../models/vehicle_state.dart';
import '../models/vehicle_state_scope.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../utils/quick_actions.dart';
import '../widgets/app_dialog.dart';
import '../widgets/app_toast.dart';
import '../widgets/section_header.dart';

class RemoteControlsPage extends StatelessWidget {
  const RemoteControlsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vehicle = VehicleStateScope.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          color: AppColors.textPrimary,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          '全部远程功能',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: ListenableBuilder(
        listenable: vehicle,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.pageHorizontal,
              8,
              AppSpacing.pageHorizontal,
              32,
            ),
            children: [
              _ActionTile(
                icon: Icons.lock_outline_rounded,
                title: '车门锁',
                subtitle: vehicle.subtitleFor(QuickControlId.doorLock),
                active: vehicle.locked,
                onTap: () => QuickActions.run(context, vehicle, QuickControlId.doorLock),
              ),
              _ActionTile(
                icon: Icons.vertical_split_rounded,
                title: '车窗',
                subtitle: vehicle.subtitleFor(QuickControlId.window),
                active: vehicle.windowVent,
                onTap: () => QuickActions.run(context, vehicle, QuickControlId.window),
              ),
              _ActionTile(
                icon: Icons.luggage_outlined,
                title: '后备箱',
                subtitle: vehicle.subtitleFor(QuickControlId.trunk),
                active: vehicle.trunkOpen,
                onTap: () => QuickActions.run(context, vehicle, QuickControlId.trunk),
              ),
              _ActionTile(
                icon: Icons.volume_up_outlined,
                title: '寻车',
                subtitle: vehicle.subtitleFor(QuickControlId.findCar),
                onTap: () => QuickActions.run(context, vehicle, QuickControlId.findCar),
              ),
              const SizedBox(height: 24),
              const SectionHeader(title: '舒适与空调'),
              const SizedBox(height: 12),
              _ActionTile(
                icon: Icons.ac_unit_rounded,
                title: '座舱空调',
                subtitle: vehicle.acOn
                    ? '运行中 · 车内 ${vehicle.cabinTemp.toStringAsFixed(0)}°C'
                    : '未开启',
                active: vehicle.acOn,
                onTap: () async {
                  if (!vehicle.acOn) {
                    final ok = await AppDialog.confirm(
                      context,
                      title: '开启座舱空调',
                      message: '将远程启动空调约 15 分钟。',
                      confirmLabel: '开启',
                      icon: Icons.ac_unit_rounded,
                    );
                    if (!ok || !context.mounted) return;
                  }
                  vehicle.toggleAc();
                  if (!context.mounted) return;
                  AppToast.show(
                    context,
                    vehicle.acOn ? '空调已开启' : '空调已关闭',
                    icon: Icons.ac_unit_rounded,
                  );
                },
              ),
              _ActionTile(
                icon: Icons.air_rounded,
                title: '座椅通风',
                subtitle: '驾驶位 2 档',
                onTap: () => AppToast.show(context, '座椅通风 2 档（演示）', icon: Icons.air_rounded),
              ),
              const SizedBox(height: 24),
              const SectionHeader(title: '安全'),
              const SizedBox(height: 12),
              _ActionTile(
                icon: Icons.sensors_rounded,
                title: '哨兵模式',
                subtitle: '停车监控',
                onTap: () async {
                  final ok = await AppDialog.confirm(
                    context,
                    title: '开启哨兵模式',
                    message: '停车期间将使用摄像头与传感器记录异常靠近事件。',
                    confirmLabel: '开启',
                    icon: Icons.sensors_rounded,
                  );
                  if (ok && context.mounted) {
                    AppToast.show(context, '哨兵模式已开启', icon: Icons.sensors_rounded);
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.active = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: active ? AppColors.accentLime : AppColors.iconMutedBg,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(icon, color: AppColors.textPrimary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, size: 18, color: AppColors.textSecondary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
