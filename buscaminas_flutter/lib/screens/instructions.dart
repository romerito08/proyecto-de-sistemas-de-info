import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
//  PALETA ADAPTATIVA
// ─────────────────────────────────────────────

class _Palette {
  final Color background;
  final Color surface;
  final Color surfaceBorder;
  final Color surfaceShadow;
  final Color accent;
  final Color accentMuted;
  final Color textPrimary;
  final Color textSecondary;
  final Color textBody;
  final Color difficultyBorder;
  final Color difficultyText;

  const _Palette._({
    required this.background,
    required this.surface,
    required this.surfaceBorder,
    required this.surfaceShadow,
    required this.accent,
    required this.accentMuted,
    required this.textPrimary,
    required this.textSecondary,
    required this.textBody,
    required this.difficultyBorder,
    required this.difficultyText,
  });

  factory _Palette.of(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return dark ? _Palette._dark() : _Palette._light();
  }

  factory _Palette._light() => const _Palette._(
        background: Color(0xFFF1F8E9),
        surface: Colors.white,
        surfaceBorder: Color(0xFFC8E6C9),
        surfaceShadow: Color(0xFFA5D6A7),
        accent: Color(0xFF2E7D32),
        accentMuted: Color(0xFF66BB6A),
        textPrimary: Color(0xFF1B5E20),
        textSecondary: Color(0xFF66BB6A),
        textBody: Color(0xFF424242),
        difficultyBorder: Color(0xFFE0E0E0),
        difficultyText: Color(0xFF616161),
      );

  factory _Palette._dark() => const _Palette._(
        background: Color(0xFF121212),
        surface: Color(0xFF1E1E1E),
        surfaceBorder: Color(0xFF2E4A2E),
        surfaceShadow: Color(0xFF388E3C),
        accent: Color(0xFF81C784),
        accentMuted: Color(0xFF4CAF50),
        textPrimary: Color(0xFFA5D6A7),
        textSecondary: Color(0xFF4CAF50),
        textBody: Color(0xFFB0B0B0),
        difficultyBorder: Color(0xFF333333),
        difficultyText: Color(0xFF9E9E9E),
      );
}

// ─────────────────────────────────────────────
//  INSTRUCTIONS SCREEN
// ─────────────────────────────────────────────

class InstructionsScreen extends StatelessWidget {
  const InstructionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = _Palette.of(context);

    return Scaffold(
      backgroundColor: p.background,
      body: Stack(
        children: [
          _BackgroundDecor(p: p),
          SafeArea(
            child: Column(
              children: [
                // ── Encabezado ──
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 18,
                          color: p.accent,
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: p.surface,
                          side: BorderSide(color: p.surfaceBorder, width: 1.5),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Contenido Adaptativo ──
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth > 700;
                      return _InstructionsLayout(
                        isWide: isWide,
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
    );
  }

  // ── Columna Izquierda: Objetivo y Dificultades ──
  Widget _buildLeftColumn(_Palette p) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildObjectiveCard(p),
        const SizedBox(height: 28),
        _SectionTitle(title: 'NIVELES DE DESAFÍO', p: p),
        const SizedBox(height: 12),
        _DifficultyRow(
          title: 'FÁCIL',
          details: 'Tablero 6 × 6',
          mines: '10 minas',
          color: Color(0xFF2E7D32),
          p: p,
        ),
        _DifficultyRow(
          title: 'MEDIO',
          details: 'Tablero 8 × 8',
          mines: '20 minas',
          color: Color(0xFF00796B),
          p: p,
        ),
        _DifficultyRow(
          title: 'DIFÍCIL',
          details: 'Tablero 10 × 10',
          mines: '30 minas',
          color: Color(0xFF00695C),
          p: p,
        ),
      ],
    );
  }

  // ── Columna Derecha: Reglas ──
  Widget _buildRightColumn(_Palette p) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(title: 'REGLAS DE JUEGO', p: p),
        const SizedBox(height: 12),
        _InstructionTile(
          icon: Icons.touch_app_rounded,
          iconColor: Color(0xFF2E7D32),
          text: 'Toca una casilla del tablero para revelarla. ¡No te preocupes! El primer toque siempre estará libre de peligro.',
          p: p,
        ),
        _InstructionTile(
          icon: Icons.looks_one_rounded,
          iconColor: Color(0xFF388E3C),
          text: 'Los números revelados te indican cuántas minas hay escondidas en las 8 casillas que la rodean.',
          p: p,
        ),
        _InstructionTile(
          icon: Icons.auto_awesome_mosaic_rounded,
          iconColor: Color(0xFF00796B),
          text: 'Si revelas una casilla vacía (0 minas adyacentes), se abrirá automáticamente toda el área conectada.',
          p: p,
        ),
        _InstructionTile(
          icon: Icons.emoji_events_rounded,
          iconColor: Color(0xFF558B2F),
          text: '¡Ganas la partida cuando logres descubrir y limpiar todas las casillas seguras del mapa!',
          p: p,
        ),
      ],
    );
  }

  Widget _buildObjectiveCard(_Palette p) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: p.surfaceBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: p.surfaceShadow.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'OBJETIVO',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
              color: p.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Tu misión es despejar todo el campo de juego descubriendo todas las casillas seguras. ¡Si pisas una sola mina oculta, perderás de inmediato!',
            style: TextStyle(
              fontSize: 14,
              color: p.textBody,
              height: 1.4,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  LAYOUT ADAPTATIVO
// ─────────────────────────────────────────────

class _InstructionsLayout extends StatelessWidget {
  final bool isWide;
  final Widget leftColumn;
  final Widget rightColumn;

  const _InstructionsLayout({
    required this.isWide,
    required this.leftColumn,
    required this.rightColumn,
  });

  @override
  Widget build(BuildContext context) {
    final p = _Palette.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Text(
                'INSTRUCCIONES',
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
//  SUBTÍTULOS DE SECCIÓN
// ─────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String title;
  final _Palette p;
  const _SectionTitle({required this.title, required this.p});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w800,
        letterSpacing: 3,
        color: p.accentMuted,
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  FILA DE INSTRUCCIÓN INDIVIDUAL
// ─────────────────────────────────────────────

class _InstructionTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String text;
  final _Palette p;

  const _InstructionTile({
    required this.icon,
    required this.iconColor,
    required this.text,
    required this.p,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: iconColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  color: p.textBody,
                  height: 1.4,
                  fontWeight: FontWeight.w500,
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
//  FILA DE DIFICULTADES
// ─────────────────────────────────────────────

class _DifficultyRow extends StatelessWidget {
  final String title;
  final String details;
  final String mines;
  final Color color;
  final _Palette p;

  const _DifficultyRow({
    required this.title,
    required this.details,
    required this.mines,
    required this.color,
    required this.p,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: p.difficultyBorder, width: 1),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 13,
              letterSpacing: 1.5,
              color: color,
            ),
          ),
          const Spacer(),
          Text(
            details,
            style: TextStyle(
              fontSize: 13,
              color: p.difficultyText,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: p.difficultyText,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            mines,
            style: TextStyle(
              fontSize: 13,
              color: p.difficultyText,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  FONDO
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

    paint.color = p.surfaceBorder.withOpacity(0.35);
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.5),
      size.width * 0.55,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _BgPainter old) => old.p.background != p.background;
}