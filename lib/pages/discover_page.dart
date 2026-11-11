import 'package:flutter/material.dart';

import '../navigation/app_tab_scope.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../widgets/app_bottom_sheet.dart';
import '../widgets/app_buttons.dart';
import '../widgets/app_dialog.dart';
import '../widgets/app_toast.dart';
import '../widgets/page_header.dart';
import '../widgets/section_header.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  static const _services = [
    (Icons.build_circle_outlined, '保养预约'),
    (Icons.support_agent_outlined, '道路救援'),
    (Icons.shield_outlined, '车险服务'),
    (Icons.storefront_outlined, '原厂商城'),
    (Icons.local_car_wash_outlined, '洗车权益'),
    (Icons.card_giftcard_outlined, '车主福利'),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const PageHeader(title: '发现', subtitle: '服务与资讯'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageHorizontal),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _showPromo(context),
                borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                child: Ink(
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFDFECC8), Color(0xFFF6F8F6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '春季维保季',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '预约保养立减 200 元，赠车内除菌',
                          style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.pageHorizontal),
            child: SectionHeader(title: '车主服务'),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageHorizontal),
            child: GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.05,
              children: [
                for (final s in _services)
                  _ServiceCell(
                    icon: s.$1,
                    label: s.$2,
                    onTap: () => _onService(context, s.$2),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.pageHorizontal),
            child: SectionHeader(title: '精选资讯'),
          ),
          const SizedBox(height: 12),
          _ArticleTile(
            title: '夏季用车：如何延长续航',
            meta: '官方 · 3 分钟阅读',
            onTap: () => _openArticle(context, '夏季用车：如何延长续航'),
          ),
          _ArticleTile(
            title: 'AURA S7 OTA 更新说明',
            meta: '系统更新 · 昨天',
            onTap: () => _openArticle(context, 'AURA S7 OTA 更新说明'),
          ),
          _ArticleTile(
            title: '滨江充电站上线预约功能',
            meta: '社区 · 2 天前',
            onTap: () {
              AppTabScope.go(context, 1);
              AppToast.show(context, '已在充电页查看站点', icon: Icons.ev_station_outlined);
            },
          ),
        ],
      ),
    );
  }

  void _showPromo(BuildContext context) {
    AppBottomSheet.show(
      context,
      title: '春季维保季',
      subtitle: '限时权益至 4 月 30 日',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            '在线预约保养可立减 ¥200，并赠送车内蒸汽除菌一次。',
            style: TextStyle(fontSize: 13, height: 1.45, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          AppPrimaryButton(
            label: '立即预约保养',
            highlight: true,
            onPressed: () async {
              Navigator.pop(context);
              final ok = await AppDialog.confirm(
                context,
                title: '确认预约',
                message: '将为您安排 4 月 18 日 10:00 到店保养，定金 ¥200。',
                confirmLabel: '确认预约',
                icon: Icons.build_circle_outlined,
              );
              if (ok && context.mounted) {
                AppToast.show(context, '保养预约成功', icon: Icons.event_available_rounded);
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> _onService(BuildContext context, String label) async {
    if (label == '道路救援') {
      final ok = await AppDialog.confirm(
        context,
        title: '呼叫道路救援',
        message: '将共享车辆位置并安排救援专员联系您。',
        confirmLabel: '呼叫',
        icon: Icons.support_agent_outlined,
      );
      if (ok && context.mounted) {
        AppToast.show(context, '救援热线已接通（演示）', icon: Icons.call_outlined);
      }
      return;
    }

    if (label == '保养预约') {
      _showPromo(context);
      return;
    }

    AppToast.show(context, '$label · 敬请期待', icon: Icons.info_outline_rounded);
  }

  void _openArticle(BuildContext context, String title) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => _ArticleDetailPage(title: title),
      ),
    );
  }
}

class _ServiceCell extends StatelessWidget {
  const _ServiceCell({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.iconMutedBg,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, size: 22, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textPrimary)),
          ],
        ),
      ),
    );
  }
}

class _ArticleTile extends StatelessWidget {
  const _ArticleTile({
    required this.title,
    required this.meta,
    required this.onTap,
  });

  final String title;
  final String meta;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.pageHorizontal, 0, AppSpacing.pageHorizontal, 10),
      child: Material(
        color: AppColors.card,
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
                      Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      const SizedBox(height: 6),
                      Text(meta, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
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

class _ArticleDetailPage extends StatelessWidget {
  const _ArticleDetailPage({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          color: AppColors.textPrimary,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
        children: const [
          Text(
            '在气温升高时，适度使用空调预设、避免频繁急加速，并保持在 20%–80% 区间充电，有助于延长电池寿命与日常续航表现。',
            style: TextStyle(fontSize: 14, height: 1.6, color: AppColors.textPrimary),
          ),
          SizedBox(height: 16),
          Text(
            '更多用车技巧将持续更新，欢迎关注 OTA 与车主社区推送。',
            style: TextStyle(fontSize: 13, height: 1.5, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
