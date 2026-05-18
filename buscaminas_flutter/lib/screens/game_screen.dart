import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:buscaminas_flutter/logica/board_logic.dart';
import 'package:buscaminas_flutter/logica/sonido.dart';
import 'package:buscaminas_flutter/logica/scores.dart';

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
    'Fácil': {'rows': 6, 'cols': 6, 'mines': 10},
    'Medio': {'rows': 8, 'cols': 8, 'mines': 20},
    'Difícil': {'rows': 10, 'cols': 10, 'mines': 30},
  };

  // ── Paletas de colores por estilo de números ─────────────────────────────
  static const Map<String, List<Color>> _numberColors = {
    'Clásico': [
      Color(0xFF1565C0), // 1 - azul
      Color(0xFF2E7D32), // 2 - verde
      Color(0xFFC62828), // 3 - rojo
      Color(0xFF6A1B9A), // 4 - morado
      Color(0xFFBF360C), // 5 - naranja oscuro
      Color(0xFF00838F), // 6 - cian
      Color(0xFF37474F), // 7 - gris oscuro
      Color(0xFF424242), // 8 - gris
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

    // Controlador de animación para aparición del tablero
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
      _difficulty = prefs.getString('difficulty') ?? 'Fácil';
      _numberStyle = prefs.getString('numberStyle') ?? 'Clásico';
      _soundEnabled = prefs.getBool('sound') ?? true;
      _animationsEnabled = prefs.getBool('animations') ?? true;
      _loading = false;
    });

    _initBoard();

    // Pedir nombre antes de empezar
    WidgetsBinding.instance.addPostFrameCallback((_) => _showNameDialog());
  }

  void _initBoard() {
    _timer?.cancel();
    _elapsedSeconds = 0;

    final params =
        _difficultyParams[_difficulty] ?? _difficultyParams['Fácil']!;
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
    final controller = TextEditingController(text: _playerName);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: const Color(0xFFF1F8E9),
          title: const Text(
            '¿Cómo te llamas?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: Color(0xFF1B5E20),
              fontSize: 18,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Máximo 7 caracteres',
                style: TextStyle(color: Color(0xFF777777), fontSize: 12),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                autofocus: true,
                maxLength: 7,
                textCapitalization: TextCapitalization.words,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1B5E20),
                  letterSpacing: 2,
                ),
                decoration: InputDecoration(
                  counterText: '',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFA5D6A7)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        color: Color(0xFF2E7D32), width: 2),
                  ),
                  hintText: 'TU NOMBRE',
                  hintStyle: const TextStyle(
                      color: Color(0xFFBDBDBD), fontSize: 16),
                ),
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () {
                final name = controller.text.trim();
                if (name.isEmpty) return; // no permite vacío
                setState(() => _playerName = name);
                Navigator.of(dialogContext).pop();
              },
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(
                    horizontal: 36, vertical: 12),
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

    // Arrancar cronómetro en el primer toque real
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
      Future.delayed(
          const Duration(milliseconds: 300), _showGameOverDialog);
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

    // Solo guardar si ganó (scores = mejores tiempos)
    if (won) {
      raw.add(entry.toJson());

      // Ordenar por tiempo ascendente y conservar solo top 5
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
    final won = _board.gameState == GameState.won;

    // Guardar score si ganó
    if (won) _saveScore(true);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: const Color(0xFFF1F8E9),
        title: Text(
          won ? '¡Ganaste! 🎉' : 'Pisaste una mina 💥',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: won ? const Color(0xFF2E7D32) : const Color(0xFFC62828),
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Nombre del jugador
            Text(
              _playerName.isEmpty ? 'Jugador' : _playerName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1B5E20),
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              won
                  ? 'Completaste $_difficulty en $_timeFormatted'
                  : 'Duraste $_timeFormatted antes de explotar.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF555555)),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          // ── Jugar de nuevo ───────────────────────────────────────────────
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              if (!mounted) return;
              setState(() => _initBoard());
              _showNameDialog();
            },
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              padding:
                  const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
            ),
            child: const Text('Jugar de nuevo',
                style: TextStyle(fontWeight: FontWeight.w700)),
          ),
          // ── Menú principal ───────────────────────────────────────────────
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              if (!mounted) return;
              Navigator.of(context).pop();
            },
            style:
                TextButton.styleFrom(foregroundColor: const Color(0xFF2E7D32)),
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
    if (_loading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF1F8E9),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF2E7D32)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF2E7D32),
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
              style: const TextStyle(
                color: Color(0xFF1B5E20),
                fontWeight: FontWeight.w800,
                letterSpacing: 2,
                fontSize: 14,
              ),
            ),
            if (_playerName.isNotEmpty)
              Text(
                _playerName,
                style: const TextStyle(
                  color: Color(0xFF2E7D32),
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
                const Icon(Icons.timer_outlined,
                    color: Color(0xFF2E7D32), size: 16),
                const SizedBox(width: 2),
                Text(
                  _timeFormatted,
                  style: const TextStyle(
                    color: Color(0xFF1B5E20),
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
                const Icon(Icons.park_sharp,
                    color: Color(0xFF2E7D32), size: 18),
                const SizedBox(width: 4),
                Text(
                  '${_board.minesLeft}',
                  style: const TextStyle(
                    color: Color(0xFF1B5E20),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFC8E6C9),
                    width: 1.5,
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.refresh_rounded,
                      color: Color(0xFF2E7D32),
                      size: 18,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Reiniciar',
                      style: TextStyle(
                        color: Color(0xFF2E7D32),
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
                child: _buildBoard(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Construcción del tablero ──────────────────────────────────────────────

  Widget _buildBoard() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: AspectRatio(
        aspectRatio: _board.cols / _board.rows,
        child: Column(
          children: List.generate(_board.rows, (r) {
            return Expanded(
              child: Row(
                children: List.generate(_board.cols, (c) {
                  return Expanded(child: _buildCell(r, c));
                }),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildCell(int r, int c) {
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
          color: _cellColor(cell),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: cell.isRevealed
                ? const Color(0xFFDCEDC8)
                : const Color(0xFFA5D6A7),
            width: 1.2,
          ),
          boxShadow: cell.isHidden
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
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

  Color _cellColor(Cell cell) {
    if (cell.isFlagged) return const Color(0xFFFFF9C4);
    if (!cell.isRevealed) return Colors.white;
    if (cell.isMine) return const Color(0xFFFFCDD2);
    return const Color(0xFFE8F5E9);
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
