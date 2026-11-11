import 'package:flutter/foundation.dart';

enum QuickControlId { doorLock, window, trunk, findCar }

class VehicleState extends ChangeNotifier {
  String modelName = 'AURA S7';
  String plate = '沪 A·D7286';
  bool locked = true;
  bool online = true;
  int rangeKm = 486;
  int batteryPercent = 82;
  bool acOn = false;
  double cabinTemp = 28;
  double outdoorTemp = 31;
  QuickControlId? activeControl = QuickControlId.doorLock;
  bool windowVent = false;
  bool trunkOpen = false;
  bool charging = false;
  int chargeTargetPercent = 90;
  int chargeEtaMinutes = 42;
  String locationTitle = '上海 · 滨江壹号';
  String locationDetail = '地下停车场 B2 · A068';

  void triggerQuickAction(QuickControlId id) {
    activeControl = id;
    switch (id) {
      case QuickControlId.doorLock:
        locked = !locked;
      case QuickControlId.window:
        windowVent = !windowVent;
      case QuickControlId.trunk:
        trunkOpen = !trunkOpen;
      case QuickControlId.findCar:
        break;
    }
    notifyListeners();
  }

  void setLocked(bool value) {
    locked = value;
    activeControl = QuickControlId.doorLock;
    notifyListeners();
  }

  void toggleAc() {
    acOn = !acOn;
    notifyListeners();
  }

  void toggleCharging() {
    charging = !charging;
    if (charging) {
      chargeEtaMinutes = ((chargeTargetPercent - batteryPercent).clamp(1, 50)) * 4;
    }
    notifyListeners();
  }

  void setChargeTarget(int percent) {
    chargeTargetPercent = percent;
    if (charging) {
      chargeEtaMinutes = ((percent - batteryPercent).clamp(1, 50)) * 4;
    }
    notifyListeners();
  }

  void selectVehicle({
    required String model,
    required String plateNumber,
    int? range,
    int? battery,
  }) {
    modelName = model;
    plate = plateNumber;
    if (range != null) rangeKm = range;
    if (battery != null) batteryPercent = battery;
    locked = true;
    windowVent = false;
    trunkOpen = false;
    acOn = false;
    notifyListeners();
  }

  String get lockStatusLabel =>
      online ? (locked ? '车辆在线 · 已锁车' : '车辆在线 · 未锁车') : '车辆离线';

  String subtitleFor(QuickControlId id) {
    return switch (id) {
      QuickControlId.doorLock => locked ? '已锁车' : '已解锁',
      QuickControlId.window => windowVent ? '通风中' : '已关闭',
      QuickControlId.trunk => trunkOpen ? '已打开' : '已关闭',
      QuickControlId.findCar => '鸣笛闪灯',
    };
  }

  bool isQuickActive(QuickControlId id) {
    return switch (id) {
      QuickControlId.doorLock => activeControl == id || locked,
      QuickControlId.window => windowVent,
      QuickControlId.trunk => trunkOpen,
      QuickControlId.findCar => activeControl == id,
    };
  }
}
