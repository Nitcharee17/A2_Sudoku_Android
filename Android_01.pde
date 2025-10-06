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

int cell = 60;
int[] selected = null;
int buttonY = 560;
boolean[][] locked = new boolean[9][9];

void setup() {
  size(540, 620);
  textAlign(CENTER, CENTER);
  textSize(24);
  
  int r = 0;
  while (r < 9) {
    int c = 0;
    while (c < 9) {
      locked[r][c] = (grid[r][c] != 0);
      c++;
    }
    r++;
  }
}

void draw() {
  background(255);
  drawGrid();
  drawNumbers();
  drawButtons();
}

void drawGrid() {
  int i = 0;
  while (i <= 9) {
    strokeWeight((i % 3 == 0) ? 3 : 1);
    line(0, i * cell, 9 * cell, i * cell);
    line(i * cell, 0, i * cell, 9 * cell);
    i++;
  }
  
  if (selected != null) {
    int r = selected[0];
    int c = selected[1];
    noFill();
    strokeWeight(3);
    rect(c * cell, r * cell, cell, cell);
  }
}

void drawNumbers() {
  textSize(32);
  int r = 0;
  while (r < 9) {
    int c = 0;
    while (c < 9) {
      if (grid[r][c] != 0) {
        if (locked[r][c]) {
          fill(0);
        } else if (isConflict(r, c, grid[r][c])) {
          fill(255, 0, 0);
        } else {
          fill(0, 200, 0);
        }
        text(str(grid[r][c]), c * cell + cell/2, r * cell + cell/2);
      }
      c++;
    }
    r++;
  }
}

void drawButtons() {
  textSize(20);
  int i = 0;
  while (i < 9) {
    int x = i * 60;
    int y = buttonY;
    fill(200);
    rect(x, y, 60, 50);
    fill(0);
    text(str(i + 1), x + 30, y + 25);
    i++;
  }
}

void mousePressed() {
  if (mouseY < 540) {
    int c = mouseX / cell;
    int r = mouseY / cell;
    if (r >= 0 && r < 9 && c >= 0 && c < 9) {
      selected = new int[]{r, c};
    }
  } else if (mouseY >= buttonY && mouseY <= buttonY + 50) {
    int i = mouseX / 60;
    if (i >= 0 && i < 9 && selected != null) {
      int r = selected[0];
      int c = selected[1];
      if (!locked[r][c]) {
        grid[r][c] = i + 1;
      }
    }
  }
}

boolean isConflict(int row, int col, int val) {
  int c = 0;
  while (c < 9) {
    if (c != col && grid[row][c] == val) return true;
    c++;
  }
  int r = 0;
  while (r < 9) {
    if (r != row && grid[r][col] == val) return true;
    r++;
  }
  int startRow = row - row % 3;
  int startCol = col - col % 3;
  r = startRow;
  while (r < startRow + 3) {
    c = startCol;
    while (c < startCol + 3) {
      if ((r != row || c != col) && grid[r][c] == val) return true;
      c++;
    }
    r++;
  }
  return false;
}
