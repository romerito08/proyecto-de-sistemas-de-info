import 'package:flutter/material.dart';

class InstructionsScreen extends StatelessWidget {
  const InstructionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9), // Mismo fondo del menú
      body: Stack(
        children: [
          const _BackgroundDecor(), // Mismo fondo decorativo para consistencia visual
          SafeArea(
            child: Column(
              children: [
                // ── Encabezado alineado a la esquina superior izquierda ──
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 18,
                          color: Color(0xFF2E7D32),
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(
                            color: Color(0xFFC8E6C9),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Contenido escaneable con scroll y restricción de ancho ──
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 480),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 24,
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 16),
                            const Text(
                              'INSTRUCCIONES',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 6,
                                color: Color(0xFF1B5E20),
                              ),
                            ),
                            const SizedBox(height: 14),

                            // Tarjeta de Objetivo Principal
                            _buildObjectiveCard(),
                            const SizedBox(height: 28),

                            // Sección de Reglas de Juego
                            const _SectionTitle(title: 'REGLAS DE JUEGO'),
                            const SizedBox(height: 12),
                            const _InstructionTile(
                              icon: Icons.touch_app_rounded,
                              iconColor: Color(0xFF2E7D32),
                              text: 'Toca una casilla del tablero para revelarla. ¡No te preocupes! El primer toque siempre estará libre de peligro.',
                            ),
                            const _InstructionTile(
                              icon: Icons.looks_one_rounded,
                              iconColor: Color(0xFF388E3C),
                              text: 'Los números revelados te indican cuántas minas hay escondidas en las 8 casillas que la rodean.',
                            ),
                            const _InstructionTile(
                              icon: Icons.auto_awesome_mosaic_rounded,
                              iconColor: Color(0xFF00796B),
                              text: 'Si revelas una casilla vacía (0 minas adyacentes), se abrirá automáticamente toda el área conectada.',
                            ),
                            const _InstructionTile(
                              icon: Icons.emoji_events_rounded,
                              iconColor: Color(0xFF558B2F),
                              text: '¡Ganas la partida cuando logres descubrir y limpiar todas las casillas seguras del mapa!',
                            ),
                            const SizedBox(height: 28),

                            // Sección de Dificultades
                            const _SectionTitle(title: 'NIVELES DE DESAFÍO'),
                            const SizedBox(height: 12),
                            const _DifficultyRow(
                              title: 'FÁCIL',
                              details: 'Tablero 6 × 6',
                              mines: '10 minas',
                              color: Color(0xFF2E7D32),
                            ),
                            const _DifficultyRow(
                              title: 'MEDIO',
                              details: 'Tablero 8 × 8',
                              mines: '20 minas',
                              color: Color(0xFF00796B),
                            ),
                            const _DifficultyRow(
                              title: 'DIFÍCIL',
                              details: 'Tablero 10 × 10',
                              mines: '30 minas',
                              color: Color(0xFF00695C),
                            ),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Tarjeta de objetivo con el estilo de bordes del menú
  Widget _buildObjectiveCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFC8E6C9), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFA5D6A7).withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'OBJETIVO',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                  color: Color(0xFF1B5E20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Tu misión es despejar todo el campo de juego descubriendo todas las casillas seguras. ¡Si pisas una sola mina oculta, perderás de inmediato!',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF424242),
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
//  SUBTÍTULOS DE SECCIÓN
// ─────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w800,
        letterSpacing: 3,
        color: Color(0xFF66BB6A),
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

  const _InstructionTile({
    required this.icon,
    required this.iconColor,
    required this.text,
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
              color: iconColor.withOpacity(0.1),
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
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF333333),
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
//  FILA DE DIFICULTADES EXPLICADAS
// ─────────────────────────────────────────────

class _DifficultyRow extends StatelessWidget {
  final String title;
  final String details;
  final String mines;
  final Color color;

  const _DifficultyRow({
    required this.title,
    required this.details,
    required this.mines,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
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
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF616161),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 12),
          Container(width: 4, height: 4, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.grey)),
          const SizedBox(width: 12),
          Text(
            mines,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF757575),
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
    canvas.drawCircle(Offset(size.width * 0.85, size.height * 0.05), size.width * 0.4, paint);

    paint.color = const Color(0xFFB2DFDB).withOpacity(0.45);
    canvas.drawCircle(Offset(size.width * 0.05, size.height * 0.92), size.width * 0.38, paint);

    paint.color = const Color(0xFFDCEDC8).withOpacity(0.35);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.5), size.width * 0.55, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}