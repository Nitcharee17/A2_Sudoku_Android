int[][] table = {
  {0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0}
};

void setup() {
  size(900, 900);
  background(255);
  
  generateSudoku();
  drawGrid();
}

void draw() {
}

void drawGrid() {
  int cell = width / 9;
  for (int i = 0; i < 10; i++) {
    if (i == 0 || i == 9) {
      strokeWeight(6);
    } else if (i % 3 == 0) {
      strokeWeight(3);
    } else {
      strokeWeight(1);
    }
    line(i * cell, 0, i * cell, height);
    line(0, i * cell, width, i * cell);
  }

  textAlign(CENTER, CENTER);
  textSize(cell * 0.6);
  fill(0);
  for (int r = 0; r < 9; r++) {
    for (int c = 0; c < 9; c++) {
      if (table[r][c] != 0) {
        text(str(table[r][c]), c * cell + cell/2, r * cell + cell/2);
      }
    }
  }
}

void generateSudoku() {
  solve(0, 0);
}

boolean solve(int row, int col) {
  if (row == 9) {
    return true;
  }

  int nextRow = (col == 8) ? row + 1 : row;
  int nextCol = (col == 8) ? 0 : col + 1;

  int[] nums = {1,2,3,4,5,6,7,8,9};
  shuffleArray(nums);
  
  for (int i = 0; i < nums.length; i++) {
    int n = nums[i];
    if (isSafe(row, col, n)) {
      table[row][col] = n;
      if (solve(nextRow, nextCol)) {
        return true;
      }
      table[row][col] = 0;
    }
  }
  return false;
}

boolean isSafe(int row, int col, int n) {
  for (int c = 0; c < 9; c++) {
    if (table[row][c] == n) {
      return false;
    }
  }
  for (int r = 0; r < 9; r++) {
    if (table[r][col] == n) {
      return false;
    }
  }

  int startRow = (row / 3) * 3;
  int startCol = (col / 3) * 3;
  for (int r = startRow; r < startRow + 3; r++) {
    for (int c = startCol; c < startCol + 3; c++) {
      if (table[r][c] == n) {
        return false;
      }
    }
  }
  return true;
}

void shuffleArray(int[] arr) {
  for (int i = arr.length - 1; i > 0; i--) {
    int j = (int)random(0, i + 1);
    int temp = arr[i];
    arr[i] = arr[j];
    arr[j] = temp;
  }
}
