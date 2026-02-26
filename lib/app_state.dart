// lib/app_state.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum ManaColor { w, u, b, r, g, c }

class AppState extends ChangeNotifier {
  // ---- THEME ----
  ThemeMode themeMode = ThemeMode.system;

  void cycleThemeMode() {
    // System -> Light -> Dark -> System ...
    switch (themeMode) {
      case ThemeMode.system:
        themeMode = ThemeMode.light;
        break;
      case ThemeMode.light:
        themeMode = ThemeMode.dark;
        break;
      case ThemeMode.dark:
        themeMode = ThemeMode.system;
        break;
    }
    notifyListeners();
  }

  // ---- MANA ----
  final Map<ManaColor, int> pool = {
    ManaColor.w: 0,
    ManaColor.u: 0,
    ManaColor.b: 0,
    ManaColor.r: 0,
    ManaColor.g: 0,
    ManaColor.c: 0,
  };

  bool landDoublersEnabled = false;
  int landDoublersCount = 1;

  int get total => pool.values.fold(0, (a, b) => a + b);
  int amountForLandTap() => 1 + (landDoublersEnabled ? landDoublersCount : 0);

  int getW() => pool[ManaColor.w] ?? 0;
  int getU() => pool[ManaColor.u] ?? 0;
  int getB() => pool[ManaColor.b] ?? 0;
  int getR() => pool[ManaColor.r] ?? 0;
  int getG() => pool[ManaColor.g] ?? 0;
  int getC() => pool[ManaColor.c] ?? 0;

  void add(ManaColor color, int amount) {
    pool[color] = (pool[color] ?? 0) + amount;
    notifyListeners();
  }

  void spend(ManaColor color, int amount) {
    final current = pool[color] ?? 0;
    pool[color] = (current - amount).clamp(0, 999999);
    notifyListeners();
  }

  void clearAll() {
    for (final k in pool.keys) {
      pool[k] = 0;
    }
    landDoublersEnabled = false;
    landDoublersCount = 1;
    notifyListeners();
  }

  void setLandDoublersEnabled(bool enabled) {
    landDoublersEnabled = enabled;
    notifyListeners();
  }

  void incLandDoublers() {
    landDoublersCount = (landDoublersCount + 1).clamp(1, 10);
    notifyListeners();
  }

  void decLandDoublers() {
    landDoublersCount = (landDoublersCount - 1).clamp(1, 10);
    notifyListeners();
  }
}