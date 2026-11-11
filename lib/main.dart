import 'package:flutter/material.dart';

import 'models/vehicle_state.dart';
import 'models/vehicle_state_scope.dart';
import 'pages/main_shell.dart';
import 'theme/app_colors.dart';

void main() {
  runApp(const PiaobuddyApp());
}

class PiaobuddyApp extends StatefulWidget {
  const PiaobuddyApp({super.key});

  @override
  State<PiaobuddyApp> createState() => _PiaobuddyAppState();
}

class _PiaobuddyAppState extends State<PiaobuddyApp> {
  final VehicleState _vehicle = VehicleState();

  @override
  Widget build(BuildContext context) {
    return VehicleStateScope(
      notifier: _vehicle,
      child: MaterialApp(
        title: '票伙伴',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: AppColors.background,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.accentGreen,
            brightness: Brightness.light,
            surface: AppColors.background,
          ),
          fontFamily: 'PingFang SC',
        ),
        home: const MainShell(),
      ),
    );
  }
}
