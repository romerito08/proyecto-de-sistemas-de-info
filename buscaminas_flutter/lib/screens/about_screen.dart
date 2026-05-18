import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9),
      body: Stack(
        children: [
          const _BackgroundDecor(),
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
                            const Text(
                              'CRÉDITOS',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 6,
                                color: Color(0xFF1B5E20),
                              ),
                            ),
                            const SizedBox(height: 14),

                            // Tarjeta equipo
                            _Card(
                              titulo: 'Equipo',
                              child: Column(
                                children: const [
                                  _Integrante(
                                    nombre: 'Sofia Romero',
                                    cedula: '20241120007',
                                  ),
                                  SizedBox(height: 12),
                                  _Integrante(
                                    nombre: 'Gianfranco Camporeale',
                                    cedula: '20251110476',
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 14),

                            // Tarjeta proyecto
                            _Card(
                              titulo: 'Proyecto',
                              child: Column(
                                children: const [
                                  _InfoRow(
                                    label: 'Nombre',
                                    value: 'Buscaminas Flutter',
                                  ),
                                  SizedBox(height: 8),
                                  _InfoRow(
                                    label: 'Materia',
                                    value: 'Sistemas de Información',
                                  ),
                                  SizedBox(height: 8),
                                  _InfoRow(
                                    label: 'Profesor',
                                    value: 'Franklin Sandoval',
                                  ),
                                  SizedBox(height: 8),
                                  _InfoRow(label: 'Período', value: '2526-3'),
                                  SizedBox(height: 8),
                                  _InfoRow(
                                    label: 'Institución',
                                    value: 'Universidad Metropolitana',
                                  ),
                                  SizedBox(height: 8),
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
  const _Card({required this.titulo, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFC8E6C9), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFA5D6A7).withOpacity(0.2),
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
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 3,
              color: Color(0xFF81C784),
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
  const _Integrante({required this.nombre, required this.cedula});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E9),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFC8E6C9)),
          ),
          child: const Icon(
            Icons.person_rounded,
            size: 18,
            color: Color(0xFF2E7D32),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              nombre,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1B5E20),
              ),
            ),
            Text(
              cedula,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF81C784),
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
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF81C784),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF2E7D32),
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
