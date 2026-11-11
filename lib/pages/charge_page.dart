import 'package:flutter/material.dart';

import '../models/vehicle_state.dart';
import '../models/vehicle_state_scope.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../widgets/app_buttons.dart';
import '../widgets/app_dialog.dart';
import '../widgets/app_toast.dart';
import '../widgets/page_header.dart';
import '../widgets/section_header.dart';
import '../widgets/tab_page_scroll.dart';

class ChargePage extends StatelessWidget {
  const ChargePage({super.key});

  @override
  Widget build(BuildContext context) {
    final vehicle = VehicleStateScope.of(context);

    return ListenableBuilder(
      listenable: vehicle,
      builder: (context, _) {
        return TabPageScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const PageHeader(title: '充电', subtitle: '家用桩 · 滨江壹号 B2'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageHorizontal),
                child: _ChargeStatusCard(vehicle: vehicle),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageHorizontal),
                child: SectionHeader(
                  title: '充电目标',
                  trailing: '${vehicle.chargeTargetPercent}%',
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.pageHorizontal, 12, AppSpacing.pageHorizontal, 0),
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: AppColors.accentLime,
                    inactiveTrackColor: AppColors.batteryTrack,
                    thumbColor: AppColors.textPrimary,
                    overlayColor: AppColors.accentLime.withValues(alpha: 0.2),
                  ),
                  child: Slider(
                    value: vehicle.chargeTargetPercent.toDouble(),
                    min: 50,
                    max: 100,
                    divisions: 10,
                    label: '${vehicle.chargeTargetPercent}%',
                    onChanged: vehicle.charging ? null : (v) => vehicle.setChargeTarget(v.round()),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageHorizontal),
                child: AppPrimaryButton(
                  label: vehicle.charging ? '结束充电' : '开始充电',
                  highlight: !vehicle.charging,
                  onPressed: () => _toggleCharging(context, vehicle),
                ),
              ),
              const SizedBox(height: 28),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.pageHorizontal),
                child: SectionHeader(title: '附近充电站'),
              ),
              const SizedBox(height: 12),
              _StationTile(
                name: '极充 · 陆家嘴中心',
                distance: '1.2 km',
                available: '空闲 8 / 12',
                onNavigate: () => _reserveStation(context, '极充 · 陆家嘴中心'),
              ),
              _StationTile(
                name: '国家电网 · 世纪大道',
                distance: '2.6 km',
                available: '空闲 3 / 6',
                onNavigate: () => _reserveStation(context, '国家电网 · 世纪大道'),
              ),
              _StationTile(
                name: '特来电 · 张江高科',
                distance: '5.1 km',
                available: '空闲 11 / 20',
                onNavigate: () => _reserveStation(context, '特来电 · 张江高科'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _toggleCharging(BuildContext context, VehicleState vehicle) async {
    if (vehicle.charging) {
      final ok = await AppDialog.confirm(
        context,
        title: '结束充电',
        message: '当前电量 ${vehicle.batteryPercent}%，确定停止本次充电？',
        confirmLabel: '结束',
        icon: Icons.stop_circle_outlined,
      );
      if (!ok) return;
      vehicle.toggleCharging();
      if (context.mounted) {
        AppToast.show(context, '充电已结束', icon: Icons.ev_station_outlined);
      }
      return;
    }

    final ok = await AppDialog.confirm(
      context,
      title: '开始充电',
      message: '将为 ${vehicle.modelName} 充至 ${vehicle.chargeTargetPercent}%，预计约 ${((vehicle.chargeTargetPercent - vehicle.batteryPercent).clamp(1, 50)) * 4} 分钟。',
      confirmLabel: '开始',
      icon: Icons.bolt_rounded,
    );
    if (!ok) return;

    vehicle.toggleCharging();
    if (context.mounted) {
      AppToast.show(context, '已开始充电', icon: Icons.ev_station_outlined);
    }
  }

  Future<void> _reserveStation(BuildContext context, String name) async {
    final ok = await AppDialog.confirm(
      context,
      title: '预约充电位',
      message: '为 $name 预约 1 小时充电位？到店后扫码降锁。',
      confirmLabel: '预约',
      icon: Icons.event_available_rounded,
    );
    if (ok && context.mounted) {
      AppToast.show(context, '预约成功 · $name', icon: Icons.ev_station_outlined);
    }
  }
}

class _ChargeStatusCard extends StatelessWidget {
  const _ChargeStatusCard({required this.vehicle});

  final VehicleState vehicle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: vehicle.charging ? AppColors.accentLime : AppColors.iconMutedBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  vehicle.charging ? '充电中' : '未充电',
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                ),
              ),
              const Spacer(),
              Text(
                '${vehicle.modelName} · ${vehicle.batteryPercent}%',
                style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: TweenAnimationBuilder<double>(
              tween: Tween(end: vehicle.batteryPercent / 100),
              duration: const Duration(milliseconds: 400),
              builder: (context, value, _) => LinearProgressIndicator(
                value: value,
                minHeight: 10,
                backgroundColor: AppColors.batteryTrack,
                color: AppColors.accentLime,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            vehicle.charging
                ? '预计剩余 ${vehicle.chargeEtaMinutes} 分钟充至 ${vehicle.chargeTargetPercent}%'
                : '当前续航约 ${vehicle.rangeKm} km，连接家用桩后可预约充电',
            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _StationTile extends StatelessWidget {
  const _StationTile({
    required this.name,
    required this.distance,
    required this.available,
    required this.onNavigate,
  });

  final String name;
  final String distance;
  final String available;
  final VoidCallback onNavigate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.pageHorizontal, 0, AppSpacing.pageHorizontal, 10),
      child: Material(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onNavigate,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.iconMutedBg,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.ev_station_outlined, color: AppColors.textPrimary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      const SizedBox(height: 4),
                      Text('$distance · $available', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
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
