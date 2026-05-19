import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:buscaminas_flutter/logica/scores.dart';

// ─────────────────────────────────────────────
//  PALETA ADAPTATIVA
// ─────────────────────────────────────────────

class _Palette {
  final Color background;
  final Color surface;
  final Color surfaceAlt;
  final Color accent;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color headerBorder;
  final Color tabIndicator;
  final Color tabLabel;
  final Color tabUnselected;
  final Color deleteIcon;
  final Color rowBorderDefault;

  const _Palette._({
    required this.background,
    required this.surface,
    required this.surfaceAlt,
    required this.accent,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.headerBorder,
    required this.tabIndicator,
    required this.tabLabel,
    required this.tabUnselected,
    required this.deleteIcon,
    required this.rowBorderDefault,
  });

  factory _Palette.of(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return dark ? _Palette._dark() : _Palette._light();
  }

  factory _Palette._light() => const _Palette._(
        background: Color(0xFFF1F8E9),
        surface: Colors.white,
        surfaceAlt: Color(0xFFF9FBF9),
        accent: Color(0xFF2E7D32),
        textPrimary: Color(0xFF1B5E20),
        textSecondary: Color(0xFF2E7D32),
        textMuted: Color(0xFF9E9E9E),
        headerBorder: Colors.transparent,
        tabIndicator: Color(0xFF2E7D32),
        tabLabel: Color(0xFF1B5E20),
        tabUnselected: Color(0xFF9E9E9E),
        deleteIcon: Color(0xFFC62828),
        rowBorderDefault: Color(0xFFE0E0E0),
      );

  factory _Palette._dark() => const _Palette._(
        background: Color(0xFF121212),
        surface: Color(0xFF1E1E1E),
        surfaceAlt: Color(0xFF1A1A1A),
        accent: Color(0xFF81C784),
        textPrimary: Color(0xFFA5D6A7),
        textSecondary: Color(0xFF81C784),
        textMuted: Color(0xFF757575),
        headerBorder: Colors.transparent,
        tabIndicator: Color(0xFF81C784),
        tabLabel: Color(0xFFA5D6A7),
        tabUnselected: Color(0xFF616161),
        deleteIcon: Color(0xFFEF9A9A),
        rowBorderDefault: Color(0xFF2C2C2C),
      );
}

// ─────────────────────────────────────────────
//  SCORES SCREEN
// ─────────────────────────────────────────────

class ScoresScreen extends StatefulWidget {
  const ScoresScreen({super.key});

  @override
  State<ScoresScreen> createState() => _ScoresScreenState();
}

class _ScoresScreenState extends State<ScoresScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _difficulties = ['Fácil', 'Medio', 'Difícil'];

  Map<String, List<ScoreEntry>> _scores = {};
  bool _loading = true;

  static const _medals = ['🥇', '🥈', '🥉'];

  static const _medalColors = [
    Color(0xFFFFF8E1),
    Color(0xFFF5F5F5),
    Color(0xFFFBE9E7),
  ];

  static const _medalColorsDark = [
    Color(0xFF2C2600),
    Color(0xFF1F1F1F),
    Color(0xFF2C1200),
  ];

  static const _medalBorders = [
    Color(0xFFFFD54F),
    Color(0xFFBDBDBD),
    Color(0xFFFF8A65),
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

  Future<void> _clearAll() async {
    final p = _Palette.of(context);

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: p.background,
        title: Text(
          '¿Borrar todo?',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: p.deleteIcon,
          ),
        ),
        content: Text(
          'Se eliminarán todos los marcadores de todas las dificultades.',
          textAlign: TextAlign.center,
          style: TextStyle(color: p.textMuted),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            style: TextButton.styleFrom(foregroundColor: p.accent),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFFC62828),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
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

  @override
  Widget build(BuildContext context) {
    final p = _Palette.of(context);

    return Scaffold(
      backgroundColor: p.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: p.accent, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'MARCADORES',
          style: TextStyle(
            color: p.textPrimary,
            fontWeight: FontWeight.w800,
            letterSpacing: 3,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.delete_outline_rounded, color: p.deleteIcon),
            tooltip: 'Borrar todo',
            onPressed: _clearAll,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: p.tabIndicator,
          labelColor: p.tabLabel,
          unselectedLabelColor: p.tabUnselected,
          labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
          tabs: _difficulties.map((d) => Tab(text: d.toUpperCase())).toList(),
        ),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator(color: p.accent))
          : TabBarView(
              controller: _tabController,
              children: _difficulties
                  .map((d) => _buildDifficultyTab(d, p))
                  .toList(),
            ),
    );
  }

  Widget _buildDifficultyTab(String difficulty, _Palette p) {
    final entries = _scores[difficulty] ?? [];

    if (entries.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🏆', style: TextStyle(fontSize: 56)),
            const SizedBox(height: 16),
            Text(
              'Aún no tienes registros.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: p.textMuted,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '¡Juega tu primera partida en $difficulty!',
              style: TextStyle(color: p.textMuted, fontSize: 13),
            ),
          ],
        ),
      );
    }

    final dark = Theme.of(context).brightness == Brightness.dark;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
      children: [
        // Encabezado de columnas
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              const SizedBox(width: 36),
              Expanded(
                flex: 3,
                child: Text('JUGADOR',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: p.textMuted,
                        letterSpacing: 1)),
              ),
              Expanded(
                flex: 2,
                child: Text('TIEMPO',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: p.textMuted,
                        letterSpacing: 1)),
              ),
              Expanded(
                flex: 3,
                child: Text('FECHA',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: p.textMuted,
                        letterSpacing: 1)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),

        ...List.generate(
          entries.length,
          (i) => _buildRow(entries[i], i, p, dark),
        ),
      ],
    );
  }

  Widget _buildRow(ScoreEntry entry, int index, _Palette p, bool dark) {
    final isTop3 = index < 3;
    final medalBgs = dark ? _medalColorsDark : _medalColors;

    final bgColor = isTop3
        ? medalBgs[index]
        : (index.isEven ? p.surface : p.surfaceAlt);
    final borderColor = isTop3 ? _medalBorders[index] : p.rowBorderDefault;

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
                  color: p.textMuted,
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
                  color: isTop3 ? p.textPrimary : p.textSecondary,
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
                  color: isTop3 ? p.accent : p.textMuted,
                ),
              ),
            ),

            // Fecha
            Expanded(
              flex: 3,
              child: Text(
                _formatDate(entry.date),
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 11,
                  color: p.textMuted,
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