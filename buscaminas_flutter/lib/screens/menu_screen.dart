import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
//  PALETA ADAPTATIVA
// ─────────────────────────────────────────────

class _Palette {
  final Color background;
  final Color surface;
  final Color surfaceBorder;
  final Color accent;
  final Color accentLight;
  final Color accentMuted;
  final Color textPrimary;
  final Color textSecondary;
  final Color iconBg;
  final Color iconBorder;
  final Color divider;

  const _Palette._({
    required this.background,
    required this.surface,
    required this.surfaceBorder,
    required this.accent,
    required this.accentLight,
    required this.accentMuted,
    required this.textPrimary,
    required this.textSecondary,
    required this.iconBg,
    required this.iconBorder,
    required this.divider,
  });

  factory _Palette.of(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return dark ? _Palette._dark() : _Palette._light();
  }

  factory _Palette._light() => const _Palette._(
        background: Color(0xFFF1F8E9),
        surface: Colors.white,
        surfaceBorder: Color(0xFFC8E6C9),
        accent: Color(0xFF2E7D32),
        accentLight: Color(0xFFA5D6A7),
        accentMuted: Color(0xFF66BB6A),
        textPrimary: Color(0xFF1B5E20),
        textSecondary: Color(0xFF81C784),
        iconBg: Color(0xFFDCEDC8),
        iconBorder: Color(0xFFA5D6A7),
        divider: Color(0xFF81C784),
      );

  factory _Palette._dark() => const _Palette._(
        background: Color(0xFF121212),
        surface: Color(0xFF1E1E1E),
        surfaceBorder: Color(0xFF2E4A2E),
        accent: Color(0xFF81C784),
        accentLight: Color(0xFF388E3C),
        accentMuted: Color(0xFF4CAF50),
        textPrimary: Color(0xFFA5D6A7),
        textSecondary: Color(0xFF4CAF50),
        iconBg: Color(0xFF1B3A1B),
        iconBorder: Color(0xFF388E3C),
        divider: Color(0xFF4CAF50),
      );
}

// ─────────────────────────────────────────────
//  PANTALLA PRINCIPAL — MENÚ
// ─────────────────────────────────────────────

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen>
    with TickerProviderStateMixin {
  late AnimationController _titleController;
  late AnimationController _menuController;
  late Animation<double> _titleFade;
  late Animation<Offset> _titleSlide;

  final List<_MenuItem> _menuItems = [
    _MenuItem(label: 'JUGAR',         route: '/game',         color: Color(0xFF2E7D32), delay: 0),
    _MenuItem(label: 'MARCADORES',    route: '/scores',       color: Color(0xFF388E3C), delay: 80),
    _MenuItem(label: 'CONFIGURACIÓN', route: '/settings',     color: Color(0xFF00796B), delay: 160),
    _MenuItem(label: 'INSTRUCCIONES', route: '/instructions', color: Color(0xFF558B2F), delay: 240),
    _MenuItem(label: 'CRÉDITOS',      route: '/about',        color: Color(0xFF00695C), delay: 320),
  ];

  @override
  void initState() {
    super.initState();

    _titleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _menuController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    );

    _titleFade = CurvedAnimation(
      parent: _titleController,
      curve: Curves.easeOut,
    );
    _titleSlide = Tween<Offset>(
      begin: const Offset(0, -0.25),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _titleController,
      curve: Curves.easeOutCubic,
    ));

    _titleController.forward();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _menuController.forward();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _menuController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = _Palette.of(context);
    final isWide = MediaQuery.of(context).size.width > 700;

    return Scaffold(
      backgroundColor: p.background,
      body: Stack(
        children: [
          _BackgroundDecor(p: p),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isWide ? 48 : 28,
                    vertical: 40,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FadeTransition(
                        opacity: _titleFade,
                        child: SlideTransition(
                          position: _titleSlide,
                          child: _GameTitle(p: p),
                        ),
                      ),
                      const SizedBox(height: 40),
                      ..._menuItems.map((item) => _AnimatedMenuButton(
                            item: item,
                            controller: _menuController,
                            p: p,
                          )),
                      const SizedBox(height: 28),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  TÍTULO DEL JUEGO
// ─────────────────────────────────────────────

class _GameTitle extends StatelessWidget {
  final _Palette p;
  const _GameTitle({required this.p});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: p.iconBg,
            shape: BoxShape.circle,
            border: Border.all(color: p.iconBorder, width: 2),
          ),
          child: Icon(
            Icons.energy_savings_leaf_rounded,
            size: 42,
            color: p.accent,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'BUSCAMINAS',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w900,
            letterSpacing: 6,
            color: p.textPrimary,
            height: 1,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 28, height: 1.5, color: p.divider),
            const SizedBox(width: 10),
            Text(
              'FLUTTER',
              style: TextStyle(
                fontSize: 10,
                letterSpacing: 4,
                color: p.accentMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 10),
            Container(width: 28, height: 1.5, color: p.divider),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  BOTÓN ANIMADO DEL MENÚ
// ─────────────────────────────────────────────

class _AnimatedMenuButton extends StatefulWidget {
  final _MenuItem item;
  final AnimationController controller;
  final _Palette p;

  const _AnimatedMenuButton({
    required this.item,
    required this.controller,
    required this.p,
  });

  @override
  State<_AnimatedMenuButton> createState() => _AnimatedMenuButtonState();
}

class _AnimatedMenuButtonState extends State<_AnimatedMenuButton> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.p;
    final start = widget.item.delay / 1300.0;
    final end = (start + 0.5).clamp(0.0, 1.0);

    final fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: Interval(start, end, curve: Curves.easeOut),
      ),
    );
    final slideAnim = Tween<Offset>(
      begin: const Offset(0.06, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: widget.controller,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    ));

    return FadeTransition(
      opacity: fadeAnim,
      child: SlideTransition(
        position: slideAnim,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: MouseRegion(
            onEnter: (_) => setState(() => _hovered = true),
            onExit:  (_) => setState(() => _hovered = false),
            child: GestureDetector(
              onTapDown:   (_) => setState(() => _pressed = true),
              onTapUp:     (_) => setState(() => _pressed = false),
              onTapCancel: ()  => setState(() => _pressed = false),
              onTap: () => Navigator.pushNamed(context, widget.item.route),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                transform: Matrix4.identity()..scale(_pressed ? 0.97 : 1.0),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: _hovered ? widget.item.color : p.surface,
                  border: Border.all(
                    color: _hovered ? widget.item.color : p.surfaceBorder,
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: p.accentLight.withOpacity(_hovered ? 0.35 : 0.2),
                      blurRadius: _hovered ? 12 : 4,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    widget.item.label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 3,
                      color: _hovered ? Colors.white : widget.item.color,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
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
    return Positioned.fill(child: CustomPaint(painter: _BgPainter(p: p)));
  }
}

class _BgPainter extends CustomPainter {
  final _Palette p;
  const _BgPainter({required this.p});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    paint.color = p.surfaceBorder.withOpacity(0.5);
    canvas.drawCircle(
      Offset(size.width * 0.85, size.height * 0.05),
      size.width * 0.4,
      paint,
    );

    paint.color = const Color(0xFFB2DFDB).withOpacity(
      p.background == const Color(0xFF121212) ? 0.08 : 0.45,
    );
    canvas.drawCircle(
      Offset(size.width * 0.05, size.height * 0.92),
      size.width * 0.38,
      paint,
    );

    paint.color = p.iconBg.withOpacity(0.35);
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.5),
      size.width * 0.55,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _BgPainter old) => old.p.background != p.background;
}

// ─────────────────────────────────────────────
//  MODELO DE ÍTEM DE MENÚ
// ─────────────────────────────────────────────

class _MenuItem {
  final String label;
  final String route;
  final Color color;
  final int delay;

  const _MenuItem({
    required this.label,
    required this.route,
    required this.color,
    required this.delay,
  });
}