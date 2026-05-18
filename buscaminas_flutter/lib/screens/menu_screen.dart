import 'package:flutter/material.dart';
import 'settings_screen.dart';
import 'game_screen.dart';
import 'instructions.dart';
import 'scores_screen.dart';
import 'about_screen.dart';

void main() {
  runApp(const MenuScreen());
}

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Buscaminas Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MainMenuScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/game': (context) => const GameScreen(),
        '/instructions': (context) => const InstructionsScreen(),
        '/scores': (context) => const ScoresScreen(),
        '/about': (context) => const AboutScreen(),
      },
    );
  }
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
    final isWide = MediaQuery.of(context).size.width > 700;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9),
      body: Stack(
        children: [
          const _BackgroundDecor(),
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
                          child: const _GameTitle(),
                        ),
                      ),
                      const SizedBox(height: 40),
                      ..._menuItems.map((item) => _AnimatedMenuButton(
                            item: item,
                            controller: _menuController,
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
  const _GameTitle();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: const Color(0xFFDCEDC8),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFA5D6A7), width: 2),
          ),
          child: const Icon(
            Icons.energy_savings_leaf_rounded,
            size: 42,
            color: Color(0xFF2E7D32),
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          'BUSCAMINAS',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w900,
            letterSpacing: 6,
            color: Color(0xFF1B5E20),
            height: 1,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 28, height: 1.5, color: const Color(0xFF81C784)),
            const SizedBox(width: 10),
            const Text(
              'FLUTTER',
              style: TextStyle(
                fontSize: 10,
                letterSpacing: 4,
                color: Color(0xFF66BB6A),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 10),
            Container(width: 28, height: 1.5, color: const Color(0xFF81C784)),
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

  const _AnimatedMenuButton({required this.item, required this.controller});

  @override
  State<_AnimatedMenuButton> createState() => _AnimatedMenuButtonState();
}

class _AnimatedMenuButtonState extends State<_AnimatedMenuButton> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
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
                  color: _hovered ? widget.item.color : Colors.white,
                  border: Border.all(
                    color: _hovered
                        ? widget.item.color
                        : const Color(0xFFC8E6C9),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFA5D6A7)
                          .withOpacity(_hovered ? 0.35 : 0.2),
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
  const _BackgroundDecor();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(child: CustomPaint(painter: _BgPainter()));
  }
}

class _BgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    paint.color = const Color(0xFFC8E6C9).withOpacity(0.5);
    canvas.drawCircle(
      Offset(size.width * 0.85, size.height * 0.05),
      size.width * 0.4,
      paint,
    );

    paint.color = const Color(0xFFB2DFDB).withOpacity(0.45);
    canvas.drawCircle(
      Offset(size.width * 0.05, size.height * 0.92),
      size.width * 0.38,
      paint,
    );

    paint.color = const Color(0xFFDCEDC8).withOpacity(0.35);
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.5),
      size.width * 0.55,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────
//  FOOTER
// ─────────────────────────────────────────────



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