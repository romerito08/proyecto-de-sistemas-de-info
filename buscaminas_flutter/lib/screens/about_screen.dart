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
        accentMuted: Color(0xFF81C784),
        textPrimary: Color(0xFF1B5E20),
        textSecondary: Color(0xFF81C784),
        iconBg: Color(0xFFE8F5E9),
        iconBorder: Color(0xFFC8E6C9),
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
        iconBorder: Color(0xFF2E4A2E),
      );
}

// ─────────────────────────────────────────────
//  ABOUT SCREEN
// ─────────────────────────────────────────────

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

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
                // ── AppBar custom ──
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
                          side: BorderSide(
                            color: p.surfaceBorder,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

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

                            // Título
                            Text(
                              'CRÉDITOS',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 6,
                                color: p.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 14),

                            // Tarjeta equipo
                            _Card(
                              titulo: 'Equipo',
                              p: p,
                              child: Column(
                                children: [
                                  _Integrante(
                                    nombre: 'Sofia Romero',
                                    cedula: '20241120007',
                                    p: p,
                                  ),
                                  const SizedBox(height: 12),
                                  _Integrante(
                                    nombre: 'Gianfranco Camporeale',
                                    cedula: '20251110476',
                                    p: p,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 14),

                            // Tarjeta proyecto
                            _Card(
                              titulo: 'Proyecto',
                              p: p,
                              child: Column(
                                children: [
                                  _InfoRow(label: 'Nombre',      value: 'Buscaminas Flutter',         p: p),
                                  const SizedBox(height: 8),
                                  _InfoRow(label: 'Materia',     value: 'Sistemas de Información',    p: p),
                                  const SizedBox(height: 8),
                                  _InfoRow(label: 'Profesor',    value: 'Franklin Sandoval',          p: p),
                                  const SizedBox(height: 8),
                                  _InfoRow(label: 'Período',     value: '2526-3',                     p: p),
                                  const SizedBox(height: 8),
                                  _InfoRow(label: 'Institución', value: 'Universidad Metropolitana',  p: p),
                                  const SizedBox(height: 8),
                                ],
                              ),
                            ),
                            const SizedBox(height: 28),
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
}

// ── Tarjeta ───────────────────────────────────

class _Card extends StatelessWidget {
  final String titulo;
  final Widget child;
  final _Palette p;
  const _Card({required this.titulo, required this.child, required this.p});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: p.surfaceBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: p.accentLight.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 3,
              color: p.accentMuted,
            ),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

// ── Integrante ────────────────────────────────

class _Integrante extends StatelessWidget {
  final String nombre;
  final String cedula;
  final _Palette p;
  const _Integrante({required this.nombre, required this.cedula, required this.p});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: p.iconBg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: p.iconBorder),
          ),
          child: Icon(
            Icons.person_rounded,
            size: 18,
            color: p.accent,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              nombre,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: p.textPrimary,
              ),
            ),
            Text(
              cedula,
              style: TextStyle(
                fontSize: 12,
                color: p.textSecondary,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Fila de info ──────────────────────────────

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final _Palette p;
  const _InfoRow({required this.label, required this.value, required this.p});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: p.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13,
              color: p.accent,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Fondo decorativo ──────────────────────────

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