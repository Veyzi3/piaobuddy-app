import 'package:flutter/material.dart';

import '../models/vehicle_state.dart';
import '../models/vehicle_state_scope.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../utils/quick_actions.dart';
import '../widgets/app_bottom_sheet.dart';
import '../widgets/app_dialog.dart';
import '../widgets/app_toast.dart';
import '../widgets/section_header.dart';
import 'remote_controls_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final vehicle = VehicleStateScope.of(context);

    return ListenableBuilder(
      listenable: vehicle,
      builder: (context, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _VehicleHeader(vehicle: vehicle),
              _VehicleHero(vehicle: vehicle),
              _RangeBatterySection(vehicle: vehicle),
              _RemoteControlSection(vehicle: vehicle),
              _CabinComfortCard(vehicle: vehicle),
              _LocationCard(vehicle: vehicle),
            ],
          ),
        );
      },
    );
  }
}

class _VehicleHeader extends StatelessWidget {
  const _VehicleHeader({required this.vehicle});

  final VehicleState vehicle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.pageHorizontal, 8, AppSpacing.pageHorizontal, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '我的座驾',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () => _showVehiclePicker(context),
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    children: [
                      Text(
                        vehicle.modelName,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        vehicle.plate,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const Icon(Icons.expand_more, size: 14, color: AppColors.textSecondary),
                    ],
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _showNotifications(context),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: const Icon(
                    Icons.notifications_none_rounded,
                    size: 24,
                    color: AppColors.textPrimary,
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.unreadDot,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showVehiclePicker(BuildContext context) {
    AppBottomSheet.show(
      context,
      title: '切换车辆',
      subtitle: '选择默认控制的车辆',
      child: Column(
        children: [
          _VehicleOption(
            title: 'AURA S7',
            plate: '沪 A·D7286',
            selected: vehicle.modelName == 'AURA S7',
            onTap: () {
              if (vehicle.modelName != 'AURA S7') {
                vehicle.selectVehicle(model: 'AURA S7', plateNumber: '沪 A·D7286');
                AppToast.show(context, '已切换至 AURA S7', icon: Icons.directions_car_rounded);
              }
              Navigator.pop(context);
            },
          ),
          _VehicleOption(
            title: 'AURA X',
            plate: '沪 B·K9021',
            selected: vehicle.modelName == 'AURA X',
            onTap: () {
              if (vehicle.modelName != 'AURA X') {
                vehicle.selectVehicle(
                  model: 'AURA X',
                  plateNumber: '沪 B·K9021',
                  range: 412,
                  battery: 68,
                );
                AppToast.show(context, '已切换至 AURA X', icon: Icons.directions_car_rounded);
              }
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _showNotifications(BuildContext context) {
    AppBottomSheet.show(
      context,
      title: '消息',
      subtitle: '3 条未读',
      maxHeightFraction: 0.55,
      scrollControlled: true,
      child: Column(
        children: [
          _NoticeTile(
            title: '充电完成',
            body: '家用桩已为 AURA S7 充至 90%，剩余续航 520 km。',
            time: '今天 08:12',
            onTap: () {
              Navigator.pop(context);
              AppToast.show(context, '已打开充电详情', icon: Icons.ev_station_outlined);
            },
          ),
          _NoticeTile(
            title: '维保提醒',
            body: '距离下次保养还有 1,200 km，可在线预约。',
            time: '昨天',
            onTap: () {
              Navigator.pop(context);
              AppToast.show(context, '正在跳转保养预约', icon: Icons.build_circle_outlined);
            },
          ),
          _NoticeTile(
            title: '安全通知',
            body: '哨兵模式记录到一次靠近事件，可点击查看回放。',
            time: '3 天前',
            onTap: () {
              Navigator.pop(context);
              AppToast.show(context, '哨兵事件回放（演示）', icon: Icons.videocam_outlined);
            },
          ),
        ],
      ),
    );
  }
}

class _VehicleOption extends StatelessWidget {
  const _VehicleOption({
    required this.title,
    required this.plate,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String plate;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: selected ? AppColors.navHighlight : AppColors.iconMutedBg,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(plate, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                if (selected) const Icon(Icons.check_circle, color: AppColors.accentGreen, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NoticeTile extends StatelessWidget {
  const _NoticeTile({
    required this.title,
    required this.body,
    required this.time,
    this.onTap,
  });

  final String title;
  final String body;
  final String time;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: AppColors.iconMutedBg,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Text(time, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                  ],
                ),
                const SizedBox(height: 6),
                Text(body, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, height: 1.4)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _VehicleHero extends StatelessWidget {
  const _VehicleHero({required this.vehicle});

  final VehicleState vehicle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 209,
          width: double.infinity,
          child: Image.asset(
            'assets/images/car.png',
            fit: BoxFit.contain,
            alignment: Alignment.center,
          ),
        ),
        Transform.translate(
          offset: const Offset(0, -20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.statusChipBg,
              borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    color: vehicle.online ? AppColors.onlineGreen : AppColors.textSecondary,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  vehicle.lockStatusLabel,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: AppColors.accentGreen,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _RangeBatterySection extends StatelessWidget {
  const _RangeBatterySection({required this.vehicle});

  final VehicleState vehicle;

  @override
  Widget build(BuildContext context) {
    final level = vehicle.batteryPercent / 100;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageHorizontal),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${vehicle.rangeKm}',
                          style: const TextStyle(
                            fontSize: 47,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                            height: 1.0,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 4, bottom: 8),
                          child: Text(
                            'km',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Text(
                      '剩余续航',
                      style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${vehicle.batteryPercent}',
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                          height: 1.0,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 3, bottom: 4),
                        child: Text(
                          '%',
                          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _BatteryIcon(level: level),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    '剩余电量',
                    style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(height: 1, color: AppColors.divider),
        ],
      ),
    );
  }
}

class _BatteryIcon extends StatelessWidget {
  const _BatteryIcon({required this.level});

  final double level;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 36,
          height: 22,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: AppColors.batteryTrack,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: AnimatedFractionallySizedBox(
              duration: const Duration(milliseconds: 300),
              widthFactor: level.clamp(0.05, 1),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.accentLime,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ),
        Container(
          width: 3,
          height: 8,
          decoration: BoxDecoration(
            color: AppColors.batteryCap,
            borderRadius: BorderRadius.circular(1),
          ),
        ),
      ],
    );
  }
}

class _RemoteControlSection extends StatelessWidget {
  const _RemoteControlSection({required this.vehicle});

  final VehicleState vehicle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.pageHorizontal, 20, AppSpacing.pageHorizontal, 0),
      child: Column(
        children: [
          SectionHeader(
            title: '远程控制',
            trailing: '全部功能',
            onTrailingTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const RemoteControlsPage()),
              );
            },
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _QuickControl(
                label: '车门锁',
                icon: Icons.lock_outline_rounded,
                active: vehicle.locked,
                onTap: () => QuickActions.run(context, vehicle, QuickControlId.doorLock),
              ),
              _QuickControl(
                label: '车窗',
                icon: Icons.vertical_split_rounded,
                active: vehicle.windowVent,
                onTap: () => QuickActions.run(context, vehicle, QuickControlId.window),
              ),
              _QuickControl(
                label: '后备箱',
                icon: Icons.luggage_outlined,
                active: vehicle.trunkOpen,
                onTap: () => QuickActions.run(context, vehicle, QuickControlId.trunk),
              ),
              _QuickControl(
                label: '寻车',
                icon: Icons.volume_up_outlined,
                active: vehicle.activeControl == QuickControlId.findCar,
                onTap: () => QuickActions.run(context, vehicle, QuickControlId.findCar),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickControl extends StatelessWidget {
  const _QuickControl({
    required this.label,
    required this.icon,
    required this.onTap,
    this.active = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 75,
            height: 54,
            decoration: BoxDecoration(
              color: active ? AppColors.accentLime : AppColors.card,
              borderRadius: BorderRadius.circular(AppSpacing.controlRadius),
            ),
            child: Icon(
              icon,
              size: 24,
              color: active ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: active ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _CabinComfortCard extends StatelessWidget {
  const _CabinComfortCard({required this.vehicle});

  final VehicleState vehicle;

  @override
  Widget build(BuildContext context) {
  return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.pageHorizontal, 20, AppSpacing.pageHorizontal, 0),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 19, 16, 14),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.iconMutedBg,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    Icons.ac_unit_rounded,
                    size: 22,
                    color: vehicle.acOn ? AppColors.accentGreen : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '座舱空调',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '车内 ${vehicle.cabinTemp.toStringAsFixed(0)}°C · 车外 ${vehicle.outdoorTemp.toStringAsFixed(0)}°C',
                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        if (!vehicle.acOn) {
                          final ok = await AppDialog.confirm(
                            context,
                            title: '开启座舱空调',
                            message: '将远程启动空调约 15 分钟，消耗少量电量。',
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
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        width: 47,
                        height: 28,
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: vehicle.acOn ? AppColors.accentLime : AppColors.switchTrack,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Align(
                          alignment: vehicle.acOn ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              color: AppColors.card,
                              borderRadius: BorderRadius.circular(11),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      vehicle.acOn ? '运行中' : '未开启',
                      style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '提前开启，上车即享舒适',
                style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LocationCard extends StatelessWidget {
  const _LocationCard({required this.vehicle});

  final VehicleState vehicle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.pageHorizontal, 16, AppSpacing.pageHorizontal, 0),
      child: Material(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () async {
            final ok = await AppDialog.confirm(
              context,
              title: '导航到车辆',
              message: '将使用系统地图导航至 ${vehicle.locationDetail}。',
              confirmLabel: '开始导航',
              icon: Icons.near_me_rounded,
            );
            if (ok && context.mounted) {
              AppToast.show(
                context,
                '正在导航至 ${vehicle.locationTitle}',
                icon: Icons.near_me_rounded,
              );
            }
          },
          child: SizedBox(
            height: 119,
            child: Row(
              children: [
                const SizedBox(width: 106, height: 119, child: _MapThumbnail()),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '车辆位置',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          vehicle.locationTitle,
                          style: const TextStyle(fontSize: 12, color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          vehicle.locationDetail,
                          style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                        ),
                        const Spacer(),
                        const Row(
                          children: [
                            Icon(Icons.near_me_rounded, size: 13, color: AppColors.accentGreen),
                            SizedBox(width: 4),
                            Text(
                              '导航到车辆',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: AppColors.accentGreen,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MapThumbnail extends StatelessWidget {
  const _MapThumbnail();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.mapBg,
      child: Stack(
        children: [
          Positioned(
            left: 20,
            top: 24,
            child: Container(
              width: 70,
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Positioned(
            left: 48,
            top: 8,
            child: Container(
              width: 8,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Positioned(
            left: 16,
            top: 70,
            child: Container(
              width: 31,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.parkGreen,
                borderRadius: BorderRadius.circular(9),
              ),
            ),
          ),
          Positioned(
            right: 18,
            bottom: 28,
            child: Container(
              width: 33,
              height: 33,
              decoration: BoxDecoration(
                color: AppColors.textPrimary,
                borderRadius: BorderRadius.circular(17),
              ),
              child: const Icon(Icons.location_on_rounded, size: 19, color: AppColors.card),
            ),
          ),
        ],
      ),
    );
  }
}
