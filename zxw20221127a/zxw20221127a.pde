//魔改版
//白色背景 黑色线 外加三种颜色填充

import processing.pdf.*;

int sideSection = 10;//how many units each side be divided 每边分成多少个单元 20格  试试改成10个
int elementSection= 3;//how many sections each unit be divided 每个单元分成多少部分    可能不需要
int elementSize;//size of each unit 每个单元的大小
int unitSizeMax = 8;//how many units the biggest block can occupy: unitSizeMax * unitSizeMax
int elementWeight = 3;//the stroke weight of all the arcs and lines 线的粗细    应该不需要

float largeBlockThrehold = 0.8;//threhold to control large size of blocks 用于控制大尺寸块的Threhold

ArrayList<Block> blocks;//container of different size of blocks 不同大小的blocks
int[][] element;//if one element is occupied, the value = 1, else the value = 0
boolean savePDF;

//开始运行

void setup() {
  size(800, 800);
  background(255);
  frameRate(0.5);
  
  elementSize = width / sideSection;//size of side of each element

  initiateBackgroundGrid();
  blocks = new ArrayList<Block>();

  placeBlocks();
}

void resetSystem() {
  blocks.clear();
  initiateBackgroundGrid();
  placeBlocks();
}

void initiateBackgroundGrid() {
  element = new int[sideSection][sideSection];
  for (int i = 0; i < sideSection; i ++) {
    for (int j = 0; j < sideSection; j ++) {
      element[i][j] = 0;
    }
  }
}

void placeBlocks() {
  for (int i = 0; i < sideSection * sideSection; i ++) {
    int xIndex = i%sideSection;
    int yIndex = i/sideSection;

    if (random(1) > largeBlockThrehold) 
    {
      int us = int(random(2, unitSizeMax));

      if (xIndex + us < sideSection && yIndex + us < sideSection) 
      {
        int elementOccpuied = 0;

        for (int m = 0; m < us; m ++) {
          for (int n = 0; n < us; n ++) {
            elementOccpuied += element[xIndex + m][yIndex + n];
          }
        }

        if (elementOccpuied == 0) 
        {
          //int fc = int(map(i, 0, element.length-1, 102, 255));
          //color fcolor = color(fc, fc, fc);
          color fcolor = color(247, 249, 246);
          blocks.add(new Block(xIndex, yIndex, us, fcolor));

          for (int m = 0; m < us; m ++) {
            for (int n = 0; n < us; n ++) {
              element[xIndex + m][yIndex + n] = 1;
            }
          }
        }
        
      }
    }
  }

  for (int i = 0; i < sideSection; i ++) {
    for (int j = 0; j < sideSection; j ++) {
      if (element[i][j] == 0) {
        blocks.add(new Block(i, j, 1, 255));
      }
    }
  }
}

void draw() {
  if (savePDF) {
    beginRecord(PDF, "outPut/pattern_"+year()+month()+day()+hour()+minute()+second()+".pdf");
  }

  background(21, 57, 71);
  //drawBackground();
  for (Block b : blocks) {
    //b.drawBlock();
    b.generatePattern();
  }
  
  if(savePDF){
    save("outPut/pattern_"+year()+month()+day()+hour()+minute()+second()+".png");
  }

  if (savePDF) {
    println("pdf and png saved!");
    endRecord();
    savePDF = false;
  }

  println(blocks.size());
}

void drawBackground() {
  for (int i = 0; i < sideSection; i ++) {
    for (int j = 0; j < sideSection; j ++) {
      pushStyle();
      if (element[i][j] == 0) {
        fill(0);
      } else {
        fill(40);
      }
      stroke(51);
      strokeWeight(1);
      rect(elementSize * i, elementSize * j, elementSize, elementSize);
      popStyle();

      pushStyle();
      textAlign(CENTER, CENTER);
      fill(255, 0, 255);
      textSize(12);
      text(element[i][j], elementSize * (i+0.5), elementSize * (j+0.5));
      popStyle();
    }
  }
}

void keyPressed() {
  if (key == 'r') {
    resetSystem();
  }
  if (key == 'p') {
    savePDF = true;
  }
}
