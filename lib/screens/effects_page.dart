// lib/screens/effects_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';

class EffectsPage extends StatelessWidget {
  const EffectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final cs = Theme.of(context).colorScheme;

    const double minLayoutWidth = 420;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: const Text("Effects"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: cs.surface,
        surfaceTintColor: cs.surface,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: minLayoutWidth),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // THEME BUTTON (Dark <-> Light only)
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.tonal(
                      onPressed: state.toggleThemeMode,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            state.themeMode == ThemeMode.dark
                                ? Icons.dark_mode
                                : Icons.light_mode,
                            size: 18,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            state.themeMode == ThemeMode.dark ? "Dark Mode" : "Light Mode",
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // 1) LAND DOUBLERS
                  _landDoublerBox(
                    context: context,
                    enabled: state.landDoublersEnabled,
                    count: state.landDoublersCount,
                    onToggle: () =>
                        state.setLandDoublersEnabled(!state.landDoublersEnabled),
                    onMinus: state.decLandDoublers,
                    onPlus: state.incLandDoublers,
                  ),

                  const SizedBox(height: 14),

                  // 2) LANDS ADD EXTRA SPECIFIC COLOR
                  _SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Lands add extra mana",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Adds +1 of each enabled color on every land tap",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _extraRow(
                          context,
                          label: "Extra White",
                          swatch: _mana(W).bg,
                          enabled: state.extraLandW,
                          onChanged: state.setExtraLandW,
                        ),
                        _extraRow(
                          context,
                          label: "Extra Blue",
                          swatch: _mana(U).bg,
                          enabled: state.extraLandU,
                          onChanged: state.setExtraLandU,
                        ),
                        _extraRow(
                          context,
                          label: "Extra Black",
                          swatch: _mana(B).bg,
                          enabled: state.extraLandB,
                          onChanged: state.setExtraLandB,
                        ),
                        _extraRow(
                          context,
                          label: "Extra Red",
                          swatch: _mana(R).bg,
                          enabled: state.extraLandR,
                          onChanged: state.setExtraLandR,
                        ),
                        _extraRow(
                          context,
                          label: "Extra Green",
                          swatch: _mana(G).bg,
                          enabled: state.extraLandG,
                          onChanged: state.setExtraLandG,
                        ),
                        _extraRow(
                          context,
                          label: "Extra Colorless",
                          swatch: _mana(C).bg,
                          enabled: state.extraLandC,
                          onChanged: state.setExtraLandC,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // 3) MANA DOESN'T DRAIN
                  _toggleCard(
                    context,
                    title: "Mana doesn’t drain",
                    subtitle: "Keeps mana between turns/phases (manual clear still works)",
                    value: state.manaDoesntDrain,
                    onChanged: state.setManaDoesntDrain,
                    icon: Icons.lock_outline,
                  ),

                  const SizedBox(height: 14),

                  // 4) COLORED MANA CAN BE SPENT AS ANY COLOR
                  _toggleCard(
                    context,
                    title: "Colored mana can be spent as any color",
                    subtitle: "If a color is empty, spending can use other colored mana",
                    value: state.spendColoredAsAny,
                    onChanged: state.setSpendColoredAsAny,
                    icon: Icons.swap_horiz,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------- UI BUILDERS ----------

  Widget _landDoublerBox({
    required BuildContext context,
    required bool enabled,
    required int count,
    required VoidCallback onToggle,
    required VoidCallback onMinus,
    required VoidCallback onPlus,
  }) {
    final cs = Theme.of(context).colorScheme;

    return _SectionCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Land doublers",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 4),
                Text(
                  enabled ? "Enabled" : "Disabled",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          _pillToggle(enabled: enabled, onPressed: onToggle),
          const SizedBox(width: 10),
          _miniIconBtn(icon: Icons.remove, onPressed: enabled ? onMinus : null),
          const SizedBox(width: 8),
          Text(
            "x${enabled ? 1 + count : 1}",
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900),
          ),
          const SizedBox(width: 8),
          _miniIconBtn(icon: Icons.add, onPressed: enabled ? onPlus : null),
        ],
      ),
    );
  }

  Widget _extraRow(
    BuildContext context, {
    required String label,
    required Color swatch,
    required bool enabled,
    required ValueChanged<bool> onChanged,
  }) {
    final cs = Theme.of(context).colorScheme;
    final fg = swatch.computeLuminance() < 0.45 ? Colors.white : Colors.black;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            height: 28,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: swatch,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Center(
              child: Text(
                label.split(" ").last.substring(0, 1), // W/U/B/R/G/C
                style: TextStyle(fontWeight: FontWeight.w900, color: fg),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900),
            ),
          ),
          Switch(
            value: enabled,
            onChanged: onChanged,
            activeColor: cs.primary,
          ),
        ],
      ),
    );
  }

  Widget _toggleCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required IconData icon,
  }) {
    final cs = Theme.of(context).colorScheme;

    return _SectionCard(
      child: Row(
        children: [
          Icon(icon, size: 20, color: cs.onSurfaceVariant),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: cs.primary,
          ),
        ],
      ),
    );
  }

  Widget _pillToggle({required bool enabled, required VoidCallback onPressed}) {
    return SizedBox(
      height: 34,
      child: FilledButton.tonal(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        ),
        child: Text(
          enabled ? "ON" : "OFF",
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
        ),
      ),
    );
  }

  Widget _miniIconBtn({required IconData icon, required VoidCallback? onPressed}) {
    return SizedBox(
      height: 34,
      width: 42,
      child: FilledButton.tonal(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Icon(icon, size: 18),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withOpacity(0.75),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant.withOpacity(0.35)),
      ),
      child: child,
    );
  }
}

// Convenience markers + swatches (local to this file only)
const Object W = 'W';
const Object U = 'U';
const Object B = 'B';
const Object R = 'R';
const Object G = 'G';
const Object C = 'C';

_ManaSwatch _mana(Object k) {
  switch (k) {
    case W:
      return const _ManaSwatch(bg: Color(0xFFFFE36E));
    case U:
      return const _ManaSwatch(bg: Colors.blue);
    case B:
      return const _ManaSwatch(bg: Colors.black);
    case R:
      return const _ManaSwatch(bg: Colors.red);
    case G:
      return const _ManaSwatch(bg: Colors.green);
    case C:
    default:
      return const _ManaSwatch(bg: Colors.grey);
  }
}

class _ManaSwatch {
  const _ManaSwatch({required this.bg});
  final Color bg;
}