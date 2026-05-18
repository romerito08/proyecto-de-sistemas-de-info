import 'dart:math';
 
enum CellState { hidden, revealed, flagged }
 
enum GameState { idle, playing, won, lost }
 
class Cell {
  bool isMine;
  int adjacentMines;
  CellState state;
 
  Cell({
    this.isMine = false,
    this.adjacentMines = 0,
    this.state = CellState.hidden,
  });
 
  bool get isRevealed => state == CellState.revealed;
  bool get isFlagged  => state == CellState.flagged;
  bool get isHidden   => state == CellState.hidden;
}
 
class BoardLogic {
  final int rows;
  final int cols;
  final int mines;
 
  late List<List<Cell>> grid;
  GameState gameState = GameState.idle;
  int flagCount = 0;
  int revealedCount = 0;
  bool _firstClick = true;
 
  BoardLogic({required this.rows, required this.cols, required this.mines}) {
    _init();
  }
 
  int get totalSafe => rows * cols - mines;
  int get minesLeft => mines - flagCount;
 
  // ── Inicializar / reiniciar ──────────────────────────────────────────────
 
  void _init() {
    grid = List.generate(
      rows,
      (_) => List.generate(cols, (_) => Cell()),
    );
    gameState     = GameState.idle;
    flagCount     = 0;
    revealedCount = 0;
    _firstClick   = true;
  }
 
  void reset() => _init();
 
  // ── Colocar minas (tras el primer click) ────────────────────────────────
 
  void _placeMines(int safeR, int safeC) {
    final rand = Random();
    int placed = 0;
    while (placed < mines) {
      final r = rand.nextInt(rows);
      final c = rand.nextInt(cols);
      final safe = (r - safeR).abs() <= 1 && (c - safeC).abs() <= 1;
      if (!grid[r][c].isMine && !safe) {
        grid[r][c].isMine = true;
        placed++;
      }
    }
    _calcNumbers();
  }
 
  void _calcNumbers() {
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (!grid[r][c].isMine) {
          grid[r][c].adjacentMines = _countAdjacent(r, c);
        }
      }
    }
  }
 
  int _countAdjacent(int r, int c) {
    int count = 0;
    for (int dr = -1; dr <= 1; dr++) {
      for (int dc = -1; dc <= 1; dc++) {
        final nr = r + dr;
        final nc = c + dc;
        if (_inBounds(nr, nc) && grid[nr][nc].isMine) count++;
      }
    }
    return count;
  }
 
  bool _inBounds(int r, int c) =>
      r >= 0 && r < rows && c >= 0 && c < cols;
 
  // ── Revelar celda ────────────────────────────────────────────────────────
 
  /// Retorna true si el juego continúa, false si perdiste.
  bool reveal(int r, int c) {
    final cell = grid[r][c];
    if (!cell.isHidden) return true;
 
    if (_firstClick) {
      _firstClick = false;
      _placeMines(r, c);
      gameState = GameState.playing;
    }
 
    if (cell.isMine) {
      cell.state = CellState.revealed;
      _revealAllMines();
      gameState = GameState.lost;
      return false;
    }
 
    _floodReveal(r, c);
 
    if (revealedCount >= totalSafe) {
      gameState = GameState.won;
      _flagAllMines();
    }
 
    return gameState != GameState.lost;
  }
 
  void _floodReveal(int r, int c) {
    if (!_inBounds(r, c)) return;
    final cell = grid[r][c];
    if (!cell.isHidden || cell.isMine) return;
 
    cell.state = CellState.revealed;
    revealedCount++;
 
    if (cell.adjacentMines == 0) {
      for (int dr = -1; dr <= 1; dr++) {
        for (int dc = -1; dc <= 1; dc++) {
          if (dr != 0 || dc != 0) _floodReveal(r + dr, c + dc);
        }
      }
    }
  }
 
  // ── Bandera ──────────────────────────────────────────────────────────────
 
  void toggleFlag(int r, int c) {
    final cell = grid[r][c];
    if (cell.isRevealed) return;
    if (cell.isFlagged) {
      cell.state = CellState.hidden;
      flagCount--;
    } else if (flagCount < mines) {
      cell.state = CellState.flagged;
      flagCount++;
    }
  }
 
  // ── Helpers fin de juego ─────────────────────────────────────────────────
 
  void _revealAllMines() {
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (grid[r][c].isMine) grid[r][c].state = CellState.revealed;
      }
    }
  }
 
  void _flagAllMines() {
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (grid[r][c].isMine) grid[r][c].state = CellState.flagged;
      }
    }
  }
}