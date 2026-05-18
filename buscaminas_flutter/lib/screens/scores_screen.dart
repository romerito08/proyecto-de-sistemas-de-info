import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:buscaminas_flutter/logica/scores.dart';

class ScoresScreen extends StatefulWidget {
  const ScoresScreen({super.key});

  @override
  State<ScoresScreen> createState() => _ScoresScreenState();
}

class _ScoresScreenState extends State<ScoresScreen>
    with SingleTickerProviderStateMixin {
  // ── Tabs por dificultad ──────────────────────────────────────────────────
  late TabController _tabController;
  final List<String> _difficulties = ['Fácil', 'Medio', 'Difícil'];

  Map<String, List<ScoreEntry>> _scores = {};
  bool _loading = true;

  // ── Medallas ──────────────────────────────────────────────────────────────
  static const _medals = ['🥇', '🥈', '🥉'];

  static const _medalColors = [
    Color(0xFFFFF8E1), // oro  - fondo
    Color(0xFFF5F5F5), // plata
    Color(0xFFFBE9E7), // bronce
  ];

  static const _medalBorders = [
    Color(0xFFFFD54F), // oro
    Color(0xFFBDBDBD), // plata
    Color(0xFFFF8A65), // bronce
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _difficulties.length, vsync: this);
    _loadScores();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ── Carga de scores ───────────────────────────────────────────────────────

  Future<void> _loadScores() async {
    final prefs = await SharedPreferences.getInstance();
    final result = <String, List<ScoreEntry>>{};

    for (final diff in _difficulties) {
      final raw = prefs.getStringList('scores_$diff') ?? [];
      result[diff] = raw.map((e) => ScoreEntry.fromJson(e)).toList()
        ..sort((a, b) => a.seconds.compareTo(b.seconds));
    }

    setState(() {
      _scores = result;
      _loading = false;
    });
  }

  // ── Borrar todos los marcadores ───────────────────────────────────────────

  Future<void> _clearAll() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: const Color(0xFFF1F8E9),
        title: const Text(
          '¿Borrar todo?',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.w800, color: Color(0xFFC62828)),
        ),
        content: const Text(
          'Se eliminarán todos los marcadores de todas las dificultades.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFF555555)),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF2E7D32)),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFFC62828),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(
                  horizontal: 24, vertical: 10),
            ),
            child: const Text('Borrar',
                style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final prefs = await SharedPreferences.getInstance();
    for (final diff in _difficulties) {
      await prefs.remove('scores_$diff');
    }
    await _loadScores();
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF2E7D32), size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'MARCADORES',
          style: TextStyle(
            color: Color(0xFF1B5E20),
            fontWeight: FontWeight.w800,
            letterSpacing: 3,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded,
                color: Color(0xFFC62828)),
            tooltip: 'Borrar todo',
            onPressed: _clearAll,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF2E7D32),
          labelColor: const Color(0xFF1B5E20),
          unselectedLabelColor: const Color(0xFF9E9E9E),
          labelStyle: const TextStyle(
              fontWeight: FontWeight.w800, fontSize: 13),
          tabs: _difficulties
              .map((d) => Tab(text: d.toUpperCase()))
              .toList(),
        ),
      ),
      body: _loading
          ? const Center(
              child:
                  CircularProgressIndicator(color: Color(0xFF2E7D32)))
          : TabBarView(
              controller: _tabController,
              children: _difficulties
                  .map((d) => _buildDifficultyTab(d))
                  .toList(),
            ),
    );
  }

  // ── Tab por dificultad ────────────────────────────────────────────────────

  Widget _buildDifficultyTab(String difficulty) {
    final entries = _scores[difficulty] ?? [];

    if (entries.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🏆', style: TextStyle(fontSize: 56)),
            const SizedBox(height: 16),
            const Text(
              'Aún no tienes registros.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF555555),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '¡Juega tu primera partida en $difficulty!',
              style: const TextStyle(
                  color: Color(0xFF9E9E9E), fontSize: 13),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
      children: [
        // Encabezado de columnas
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: const [
              SizedBox(width: 36), // espacio medalla
              Expanded(
                  flex: 3,
                  child: Text('JUGADOR',
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF9E9E9E),
                          letterSpacing: 1))),
              Expanded(
                  flex: 2,
                  child: Text('TIEMPO',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF9E9E9E),
                          letterSpacing: 1))),
              Expanded(
                  flex: 3,
                  child: Text('FECHA',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF9E9E9E),
                          letterSpacing: 1))),
            ],
          ),
        ),
        const SizedBox(height: 4),

        // Filas de scores
        ...List.generate(entries.length, (i) => _buildRow(entries[i], i)),
      ],
    );
  }

  // ── Fila de score ─────────────────────────────────────────────────────────

  Widget _buildRow(ScoreEntry entry, int index) {
    final isTop3 = index < 3;
    final bgColor = isTop3
        ? _medalColors[index]
        : (index.isEven ? Colors.white : const Color(0xFFF9FBF9));
    final borderColor =
        isTop3 ? _medalBorders[index] : const Color(0xFFE0E0E0);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: isTop3 ? 1.5 : 1),
        boxShadow: isTop3
            ? [
                BoxShadow(
                  color: borderColor.withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                )
              ]
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            // Medalla o número
            SizedBox(
              width: 28,
              child: Text(
                isTop3 ? _medals[index] : '${index + 1}',
                style: TextStyle(
                  fontSize: isTop3 ? 20 : 13,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF9E9E9E),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 8),

            // Nombre
            Expanded(
              flex: 3,
              child: Text(
                entry.playerName,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: isTop3
                      ? const Color(0xFF1B5E20)
                      : const Color(0xFF333333),
                  letterSpacing: 0.5,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Tiempo
            Expanded(
              flex: 2,
              child: Text(
                entry.timeFormatted,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                  color: isTop3
                      ? const Color(0xFF2E7D32)
                      : const Color(0xFF555555),
                ),
              ),
            ),

            // Fecha
            Expanded(
              flex: 3,
              child: Text(
                _formatDate(entry.date),
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF9E9E9E),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime d) {
    final day = d.day.toString().padLeft(2, '0');
    final month = d.month.toString().padLeft(2, '0');
    final year = d.year.toString().substring(2);
    final h = d.hour.toString().padLeft(2, '0');
    final m = d.minute.toString().padLeft(2, '0');
    return '$day/$month/$year $h:$m';
  }
}
