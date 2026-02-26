// lib/widgets/mana_header.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';

class ManaHeader extends StatelessWidget {
  const ManaHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final cs = Theme.of(context).colorScheme;

    return _SectionCard(
      child: Row(
        children: [
          Expanded(
            child: _TotalTile(label: "Total", value: "${state.total}"),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _BreakdownTile(
              w: state.getW(),
              u: state.getU(),
              b: state.getB(),
              r: state.getR(),
              g: state.getG(),
              c: state.getC(),
            ),
          ),
        ],
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

class _TotalTile extends StatelessWidget {
  const _TotalTile({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant.withOpacity(0.35)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: cs.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }
}

class _BreakdownTile extends StatelessWidget {
  const _BreakdownTile({
    required this.w,
    required this.u,
    required this.b,
    required this.r,
    required this.g,
    required this.c,
  });

  final int w, u, b, r, g, c;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    Widget chip(String s, int v, Color col) {
      final fg = col.computeLuminance() < 0.45 ? Colors.white : Colors.black;
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: col,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(s, style: TextStyle(fontWeight: FontWeight.w900, color: fg)),
            const SizedBox(width: 8),
            Text("$v", style: TextStyle(fontWeight: FontWeight.w900, color: fg)),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant.withOpacity(0.35)),
      ),
      child: Center(
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: [
            chip("W", w, const Color(0xFFFFE36E)),
            chip("U", u, Colors.blue),
            chip("B", b, Colors.black),
            chip("R", r, Colors.red),
            chip("G", g, Colors.green),
            chip("C", c, Colors.grey),
          ],
        ),
      ),
    );
  }
}