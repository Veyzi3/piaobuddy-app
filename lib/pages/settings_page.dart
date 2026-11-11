import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../widgets/app_menu_tile.dart';
import '../widgets/app_toast.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool pushEnabled = true;
  bool biometric = false;
  bool locationShare = true;

  @override
  Widget build(BuildContext context) {
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
          '设置',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          _SwitchTile(
            title: '消息推送',
            value: pushEnabled,
            onChanged: (v) => setState(() => pushEnabled = v),
          ),
          _SwitchTile(
            title: '面容 / 指纹解锁',
            value: biometric,
            onChanged: (v) => setState(() => biometric = v),
          ),
          _SwitchTile(
            title: '共享车辆位置',
            subtitle: '用于家人账号与导航',
            value: locationShare,
            onChanged: (v) => setState(() => locationShare = v),
          ),
          AppMenuTile(
            icon: Icons.language_outlined,
            title: '语言',
            subtitle: '简体中文',
            onTap: () => AppToast.show(context, '语言设置（演示）', icon: Icons.language_outlined),
          ),
          AppMenuTile(
            icon: Icons.info_outline_rounded,
            title: '关于应用',
            subtitle: '版本 1.0.0',
            onTap: () => AppToast.show(context, '票伙伴车控 v1.0.0', icon: Icons.info_outline_rounded),
          ),
        ],
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  const _SwitchTile({
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.pageHorizontal, 0, AppSpacing.pageHorizontal, 8),
      child: Material(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 8, 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 14, color: AppColors.textPrimary)),
                    if (subtitle != null)
                      Text(subtitle!, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                  ],
                ),
              ),
              Switch.adaptive(
                value: value,
                activeTrackColor: AppColors.accentLime,
                onChanged: onChanged,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
