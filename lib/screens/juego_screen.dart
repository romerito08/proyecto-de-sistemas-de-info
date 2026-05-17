import 'dart:math';
import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../utils/constants.dart';
import '../models/cell_model.dart';

class JuegoScreen extends StatefulWidget {
  const JuegoScreen({super.key});

  @override
  State<JuegoScreen> createState() => _JuegoScreenState();
}

class _JuegoScreenState extends State<JuegoScreen> {
  late List<List<CellModel>> _board;
  late Difficulty _difficulty;
  int _rows = 0;
  int _cols = 0;
  int _mineCount = 0;
  int _revealedCount = 0;
  int _flagsPlaced = 0;
  bool _gameOver = false;
  bool _win = false;
  int _startTime = 0;
  int _elapsedTime = 0;
  bool _timerRunning = false;
  int _attempts = 0;

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  void _initGame() {
    String diffName = StorageService.getDifficulty();
    _difficulty = Difficulty.fromName(diffName);
    _rows = _difficulty.rows;
    _cols = _difficulty.cols;
    _mineCount = _difficulty.mineCount;
    _board = List.generate(_rows, (i) => List.generate(_cols, (j) => CellModel(row: i, col: j)));
    _revealedCount = 0;
    _flagsPlaced = 0;
    _gameOver = false;
    _win = false;
    _startTime = 0;
    _elapsedTime = 0;
    _timerRunning = false;
    _attempts = 0;
    _placeMines();
    _calculateNumbers();
    setState(() {});
  }

  void _placeMines() {
    Random rand = Random();
    int minesPlaced = 0;
    while (minesPlaced < _mineCount) {
      int r = rand.nextInt(_rows);
      int c = rand.nextInt(_cols);
      if (!_board[r][c].hasMine) {
        _board[r][c].hasMine = true;
        minesPlaced++;
      }
    }
  }

  void _calculateNumbers() {
    for (int i = 0; i < _rows; i++) {
      for (int j = 0; j < _cols; j++) {
        if (_board[i][j].hasMine) continue;
        int count = 0;
        for (int di = -1; di <= 1; di++) {
          for (int dj = -1; dj <= 1; dj++) {
            int ni = i + di, nj = j + dj;
            if (ni >= 0 && ni < _rows && nj >= 0 && nj < _cols && _board[ni][nj].hasMine) count++;
          }
        }
        _board[i][j].minesAround = count;
      }
    }
  }

  void _revealCell(int row, int col) {
    if (_gameOver || _win) return;
    if (_board[row][col].isRevealed || _board[row][col].isFlagged) return;

    if (!_timerRunning) {
      _startTime = DateTime.now().millisecondsSinceEpoch;
      _timerRunning = true;
      _attempts++;
      setState(() {});
      _startTimer();
    }

    if (_board[row][col].hasMine) {
      _gameOver = true;
      _timerRunning = false;
      _revealAllMines();
      setState(() {});
      _showGameOverDialog(false);
      return;
    }

    _board[row][col].isRevealed = true;
    _revealedCount++;

    if (_revealedCount == (_rows * _cols - _mineCount)) {
      _win = true;
      _timerRunning = false;
      _saveHighScore();
      setState(() {});
      _showGameOverDialog(true);
      return;
    }

    if (_board[row][col].minesAround == 0) {
      for (int di = -1; di <= 1; di++) {
        for (int dj = -1; dj <= 1; dj++) {
          int ni = row + di, nj = col + dj;
          if (ni >= 0 && ni < _rows && nj >= 0 && nj < _cols && !_board[ni][nj].isRevealed && !_board[ni][nj].hasMine) {
            _revealCell(ni, nj);
          }
        }
      }
    }
    setState(() {});
  }

  void _revealAllMines() {
    for (int i = 0; i < _rows; i++) {
      for (int j = 0; j < _cols; j++) {
        if (_board[i][j].hasMine) _board[i][j].isRevealed = true;
      }
    }
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (_timerRunning && !_gameOver && !_win && mounted) {
        setState(() {
          _elapsedTime = (DateTime.now().millisecondsSinceEpoch - _startTime) ~/ 1000;
        });
        _startTimer();
      }
    });
  }

  void _saveHighScore() async {
    await StorageService.saveHighScore(_difficulty.name, _elapsedTime, _attempts, DateTime.now().toString());
  }

  void _showGameOverDialog(bool victory) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(victory ? '¡VICTORIA!' : 'DERROTA'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Tiempo: $_elapsedTime segundos'),
            Text('Intentos: $_attempts'),
            if (victory) const Text('¡Nuevo récord!'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _initGame();
            },
            child: const Text('Reintentar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Salir'),
          ),
        ],
      ),
    );
  }

  void _toggleFlag(int row, int col) {
    if (_gameOver || _win) return;
    if (_board[row][col].isRevealed) return;
    setState(() {
      if (_board[row][col].isFlagged) {
        _board[row][col].isFlagged = false;
        _flagsPlaced--;
      } else {
        _board[row][col].isFlagged = true;
        _flagsPlaced++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buscaminas - ${_difficulty.name}'),
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(child: Text('Tiempo: $_elapsedTime s | Minas: ${_mineCount - _flagsPlaced}')),
          ),
        ],
      ),
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double cellSize = constraints.maxWidth / _cols;
            if (cellSize * _rows > constraints.maxHeight) cellSize = constraints.maxHeight / _rows;
            return SingleChildScrollView(
              child: Column(
                children: [
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _cols,
                      childAspectRatio: 1,
                    ),
                    itemCount: _rows * _cols,
                    itemBuilder: (ctx, index) {
                      int r = index ~/ _cols;
                      int c = index % _cols;
                      CellModel cell = _board[r][c];
                      return GestureDetector(
                        onTap: () => _revealCell(r, c),
                        onLongPress: () => _toggleFlag(r, c),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade800),
                            color: _getCellColor(cell),
                          ),
                          child: Center(
                            child: _getCellContent(cell),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _initGame();
                        },
                        child: const Text('Nueva partida'),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Salir al menú'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Color _getCellColor(CellModel cell) {
    if (cell.isRevealed) return Colors.grey[300]!;
    if (cell.isFlagged) return Colors.yellow[100]!;
    return Colors.green[200]!;
  }

  Widget _getCellContent(CellModel cell) {
    if (!cell.isRevealed) {
      if (cell.isFlagged) return const Text('🚩', style: TextStyle(fontSize: 18));
      return Container();
    }
    if (cell.hasMine) return const Text('💣', style: TextStyle(fontSize: 18));
    if (cell.minesAround == 0) return Container();
    return Text(
      cell.minesAround.toString(),
      style: _getNumberStyle(cell.minesAround),
    );
  }

  TextStyle _getNumberStyle(int number) {
    String style = StorageService.getNumberStyle();
    Color color = Colors.black;
    if (style == NumberStyle.classic) {
      switch (number) {
        case 1: color = Colors.blue; break;
        case 2: color = Colors.green; break;
        case 3: color = Colors.red; break;
        case 4: color = Colors.purple; break;
        case 5: color = Colors.orange; break;
        default: color = Colors.black;
      }
    } else if (style == NumberStyle.colorful) {
      // paleta más vibrante
      color = Colors.primaries[number % Colors.primaries.length];
    } else if (style == NumberStyle.retro) {
      color = Colors.brown[900]!;
    } else {
      color = Colors.black;
    }
    return TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color);
  }
}