import 'package:flutter/material.dart';

import '../models/vehicle_state_scope.dart';
import '../navigation/app_tab_scope.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../widgets/app_bottom_sheet.dart';
import '../widgets/app_buttons.dart';
import '../widgets/app_dialog.dart';
import '../widgets/app_menu_tile.dart';
import '../widgets/app_toast.dart';
import 'settings_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final vehicle = VehicleStateScope.of(context);

    return ListenableBuilder(
      listenable: vehicle,
      builder: (context, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.pageHorizontal, 8, AppSpacing.pageHorizontal, 0),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.navHighlight,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.person_rounded, size: 32, color: AppColors.textPrimary),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '张先生',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '尊享车主 · 积分 12,480',
                            style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(builder: (_) => const SettingsPage()),
                      ),
                      icon: const Icon(Icons.settings_outlined, color: AppColors.textPrimary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageHorizontal),
                child: Material(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                  child: InkWell(
                    onTap: () {
                      AppTabScope.go(context, 0);
                      AppToast.show(context, '已切换到座驾页', icon: Icons.directions_car_rounded);
                    },
                    borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  vehicle.modelName,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${vehicle.plate} · 电量 ${vehicle.batteryPercent}%',
                                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right, color: AppColors.textSecondary),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              AppMenuTile(
                icon: Icons.receipt_long_outlined,
                title: '订单与账单',
                subtitle: '3 笔待支付',
                onTap: () => _showOrders(context),
              ),
              AppMenuTile(
                icon: Icons.confirmation_number_outlined,
                title: '卡券中心',
                subtitle: '2 张可用',
                onTap: () => _showCoupons(context),
              ),
              AppMenuTile(
                icon: Icons.headset_mic_outlined,
                title: '客服与帮助',
                onTap: () => _showSupport(context),
              ),
              AppMenuTile(
                icon: Icons.privacy_tip_outlined,
                title: '隐私与安全',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (_) => const SettingsPage()),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageHorizontal),
                child: AppSecondaryButton(
                  label: '退出登录',
                  onPressed: () => _logout(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _logout(BuildContext context) async {
    final ok = await AppDialog.confirm(
      context,
      title: '退出登录',
      message: '退出后需重新验证手机号登录，本地车况缓存将保留。',
      confirmLabel: '退出',
      destructive: true,
      icon: Icons.logout_rounded,
    );
    if (ok && context.mounted) {
      AppToast.show(context, '已退出（演示）', icon: Icons.logout_rounded);
    }
  }

  void _showOrders(BuildContext context) {
    AppBottomSheet.show(
      context,
      title: '订单与账单',
      subtitle: '最近 30 天',
      child: Column(
        children: [
          _SheetRow(title: '家用桩充电 · 3月12日', amount: '¥ 42.60', status: '已支付'),
          _SheetRow(title: '保养预约订金', amount: '¥ 200.00', status: '待支付'),
          _SheetRow(title: '商城洗车券', amount: '¥ 39.00', status: '已支付'),
        ],
      ),
    );
  }

  void _showCoupons(BuildContext context) {
    AppBottomSheet.show(
      context,
      title: '卡券中心',
      child: Column(
        children: [
          _CouponCard(title: '春季保养立减', value: '¥200', expire: '04-30 到期'),
          const SizedBox(height: 8),
          _CouponCard(title: '超充 8 折', value: '8折', expire: '05-15 到期'),
        ],
      ),
    );
  }

  void _showSupport(BuildContext context) {
    AppBottomSheet.show(
      context,
      title: '客服与帮助',
      child: Column(
        children: [
          AppPrimaryButton(
            label: '拨打 400-888-6688',
            highlight: true,
            onPressed: () {
              Navigator.pop(context);
              AppToast.show(context, '正在连接客服（演示）', icon: Icons.call_outlined);
            },
          ),
          const SizedBox(height: 10),
          AppSecondaryButton(
            label: '在线留言',
            onPressed: () {
              Navigator.pop(context);
              AppToast.show(context, '留言已提交', icon: Icons.chat_bubble_outline_rounded);
            },
          ),
        ],
      ),
    );
  }
}

class _SheetRow extends StatelessWidget {
  const _SheetRow({
    required this.title,
    required this.amount,
    required this.status,
  });

  final String title;
  final String amount;
  final String status;

  @override
  Widget build(BuildContext context) {
    final pending = status == '待支付';
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.iconMutedBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                Text(status, style: TextStyle(fontSize: 11, color: pending ? AppColors.accentGreen : AppColors.textSecondary)),
              ],
            ),
          ),
          Text(amount, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}

class _CouponCard extends StatelessWidget {
  const _CouponCard({
    required this.title,
    required this.value,
    required this.expire,
  });

  final String title;
  final String value;
  final String expire;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.navHighlight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.accentGreen)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                Text(expire, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
