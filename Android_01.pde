int[][] grid = {
  {5, 3, 0, 0, 7, 0, 0, 0, 0},
  {6, 0, 0, 1, 9, 5, 0, 0, 0},
  {0, 9, 8, 0, 0, 0, 0, 6, 0},
  {8, 0, 0, 0, 6, 0, 0, 0, 3},
  {4, 0, 0, 8, 0, 3, 0, 0, 1},
  {7, 0, 0, 0, 2, 0, 0, 0, 6},
  {0, 6, 0, 0, 0, 0, 2, 8, 0},
  {0, 0, 0, 4, 1, 9, 0, 0, 5},
  {0, 0, 0, 0, 8, 0, 0, 7, 9}
};

boolean[][] locked = new boolean[9][9];
int cell = 60;
PVector selected = null;
int buttonY = 540;

void setup() {
  size(750, 750);
  textAlign(CENTER, CENTER);
  textSize(24);
  
  for (int r = 0; r < 9; r++) {
    for (int c = 0; c < 9; c++) {
      locked[r][c] = grid[r][c] != 0;
    }
  }
}

void draw() {
  background(255);
  drawGrid();
  drawNumbers();
  drawButtons();
}

void drawGrid() {
  for (int i = 0; i <= 9; i++) {
    strokeWeight(i % 3 == 0 ? 3 : 1);
    line(0, i*cell, 9*cell, i*cell);
    line(i*cell, 0, i*cell, 9*cell);
  }
  if (selected != null) {
    noFill();
    strokeWeight(3);
    rect(selected.x*cell, selected.y*cell, cell, cell);
  }
}

void drawNumbers() {
  textSize(32);
  for (int r = 0; r < 9; r++) {
    for (int c = 0; c < 9; c++) {
      if (grid[r][c] != 0) {
        if (locked[r][c]) {
          fill(0);
        } else if (isConflict(r, c, grid[r][c])) {
          fill(255, 0, 0);
        } else {
          fill(0, 200, 0);
        }
        text(grid[r][c], c*cell + cell/2, r*cell + cell/2);
      }
    }
  }
}

void drawButtons() {
  textSize(20);
  for (int i = 0; i < 9; i++) {
    int x = i * 60;
    int y = buttonY;
    fill(200);
    rect(x, y, 60, 50);
    fill(0);
    text(i+1, x+30, y+25);
  }
}

void mousePressed() {
  if (mouseY < 540) {
    int c = mouseX / cell;
    int r = mouseY / cell;
    if (r >= 0 && r < 9 && c >= 0 && c < 9) {
      selected = new PVector(c, r);
    }
  } else if (mouseY >= buttonY && mouseY <= buttonY + 50) {
    int i = mouseX / 60;
    if (i >= 0 && i < 9 && selected != null) {
      int r = (int)selected.y;
      int c = (int)selected.x;
      if (!locked[r][c]) {
        grid[r][c] = i + 1;
      }
    }
  }
}

boolean isConflict(int row, int col, int val) {
  for (int c = 0; c < 9; c++) {
    if (c != col && grid[row][c] == val) return true;
  }
  for (int r = 0; r < 9; r++) {
    if (r != row && grid[r][col] == val) return true;
  }
  int startRow = row - row % 3;
  int startCol = col - col % 3;
  for (int r = startRow; r < startRow+3; r++) {
    for (int c = startCol; c < startCol+3; c++) {
      if ((r != row || c != col) && grid[r][c] == val) return true;
    }
  }
  return false;
}
