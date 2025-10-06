int[][] grid = new int[9][9];
boolean[][] locked = new boolean[9][9];
int cell = 60;
int button_y = 560;
int[] selected = null;

void setup() {
  size(750, 750);
  textAlign(CENTER, CENTER);
  textSize(24);
  makePuzzle(10);  
}

void draw() {
  background(255);
  drawGrid();
  drawNumbers();
  drawButtons();
}

void drawGrid() {
  for (int i = 0; i < 10; i++) {
    strokeWeight(i % 3 == 0 ? 3 : 1);
    line(0, i*cell, 9*cell, i*cell);
    line(i*cell, 0, i*cell, 9*cell);
  }
  if (selected != null) {
    int r = selected[0];
    int c = selected[1];
    noFill();
    strokeWeight(3);
    rect(c*cell, r*cell, cell, cell);
  }
}

void drawNumbers() {
  textSize(32);
  fill(0);
  for (int r = 0; r < 9; r++) {
    for (int c = 0; c < 9; c++) {
      if (grid[r][c] != 0) {
        text(str(grid[r][c]), c*cell + cell/2, r*cell + cell/2);
      }
    }
  }
}

void drawButtons() {
  textSize(20);
  for (int i = 0; i < 9; i++) {
    int x = i * 60;
    int y = button_y;
    fill(200);
    rect(x, y, 60, 50);
    fill(0);
    text(str(i+1), x+30, y+25);
  }
}

void mousePressed() {
  if (mouseY < 540) {
    int c = mouseX / cell;
    int r = mouseY / cell;
    if (r >= 0 && r < 9 && c >= 0 && c < 9) {
      selected = new int[]{r, c};
    }
  } else if (mouseY >= button_y && mouseY <= button_y+50) {
    int i = mouseX / 60;
    if (i >= 0 && i < 9 && selected != null) {
      int r = selected[0];
      int c = selected[1];
      if (!locked[r][c]) {
        if (isValid(r, c, i+1)) {
          grid[r][c] = i+1;
        }
      }
    }
  }
}

boolean fillGrid() {
  for (int i = 0; i < 9; i++) {
    for (int j = 0; j < 9; j++) {
      if (grid[i][j] == 0) {
        Integer[] nums = new Integer[9];
        for (int k = 0; k < 9; k++) nums[k] = k+1;
        shuffleArray(nums);
        for (int num : nums) {
          if (isValid(i, j, num)) {
            grid[i][j] = num;
            if (fillGrid()) return true;
            grid[i][j] = 0;
          }
        }
        return false;
      }
    }
  }
  return true;
}

void makePuzzle(int removals) {
  for (int r = 0; r < 9; r++) {
    for (int c = 0; c < 9; c++) {
      grid[r][c] = 0;
      locked[r][c] = false;
    }
  }
  fillGrid();
  
  ArrayList<int[]> cells = new ArrayList<int[]>();
  for (int r = 0; r < 9; r++) {
    for (int c = 0; c < 9; c++) {
      cells.add(new int[]{r, c});
    }
  }
  java.util.Collections.shuffle(cells);
  int count = 0;
  for (int[] pos : cells) {
    if (count >= removals) break;
    int r = pos[0], c = pos[1];
    grid[r][c] = 0;
    locked[r][c] = false;
    count++;
  }
  
  // Mark locked cells
  for (int r = 0; r < 9; r++) {
    for (int c = 0; c < 9; c++) {
      if (grid[r][c] != 0) {
        locked[r][c] = true;
      }
    }
  }
}

boolean isValid(int row, int col, int val) {
  for (int c = 0; c < 9; c++) {
    if (grid[row][c] == val) return false;
  }
  for (int r = 0; r < 9; r++) {
    if (grid[r][col] == val) return false;
  }
  int startRow = row - row % 3;
  int startCol = col - col % 3;
  for (int r = startRow; r < startRow+3; r++) {
    for (int c = startCol; c < startCol+3; c++) {
      if (grid[r][c] == val) return false;
    }
  }
  return true;
}

void shuffleArray(Integer[] array) {
  for (int i = array.length - 1; i > 0; i--) {
    int j = (int) random(i+1);
    int temp = array[i];
    array[i] = array[j];
    array[j] = temp;
  }
}
