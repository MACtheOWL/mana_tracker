// lib/app_state.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum ManaColor { w, u, b, r, g, c }

class AppState extends ChangeNotifier {
  // ---------------- THEME ----------------
  ThemeMode themeMode = ThemeMode.system;

  void cycleThemeMode() {
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

  // ---------------- EFFECTS ----------------
  // 1) Land doublers
  bool landDoublersEnabled = false;
  int landDoublersCount = 1; // used when enabled

  // 2) Lands add extra specific color (each adds +1 per land tap)
  bool extraLandW = false;
  bool extraLandU = false;
  bool extraLandB = false;
  bool extraLandR = false;
  bool extraLandG = false;
  bool extraLandC = false;

  // 3) Mana doesn’t drain
  bool manaDoesntDrain = false;

  // 4) Colored mana can be spent as any color
  bool spendColoredAsAny = false;

  // ---------------- POOL ----------------
  final Map<ManaColor, int> pool = {
    ManaColor.w: 0,
    ManaColor.u: 0,
    ManaColor.b: 0,
    ManaColor.r: 0,
    ManaColor.g: 0,
    ManaColor.c: 0,
  };

  int get total => pool.values.fold(0, (a, b) => a + b);

  int getW() => pool[ManaColor.w] ?? 0;
  int getU() => pool[ManaColor.u] ?? 0;
  int getB() => pool[ManaColor.b] ?? 0;
  int getR() => pool[ManaColor.r] ?? 0;
  int getG() => pool[ManaColor.g] ?? 0;
  int getC() => pool[ManaColor.c] ?? 0;

  // Base add amount for a land tap (your existing doubler model)
  int amountForLandTap() => 1 + (landDoublersEnabled ? landDoublersCount : 0);

  // Helper: extra colors to add per land tap
  int extraFor(ManaColor c) {
    switch (c) {
      case ManaColor.w:
        return extraLandW ? 1 : 0;
      case ManaColor.u:
        return extraLandU ? 1 : 0;
      case ManaColor.b:
        return extraLandB ? 1 : 0;
      case ManaColor.r:
        return extraLandR ? 1 : 0;
      case ManaColor.g:
        return extraLandG ? 1 : 0;
      case ManaColor.c:
        return extraLandC ? 1 : 0;
    }
  }

  // Adds mana for a land tap of a chosen color:
  // - Adds main amount to chosen color (doubler-based)
  // - Adds +1 for each enabled extra color effect
  void addFromLandTap(ManaColor chosenColor) {
    final main = amountForLandTap();
    pool[chosenColor] = (pool[chosenColor] ?? 0) + main;

    if (extraLandW) pool[ManaColor.w] = (pool[ManaColor.w] ?? 0) + 1;
    if (extraLandU) pool[ManaColor.u] = (pool[ManaColor.u] ?? 0) + 1;
    if (extraLandB) pool[ManaColor.b] = (pool[ManaColor.b] ?? 0) + 1;
    if (extraLandR) pool[ManaColor.r] = (pool[ManaColor.r] ?? 0) + 1;
    if (extraLandG) pool[ManaColor.g] = (pool[ManaColor.g] ?? 0) + 1;
    if (extraLandC) pool[ManaColor.c] = (pool[ManaColor.c] ?? 0) + 1;

    notifyListeners();
  }

  // Keep this for non-land sources / general add calls if you still use it
  void add(ManaColor color, int amount) {
    pool[color] = (pool[color] ?? 0) + amount;
    notifyListeners();
  }

  // Spending: if spendColoredAsAny is ON and the requested colored pool is empty,
  // pay from another colored pool (largest-first). Colorless does NOT pay for colored.
  void spend(ManaColor color, int amount) {
    if (amount <= 0) return;

    for (int i = 0; i < amount; i++) {
      if (_canPayDirect(color)) {
        _dec(color);
        continue;
      }

      // Only applies when trying to spend a colored mana
      final isColored = color != ManaColor.c;
      if (isColored && spendColoredAsAny) {
        final alt = _bestAltColoredToPay();
        if (alt != null) {
          _dec(alt);
          continue;
        }
      }

      // Can't pay => stop
      break;
    }

    notifyListeners();
  }

  bool _canPayDirect(ManaColor color) => (pool[color] ?? 0) > 0;

  void _dec(ManaColor color) {
    final cur = pool[color] ?? 0;
    pool[color] = (cur - 1).clamp(0, 999999);
  }

  ManaColor? _bestAltColoredToPay() {
    // Choose the colored pool with the most mana (W/U/B/R/G), excluding colorless
    final entries = <ManaColor, int>{
      ManaColor.w: pool[ManaColor.w] ?? 0,
      ManaColor.u: pool[ManaColor.u] ?? 0,
      ManaColor.b: pool[ManaColor.b] ?? 0,
      ManaColor.r: pool[ManaColor.r] ?? 0,
      ManaColor.g: pool[ManaColor.g] ?? 0,
    };

    ManaColor? best;
    int bestVal = 0;
    entries.forEach((k, v) {
      if (v > bestVal) {
        bestVal = v;
        best = k;
      }
    });

    return bestVal > 0 ? best : null;
  }

  void clearAll() {
    for (final k in pool.keys) {
      pool[k] = 0;
    }

    // Clear button should always clear the pool.
    // Effects should NOT be reset here (keep user settings).
    notifyListeners();
  }

  // ---------------- SETTERS (Effects Page expects these) ----------------

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

  void setExtraLandW(bool v) {
    extraLandW = v;
    notifyListeners();
  }

  void setExtraLandU(bool v) {
    extraLandU = v;
    notifyListeners();
  }

  void setExtraLandB(bool v) {
    extraLandB = v;
    notifyListeners();
  }

  void setExtraLandR(bool v) {
    extraLandR = v;
    notifyListeners();
  }

  void setExtraLandG(bool v) {
    extraLandG = v;
    notifyListeners();
  }

  void setExtraLandC(bool v) {
    extraLandC = v;
    notifyListeners();
  }

  void setManaDoesntDrain(bool v) {
    manaDoesntDrain = v;
    notifyListeners();
  }

  void setSpendColoredAsAny(bool v) {
    spendColoredAsAny = v;
    notifyListeners();
  }
}