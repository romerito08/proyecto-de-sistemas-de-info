import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:buscaminas_flutter/logica/board_logic.dart';
import 'package:buscaminas_flutter/logica/sonido.dart';
import 'package:buscaminas_flutter/logica/scores.dart';

// ─────────────────────────────────────────────
//  PALETA ADAPTATIVA
// ─────────────────────────────────────────────

class _Palette {
  final Color background;
  final Color surface;
  final Color surfaceBorder;
  final Color accent;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;

  // Celdas
  final Color cellHidden;
  final Color cellHiddenBorder;
  final Color cellRevealed;
  final Color cellRevealedBorder;
  final Color cellFlagged;
  final Color cellMine;
  final Color cellShadow;

  // Diálogos
  final Color dialogBg;
  final Color dialogTitle;
  final Color dialogBody;
  final Color dialogHint;
  final Color dialogFieldFill;
  final Color dialogFieldBorder;
  final Color dialogFieldFocused;

  const _Palette._({
    required this.background,
    required this.surface,
    required this.surfaceBorder,
    required this.accent,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.cellHidden,
    required this.cellHiddenBorder,
    required this.cellRevealed,
    required this.cellRevealedBorder,
    required this.cellFlagged,
    required this.cellMine,
    required this.cellShadow,
    required this.dialogBg,
    required this.dialogTitle,
    required this.dialogBody,
    required this.dialogHint,
    required this.dialogFieldFill,
    required this.dialogFieldBorder,
    required this.dialogFieldFocused,
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
        textPrimary: Color(0xFF1B5E20),
        textSecondary: Color(0xFF2E7D32),
        textMuted: Color(0xFF555555),
        cellHidden: Colors.white,
        cellHiddenBorder: Color(0xFFA5D6A7),
        cellRevealed: Color(0xFFE8F5E9),
        cellRevealedBorder: Color(0xFFDCEDC8),
        cellFlagged: Color(0xFFFFF9C4),
        cellMine: Color(0xFFFFCDD2),
        cellShadow: Colors.black,
        dialogBg: Color(0xFFF1F8E9),
        dialogTitle: Color(0xFF1B5E20),
        dialogBody: Color(0xFF555555),
        dialogHint: Color(0xFFBDBDBD),
        dialogFieldFill: Colors.white,
        dialogFieldBorder: Color(0xFFA5D6A7),
        dialogFieldFocused: Color(0xFF2E7D32),
      );

  factory _Palette._dark() => const _Palette._(
        background: Color(0xFF121212),
        surface: Color(0xFF1E1E1E),
        surfaceBorder: Color(0xFF2E4A2E),
        accent: Color(0xFF81C784),
        textPrimary: Color(0xFFA5D6A7),
        textSecondary: Color(0xFF81C784),
        textMuted: Color(0xFF9E9E9E),
        cellHidden: Color(0xFF1E1E1E),
        cellHiddenBorder: Color(0xFF388E3C),
        cellRevealed: Color(0xFF1B2E1B),
        cellRevealedBorder: Color(0xFF2E4A2E),
        cellFlagged: Color(0xFF2E2A00),
        cellMine: Color(0xFF3E1212),
        cellShadow: Colors.black,
        dialogBg: Color(0xFF1A1A1A),
        dialogTitle: Color(0xFFA5D6A7),
        dialogBody: Color(0xFF9E9E9E),
        dialogHint: Color(0xFF616161),
        dialogFieldFill: Color(0xFF242424),
        dialogFieldBorder: Color(0xFF388E3C),
        dialogFieldFocused: Color(0xFF81C784),
      );
}

// ─────────────────────────────────────────────
//  GAME SCREEN
// ─────────────────────────────────────────────

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  // ── Configuración leída de SharedPreferences ─────────────────────────────
  String _difficulty = 'Fácil';
  String _numberStyle = 'Clásico';
  bool _soundEnabled = true;
  bool _animationsEnabled = true;
  bool _loading = true;

  // ── Jugador y cronómetro ──────────────────────────────────────────────────
  String _playerName = '';
  int _elapsedSeconds = 0;
  Timer? _timer;

  // ── Lógica del tablero ───────────────────────────────────────────────────
  late BoardLogic _board;

  // ── Animaciones ──────────────────────────────────────────────────────────
  late AnimationController _boardFadeController;
  late Animation<double> _boardFadeAnim;

  // ── Mapa de dificultad → parámetros del tablero ──────────────────────────
  static const Map<String, Map<String, int>> _difficultyParams = {
    'Fácil':   {'rows': 6,  'cols': 6,  'mines': 10},
    'Medio':   {'rows': 8,  'cols': 8,  'mines': 20},
    'Difícil': {'rows': 10, 'cols': 10, 'mines': 30},
  };

  // ── Paletas de colores por estilo de números ─────────────────────────────
  static const Map<String, List<Color>> _numberColors = {
    'Clásico': [
      Color(0xFF1565C0),
      Color(0xFF2E7D32),
      Color(0xFFC62828),
      Color(0xFF6A1B9A),
      Color(0xFFBF360C),
      Color(0xFF00838F),
      Color(0xFF37474F),
      Color(0xFF424242),
    ],
    'Colorido': [
      Color(0xFFE91E63),
      Color(0xFF9C27B0),
      Color(0xFF00BCD4),
      Color(0xFFFF9800),
      Color(0xFF4CAF50),
      Color(0xFFFF5722),
      Color(0xFF3F51B5),
      Color(0xFF795548),
    ],
    'Retro': [
      Color(0xFFFFEB3B),
      Color(0xFF4CAF50),
      Color(0xFFFF5722),
      Color(0xFF03A9F4),
      Color(0xFFE91E63),
      Color(0xFF00E5FF),
      Color(0xFFFFFFFF),
      Color(0xFFBDBDBD),
    ],
    'Minimalista': [
      Color(0xFF616161),
      Color(0xFF757575),
      Color(0xFF9E9E9E),
      Color(0xFF616161),
      Color(0xFF757575),
      Color(0xFF9E9E9E),
      Color(0xFF616161),
      Color(0xFF757575),
    ],
  };

  // ── Lifecycle ────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();

    _boardFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _boardFadeAnim = CurvedAnimation(
      parent: _boardFadeController,
      curve: Curves.easeOut,
    );

    _loadSettingsAndInit();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _boardFadeController.dispose();
    super.dispose();
  }

  // ── Carga de configuración y creación del tablero ────────────────────────

  Future<void> _loadSettingsAndInit() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _difficulty     = prefs.getString('difficulty')   ?? 'Fácil';
      _numberStyle    = prefs.getString('numberStyle')  ?? 'Clásico';
      _soundEnabled   = prefs.getBool('sound')          ?? true;
      _animationsEnabled = prefs.getBool('animations')  ?? true;
      _loading        = false;
    });

    _initBoard();

    WidgetsBinding.instance.addPostFrameCallback((_) => _showNameDialog());
  }

  void _initBoard() {
    _timer?.cancel();
    _elapsedSeconds = 0;

    final params = _difficultyParams[_difficulty] ?? _difficultyParams['Fácil']!;
    _board = BoardLogic(
      rows: params['rows']!,
      cols: params['cols']!,
      mines: params['mines']!,
    );

    if (_animationsEnabled) {
      _boardFadeController.forward(from: 0);
    } else {
      _boardFadeController.value = 1.0;
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _elapsedSeconds++);
    });
  }

  void _stopTimer() => _timer?.cancel();

  String get _timeFormatted {
    final m = _elapsedSeconds ~/ 60;
    final s = _elapsedSeconds % 60;
    return m > 0 ? '${m}m ${s.toString().padLeft(2, '0')}s' : '${s}s';
  }

  void _restartGame() {
    if (_soundEnabled) SoundService.playButton();
    setState(() => _initBoard());
    _showNameDialog();
  }

  // ── Diálogo de nombre ─────────────────────────────────────────────────────

  void _showNameDialog() {
    final p = _Palette.of(context);
    final controller = TextEditingController(text: _playerName);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: p.dialogBg,
          title: Text(
            '¿Cómo te llamas?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: p.dialogTitle,
              fontSize: 18,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Máximo 7 caracteres',
                style: TextStyle(color: p.textMuted, fontSize: 12),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                autofocus: true,
                maxLength: 7,
                textCapitalization: TextCapitalization.words,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: p.dialogTitle,
                  letterSpacing: 2,
                ),
                decoration: InputDecoration(
                  counterText: '',
                  filled: true,
                  fillColor: p.dialogFieldFill,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: p.dialogFieldBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: p.dialogFieldFocused, width: 2),
                  ),
                  hintText: 'TU NOMBRE',
                  hintStyle: TextStyle(color: p.dialogHint, fontSize: 16),
                ),
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () {
                final name = controller.text.trim();
                if (name.isEmpty) return;
                setState(() => _playerName = name);
                Navigator.of(dialogContext).pop();
              },
              style: TextButton.styleFrom(
                backgroundColor: p.accent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 12),
              ),
              child: const Text('¡A jugar!',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
            ),
          ],
        );
      },
    );
  }

  // ── Interacciones con el tablero ─────────────────────────────────────────

  void _onCellTap(int r, int c) {
    if (_board.gameState == GameState.won || _board.gameState == GameState.lost)
      return;

    final cell = _board.grid[r][c];
    if (cell.isFlagged || cell.isRevealed) return;

    if (_board.gameState == GameState.idle) _startTimer();

    setState(() {
      final continua = _board.reveal(r, c);

      if (_soundEnabled) {
        if (!continua) {
          SoundService.playLose();
        } else if (_board.gameState == GameState.won) {
          SoundService.playWin();
        } else {
          SoundService.playReveal();
        }
      }
    });

    if (_board.gameState == GameState.won ||
        _board.gameState == GameState.lost) {
      _stopTimer();
      Future.delayed(const Duration(milliseconds: 300), _showGameOverDialog);
    }
  }

  void _onCellLongPress(int r, int c) {
    if (_board.gameState == GameState.won || _board.gameState == GameState.lost)
      return;

    setState(() {
      _board.toggleFlag(r, c);
      if (_soundEnabled) SoundService.playFlag();
    });
  }

  // ── Guardar score ─────────────────────────────────────────────────────────

  Future<void> _saveScore(bool won) async {
    final entry = ScoreEntry(
      playerName: _playerName.isEmpty ? 'Jugador' : _playerName,
      difficulty: _difficulty,
      won: won,
      seconds: _elapsedSeconds,
      date: DateTime.now(),
    );

    final prefs = await SharedPreferences.getInstance();
    final key = 'scores_$_difficulty';
    final raw = prefs.getStringList(key) ?? [];

    if (won) {
      raw.add(entry.toJson());

      final entries = raw
          .map((e) => ScoreEntry.fromJson(e))
          .where((e) => e.won)
          .toList()
        ..sort((a, b) => a.seconds.compareTo(b.seconds));

      final top5 = entries.take(5).map((e) => e.toJson()).toList();
      await prefs.setStringList(key, top5);
    }
  }

  // ── Diálogo fin de partida ────────────────────────────────────────────────

  void _showGameOverDialog() {
    final p = _Palette.of(context);
    final won = _board.gameState == GameState.won;

    if (won) _saveScore(true);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: p.dialogBg,
        title: Text(
          won ? '¡Ganaste! 🎉' : 'Pisaste una mina 💥',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: won ? p.accent : const Color(0xFFC62828),
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _playerName.isEmpty ? 'Jugador' : _playerName,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: p.textPrimary,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              won
                  ? 'Completaste $_difficulty en $_timeFormatted'
                  : 'Duraste $_timeFormatted antes de explotar.',
              textAlign: TextAlign.center,
              style: TextStyle(color: p.dialogBody),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              if (!mounted) return;
              setState(() => _initBoard());
              _showNameDialog();
            },
            style: TextButton.styleFrom(
              backgroundColor: p.accent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
            ),
            child: const Text('Jugar de nuevo',
                style: TextStyle(fontWeight: FontWeight.w700)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              if (!mounted) return;
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(foregroundColor: p.accent),
            child: const Text('Menú principal'),
          ),
        ],
      ),
    );
  }

  // ── Color de número según estilo ─────────────────────────────────────────

  Color _numberColor(int n) {
    final palette = _numberColors[_numberStyle] ?? _numberColors['Clásico']!;
    if (n < 1 || n > palette.length) return Colors.black;
    return palette[n - 1];
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final p = _Palette.of(context);

    if (_loading) {
      return Scaffold(
        backgroundColor: p.background,
        body: Center(
          child: CircularProgressIndicator(color: p.accent),
        ),
      );
    }

    return Scaffold(
      backgroundColor: p.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: p.accent,
            size: 18,
          ),
          onPressed: () {
            if (_soundEnabled) SoundService.playButton();
            Navigator.pop(context);
          },
        ),
        title: Column(
          children: [
            Text(
              _difficulty.toUpperCase(),
              style: TextStyle(
                color: p.textPrimary,
                fontWeight: FontWeight.w800,
                letterSpacing: 2,
                fontSize: 14,
              ),
            ),
            if (_playerName.isNotEmpty)
              Text(
                _playerName,
                style: TextStyle(
                  color: p.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
        centerTitle: true,
        actions: [
          // Cronómetro
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Row(
              children: [
                Icon(Icons.timer_outlined, color: p.accent, size: 16),
                const SizedBox(width: 2),
                Text(
                  _timeFormatted,
                  style: TextStyle(
                    color: p.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          // Contador de minas restantes
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                Icon(Icons.park_sharp, color: p.accent, size: 18),
                const SizedBox(width: 4),
                Text(
                  '${_board.minesLeft}',
                  style: TextStyle(
                    color: p.textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Botón reiniciar ───────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: GestureDetector(
              onTap: _restartGame,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: p.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: p.surfaceBorder, width: 1.5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.refresh_rounded, color: p.accent, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      'Reiniciar',
                      style: TextStyle(
                        color: p.accent,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Tablero ───────────────────────────────────────────────────────
          Expanded(
            child: Center(
              child: FadeTransition(
                opacity: _boardFadeAnim,
                child: _buildBoard(p),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Construcción del tablero ──────────────────────────────────────────────

  Widget _buildBoard(_Palette p) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: AspectRatio(
        aspectRatio: _board.cols / _board.rows,
        child: Column(
          children: List.generate(_board.rows, (r) {
            return Expanded(
              child: Row(
                children: List.generate(_board.cols, (c) {
                  return Expanded(child: _buildCell(r, c, p));
                }),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildCell(int r, int c, _Palette p) {
    final cell = _board.grid[r][c];

    return GestureDetector(
      onTap: () => _onCellTap(r, c),
      onLongPress: () => _onCellLongPress(r, c),
      child: AnimatedContainer(
        duration: _animationsEnabled
            ? const Duration(milliseconds: 150)
            : Duration.zero,
        margin: const EdgeInsets.all(1.5),
        decoration: BoxDecoration(
          color: _cellColor(cell, p),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: cell.isRevealed ? p.cellRevealedBorder : p.cellHiddenBorder,
            width: 1.2,
          ),
          boxShadow: cell.isHidden
              ? [
                  BoxShadow(
                    color: p.cellShadow.withOpacity(0.08),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Center(child: _cellContent(cell)),
      ),
    );
  }

  // ── Color de celda ────────────────────────────────────────────────────────

  Color _cellColor(Cell cell, _Palette p) {
    if (cell.isFlagged)   return p.cellFlagged;
    if (!cell.isRevealed) return p.cellHidden;
    if (cell.isMine)      return p.cellMine;
    return p.cellRevealed;
  }

  // ── Contenido de celda ────────────────────────────────────────────────────

  Widget? _cellContent(Cell cell) {
    if (cell.isFlagged) {
      return const Text('🌱', style: TextStyle(fontSize: 14));
    }
    if (!cell.isRevealed) return null;
    if (cell.isMine) {
      return const Text('💣', style: TextStyle(fontSize: 14));
    }
    if (cell.adjacentMines == 0) return null;

    return Text(
      '${cell.adjacentMines}',
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w900,
        color: _numberColor(cell.adjacentMines),
      ),
    );
  }
}