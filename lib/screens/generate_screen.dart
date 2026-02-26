// lib/screens/generate_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../widgets/mana_header.dart';

class GenerateScreen extends StatelessWidget {
  const GenerateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final cs = Theme.of(context).colorScheme;

    const double minLayoutWidth = 420;

    // MATCH POOL EXACTLY
    const double btnW = 98;
    const double btnH = 46;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: const Text("Generate"),
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
                  const ManaHeader(),
                  const SizedBox(height: 14),

                  _SectionCard(
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      alignment: WrapAlignment.center,
                      children: [
                        _addButton(state, ManaColor.w, _mana(W).bg, btnW, btnH),
                        _addButton(state, ManaColor.u, _mana(U).bg, btnW, btnH),
                        _addButton(state, ManaColor.b, _mana(B).bg, btnW, btnH),
                        _addButton(state, ManaColor.r, _mana(R).bg, btnW, btnH),
                        _addButton(state, ManaColor.g, _mana(G).bg, btnW, btnH),
                        _addButton(state, ManaColor.c, _mana(C).bg, btnW, btnH),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.tonal(
                      onPressed: state.clearAll,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        "Clear",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- ADD BUTTON (COPY POOL STYLE) ----------------

  Widget _addButton(
    AppState state,
    ManaColor color,
    Color bg,
    double w,
    double h,
  ) {
    final fg = _fgFor(bg);
    final meta = _metaForColor(color);

    // Perm doublers removed; single add amount
    final addAmount = state.amountForLandTap();

    return SizedBox(
      width: w,
      height: h,
      child: ElevatedButton(
        onPressed: () => state.add(color, addAmount),
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          minimumSize: const Size(0, 0),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _CircleBadge(text: "+", fg: fg, bg: fg.withOpacity(0.12)),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                meta.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: fg.withOpacity(0.95),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- UTILS ----------------

  static Color _fgFor(Color bg) {
    final lum = bg.computeLuminance();
    return lum < 0.45 ? const Color.fromARGB(255, 255, 255, 255) : Colors.black;
  }

  static _ManaMeta _metaForColor(ManaColor c) {
    switch (c) {
      case ManaColor.w:
        return const _ManaMeta("White", "W");
      case ManaColor.u:
        return const _ManaMeta("Blue", "U");
      case ManaColor.b:
        return const _ManaMeta("Black", "B");
      case ManaColor.r:
        return const _ManaMeta("Red", "R");
      case ManaColor.g:
        return const _ManaMeta("Green", "G");
      case ManaColor.c:
        return const _ManaMeta("Colorless", "C");
    }
  }
}

// ---------- UI PIECES (MATCH POOL) ----------

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

class _CircleBadge extends StatelessWidget {
  const _CircleBadge({required this.text, required this.fg, required this.bg});

  final String text;
  final Color fg;
  final Color bg;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 26,
      width: 26,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: fg,
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _ManaMeta {
  const _ManaMeta(this.name, this.letter);
  final String name;
  final String letter;
}

// Convenience markers for readability in this file only.
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