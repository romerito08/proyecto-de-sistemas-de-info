// Modelo de una casilla del tablero de Buscaminas

class CellModel {
  final int row;
  final int col;
  bool hasMine;
  bool isRevealed;
  bool isFlagged;
  int minesAround;

  CellModel({
    required this.row,
    required this.col,
    this.hasMine = false,
    this.isRevealed = false,
    this.isFlagged = false,
    this.minesAround = 0,
  });

  void reset() {
    hasMine = false;
    isRevealed = false;
    isFlagged = false;
    minesAround = 0;
  }

  CellModel copyWith({
    bool? hasMine,
    bool? isRevealed,
    bool? isFlagged,
    int? minesAround,
  }) {
    return CellModel(
      row: row,
      col: col,
      hasMine: hasMine ?? this.hasMine,
      isRevealed: isRevealed ?? this.isRevealed,
      isFlagged: isFlagged ?? this.isFlagged,
      minesAround: minesAround ?? this.minesAround,
    );
  }
}