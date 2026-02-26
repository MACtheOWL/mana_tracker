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

    String themeLabel() {
      switch (state.themeMode) {
        case ThemeMode.system:
          return "Theme: System";
        case ThemeMode.light:
          return "Theme: Light";
        case ThemeMode.dark:
          return "Theme: Dark";
      }
    }

    IconData themeIcon() {
      switch (state.themeMode) {
        case ThemeMode.system:
          return Icons.brightness_auto;
        case ThemeMode.light:
          return Icons.light_mode;
        case ThemeMode.dark:
          return Icons.dark_mode;
      }
    }

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
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.tonal(
                      onPressed: state.cycleThemeMode,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(themeIcon(), size: 18),
                          const SizedBox(width: 10),
                          Text(
                            themeLabel(),
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  _doublerBox(
                    context: context,
                    title: "Land Doublers",
                    enabled: state.landDoublersEnabled,
                    count: state.landDoublersCount,
                    onToggle: () => state.setLandDoublersEnabled(!state.landDoublersEnabled),
                    onMinus: state.decLandDoublers,
                    onPlus: state.incLandDoublers,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _doublerBox({
    required BuildContext context,
    required String title,
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
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text(
                  enabled ? "Enabled" : "Disabled",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: cs.onSurfaceVariant),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          _pillToggle(enabled: enabled, onPressed: onToggle),
          const SizedBox(width: 10),
          _miniIconBtn(icon: Icons.remove, onPressed: enabled ? onMinus : null),
          const SizedBox(width: 8),
          Text("x${enabled ? 1 + count : 1}", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900)),
          const SizedBox(width: 8),
          _miniIconBtn(icon: Icons.add, onPressed: enabled ? onPlus : null),
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
        child: Text(enabled ? "ON" : "OFF", style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
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