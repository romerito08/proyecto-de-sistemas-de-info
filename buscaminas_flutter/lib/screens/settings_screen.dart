import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';
import 'package:buscaminas_flutter/logica/sonido.dart';
import 'package:buscaminas_flutter/theme_notifier.dart';

// ─────────────────────────────────────────────
//  PALETA ADAPTATIVA (claro / oscuro)
// ─────────────────────────────────────────────

class _Palette {
  final bool dark;
  const _Palette(this.dark);

  factory _Palette.of(BuildContext context) =>
      _Palette(Theme.of(context).brightness == Brightness.dark);

  // Fondos
  Color get scaffold   => dark ? const Color(0xFF121212) : const Color(0xFFF1F8E9);
  Color get surface    => dark ? const Color(0xFF1E1E1E) : Colors.white;
  Color get surfaceTint=> dark ? const Color(0xFF2E7D32).withOpacity(0.12)
                               : const Color(0xFF2E7D32).withOpacity(0.06);

  // Bordes
  Color get border     => dark ? const Color(0xFF2E7D32).withOpacity(0.5)
                               : const Color(0xFFC8E6C9);
  Color get borderFaint=> dark ? const Color(0xFF424242) : const Color(0xFFE0E0E0);

  // Textos
  Color get textPrimary   => dark ? const Color(0xFFB9F6CA) : const Color(0xFF1B5E20);
  Color get textSecondary => dark ? const Color(0xFF81C784) : const Color(0xFF66BB6A);
  Color get textBody      => dark ? Colors.white : const Color(0xFF333333);
  Color get textMuted     => dark ? Colors.white54 : Colors.grey.shade600;

  // Acento
  Color get accent        => const Color(0xFF2E7D32);
  Color get accentSubtle  => dark ? const Color(0xFF2E7D32).withOpacity(0.15)
                                  : const Color(0xFF2E7D32).withOpacity(0.08);

  // Decoración de fondo
  Color get decor1 => dark ? const Color(0xFF1B5E20).withOpacity(0.4)
                           : const Color(0xFFC8E6C9).withOpacity(0.5);
  Color get decor2 => dark ? const Color(0xFF004D40).withOpacity(0.35)
                           : const Color(0xFFB2DFDB).withOpacity(0.45);
  Color get decor3 => dark ? const Color(0xFF212121).withOpacity(0.6)
                           : const Color(0xFFDCEDC8).withOpacity(0.35);
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // ── Estado ──────────────────────────────────────────────────────────────────
  String _difficulty = 'Fácil';
  String _theme = 'Automático';
  String _numberStyle = 'Clásico';
  bool _sound = true;
  bool _animations = true;
  bool _loading = true;

  // ── Opciones ─────────────────────────────────────────────────────────────────
  static const _difficulties = [
    {'label': 'Fácil', 'desc': '6×6 · 10 minas', 'icon': ''},
    {'label': 'Medio', 'desc': '8×8 · 20 minas', 'icon': ''},
    {'label': 'Difícil', 'desc': '10×10 · 30 minas', 'icon': ''},
  ];

  static const _themes = [
    {'label': 'Claro', 'icon': Icons.light_mode_rounded},
    {'label': 'Oscuro', 'icon': Icons.dark_mode_rounded},
    {'label': 'Automático', 'icon': Icons.brightness_auto_rounded},
  ];

  static const List<Map<String, dynamic>> _numberStyles = [
    {
      'label': 'Clásico',
      'desc': '1=azul, 2=verde, 3=rojo…',
      'preview': [Color(0xFF1565C0), Color(0xFF2E7D32), Color(0xFFC62828)],
    },
    {
      'label': 'Colorido',
      'desc': 'Paleta vibrante y alegre',
      'preview': [Color(0xFFE91E63), Color(0xFF9C27B0), Color(0xFF00BCD4)],
    },
    {
      'label': 'Retro',
      'desc': 'Estilo pixel art clásico',
      'preview': [Color(0xFFFFEB3B), Color(0xFF4CAF50), Color(0xFFFF5722)],
    },
    {
      'label': 'Minimalista',
      'desc': 'Un solo color, diseño limpio',
      'preview': [Color(0xFF616161), Color(0xFF757575), Color(0xFF9E9E9E)],
    },
  ];

  // ── Persistencia ─────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _difficulty = prefs.getString('difficulty') ?? 'Fácil';
      _theme = prefs.getString('theme') ?? 'Automático';
      _numberStyle = prefs.getString('numberStyle') ?? 'Clásico';
      _sound = prefs.getBool('sound') ?? true;
      _animations = prefs.getBool('animations') ?? true;
      _loading = false;
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('difficulty', _difficulty);
    await prefs.setString('numberStyle', _numberStyle);
    await prefs.setBool('sound', _sound);
    await prefs.setBool('animations', _animations);

    await themeNotifier.setTheme(_theme);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
            SizedBox(width: 10),
            Text(
              'Configuración guardada',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF2E7D32),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ── Build principal ───────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeNotifier,
      builder: (context, _) {
        final p = _Palette.of(context);
        return Scaffold(
          backgroundColor: p.scaffold,
          body: Stack(
            children: [
              _BackgroundDecor(p: p),
              SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () async {
                              await SoundService.playButton();
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              size: 18,
                              color: Color(0xFF2E7D32),
                            ),
                            style: IconButton.styleFrom(
                              backgroundColor: p.surface,
                              side: BorderSide(color: p.border, width: 1.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: _loading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF2E7D32),
                              ),
                            )
                          : LayoutBuilder(
                              builder: (context, constraints) {
                                final isWide = constraints.maxWidth > 700;
                                return _SettingsLayout(
                                  isWide: isWide,
                                  p: p,
                                  leftColumn: _buildLeftColumn(p),
                                  rightColumn: _buildRightColumn(p),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: _loading
              ? null
              : SafeArea(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          constraints: const BoxConstraints(maxWidth: 500),
                          width: double.infinity,
                          child: GestureDetector(
                            onTap: _savePreferences,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2E7D32),
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF2E7D32).withOpacity(0.35),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'GUARDAR CONFIGURACIÓN',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 2,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget _buildLeftColumn(_Palette p) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(icon: Icons.sports_esports_rounded, title: 'DIFICULTAD', p: p),
        const SizedBox(height: 12),
        ..._difficulties.map(
          (d) => _DifficultyTile(
            label: d['label'] as String,
            desc: d['desc'] as String,
            emoji: d['icon'] as String,
            selected: _difficulty == d['label'],
            p: p,
            onTap: () => setState(() => _difficulty = d['label'] as String),
          ),
        ),
        const SizedBox(height: 24),
        _SectionTitle(icon: Icons.tune_rounded, title: 'OPCIONES', p: p),
        const SizedBox(height: 12),
        _ToggleOption(
          icon: Icons.volume_up_rounded,
          title: 'Efectos de sonido',
          subtitle: 'Sonidos al revelar casillas y al ganar/perder',
          value: _sound,
          p: p,
          onChanged: (v) => setState(() => _sound = v),
        ),
        const SizedBox(height: 10),
        _ToggleOption(
          icon: Icons.auto_awesome_rounded,
          title: 'Animaciones',
          subtitle: 'Transiciones y efectos visuales del tablero',
          value: _animations,
          p: p,
          onChanged: (v) => setState(() => _animations = v),
        ),
      ],
    );
  }

  Widget _buildRightColumn(_Palette p) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(icon: Icons.format_paint_rounded, title: 'ESTILO DE NÚMEROS', p: p),
        const SizedBox(height: 12),
        ..._numberStyles.map(
          (s) => _NumberStyleTile(
            label: s['label'] as String,
            desc: s['desc'] as String,
            preview: s['preview'] as List<Color>,
            selected: _numberStyle == s['label'],
            p: p,
            onTap: () => setState(() => _numberStyle = s['label'] as String),
          ),
        ),
        const SizedBox(height: 24),
        _SectionTitle(icon: Icons.palette_rounded, title: 'TEMA', p: p),
        const SizedBox(height: 12),
        _ThemeSelector(
          selected: _theme,
          themes: _themes,
          p: p,
          onChanged: (v) {
            setState(() => _theme = v);
            themeNotifier.setTheme(v);
          },
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  LAYOUT ADAPTATIVO
// ─────────────────────────────────────────────

class _SettingsLayout extends StatelessWidget {
  final bool isWide;
  final _Palette p;
  final Widget leftColumn;
  final Widget rightColumn;

  const _SettingsLayout({
    required this.isWide,
    required this.p,
    required this.leftColumn,
    required this.rightColumn,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 10),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Text(
                'CONFIGURACIÓN',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 6,
                  color: p.textPrimary,
                ),
              ),
              const SizedBox(height: 28),
              isWide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: leftColumn),
                        const SizedBox(width: 32),
                        Expanded(child: rightColumn),
                      ],
                    )
                  : Column(
                      children: [
                        leftColumn,
                        const SizedBox(height: 28),
                        rightColumn,
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  SUBTÍTULO DE SECCIÓN
// ─────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  final _Palette p;
  const _SectionTitle({required this.icon, required this.title, required this.p});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: p.textSecondary),
        const SizedBox(width: 6),
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            letterSpacing: 3,
            color: p.textSecondary,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  TILE DE DIFICULTAD
// ─────────────────────────────────────────────

class _DifficultyTile extends StatelessWidget {
  final String label;
  final String desc;
  final String emoji;
  final bool selected;
  final _Palette p;
  final VoidCallback onTap;

  const _DifficultyTile({
    required this.label,
    required this.desc,
    required this.emoji,
    required this.selected,
    required this.p,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: selected ? const Color(0xFF2E7D32) : p.surface,
          border: Border.all(
            color: selected ? const Color(0xFF2E7D32) : p.border,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(selected ? 0.1 : 0.04),
              blurRadius: selected ? 8 : 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: selected ? Colors.white : const Color(0xFF2E7D32),
                  ),
                ),
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 12,
                    color: selected ? Colors.white70 : p.textMuted,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Icon(
              selected ? Icons.check_circle_rounded : Icons.circle_outlined,
              color: selected ? Colors.white : p.border,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  SELECTOR DE TEMA (3 píldoras)
// ─────────────────────────────────────────────

class _ThemeSelector extends StatelessWidget {
  final String selected;
  final List<Map<String, dynamic>> themes;
  final _Palette p;
  final ValueChanged<String> onChanged;

  const _ThemeSelector({
    required this.selected,
    required this.themes,
    required this.p,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: p.border, width: 1.5),
      ),
      child: Row(
        children: themes.map((t) {
          final isSelected = selected == t['label'];
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(t['label'] as String),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF2E7D32) : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Icon(
                      t['icon'] as IconData,
                      size: 20,
                      color: isSelected ? Colors.white : const Color(0xFF81C784),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      t['label'] as String,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        color: isSelected ? Colors.white : p.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  TILE DE ESTILO DE NÚMEROS
// ─────────────────────────────────────────────

class _NumberStyleTile extends StatelessWidget {
  final String label;
  final String desc;
  final List<Color> preview;
  final bool selected;
  final _Palette p;
  final VoidCallback onTap;

  const _NumberStyleTile({
    required this.label,
    required this.desc,
    required this.preview,
    required this.selected,
    required this.p,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? p.surfaceTint : p.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? const Color(0xFF2E7D32) : p.borderFaint,
            width: selected ? 1.8 : 1,
          ),
        ),
        child: Row(
          children: [
            Row(
              children: preview
                  .map(
                    (c) => Container(
                      width: 22,
                      height: 22,
                      margin: const EdgeInsets.only(right: 3),
                      decoration: BoxDecoration(
                        color: c,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Text(
                          '${preview.indexOf(c) + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: selected ? p.textPrimary : p.textBody,
                    ),
                  ),
                  Text(
                    desc,
                    style: TextStyle(fontSize: 11, color: p.textMuted),
                  ),
                ],
              ),
            ),
            Icon(
              selected ? Icons.check_circle_rounded : Icons.circle_outlined,
              color: selected ? const Color(0xFF2E7D32) : p.borderFaint,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  OPCIÓN CON TOGGLE (Switch)
// ─────────────────────────────────────────────

class _ToggleOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final _Palette p;
  final ValueChanged<bool> onChanged;

  const _ToggleOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.p,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: p.border, width: 1.5),
      ),
      child: SwitchListTile(
        secondary: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: p.accentSubtle,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: const Color(0xFF2E7D32)),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: p.textPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 12, color: p.textMuted),
        ),
        value: value,
        activeColor: const Color(0xFF2E7D32),
        onChanged: onChanged,
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  FONDO DECORATIVO
// ─────────────────────────────────────────────

class _BackgroundDecor extends StatelessWidget {
  final _Palette p;
  const _BackgroundDecor({required this.p});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: CustomPaint(
        painter: _BgPainter(c1: p.decor1, c2: p.decor2, c3: p.decor3),
      ),
    );
  }
}

class _BgPainter extends CustomPainter {
  final Color c1, c2, c3;
  const _BgPainter({required this.c1, required this.c2, required this.c3});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    paint.color = c1;
    canvas.drawCircle(Offset(size.width * 0.85, size.height * 0.05), size.width * 0.4, paint);

    paint.color = c2;
    canvas.drawCircle(Offset(size.width * 0.05, size.height * 0.92), size.width * 0.38, paint);

    paint.color = c3;
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.5), size.width * 0.55, paint);
  }

  @override
  bool shouldRepaint(covariant _BgPainter old) =>
      old.c1 != c1 || old.c2 != c2 || old.c3 != c3;
}