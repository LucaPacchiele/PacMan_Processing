/* da fare
- integra font e punteggio
*/



//tipo cella

final int ANG_BL = 1;
final int ANG_BR = 2;
final int ANG_TL = 3;
final int ANG_TR = 4;

final int BORD_L = 5;
final int BORD_R = 6;
final int BORD_U = 7;
final int BORD_D = 8;

final int BORD_UD = 9;
final int BORD_LR = 10;

final int FREE = 12;    //non vi sono bordi o angoli
final int NO_PASS = 13; //non raggiungibili da nessuno
final int SPAWN_MONSTERS = 14; //dove vengono creati i mostri



//movimenti
final int MOV_SX = 1;
final int MOV_DX = 2;
final int MOV_UP = 3;
final int MOV_DW = 4;

// riempimento cella
final int EMPTY = 0;
final int WALL = 1;
final int SPAWN_CELL = 2;
final int PASSED = 3;
final int FRUIT_CELL = 4;
final int FRUIT_CELL_FX = 5;

// stato del gioco
final int GAME_OK = 1;
final int GAME_LOSE_LIFE = 2;
final int GAME_EAT_MONSTER = 3;
final int GAME_EAT_FRUIT = 4;
final int GAME_RESET_ALL = 5;

final int MAX_LIVES = 2;

// dimensioni
final int MAX_ROWS = 9;
final int MAX_COLS = 9;

// velocità
final int SPEED_SLOW=1;
final int SPEED_FAST=2;

int dim=50;
int num_life=MAX_LIVES;
int num_monster=1;
int eat_monster=0;
int num_fruit=1;
int killer=0;

int fruit_red, fruit_green, fruit_blue;

int key_pressed;

long currentMillis = 0;

long previousMillisSpawnPac = 0;
long previousMillisSpawnMonster = 0;
long previousMillisSpawnFruit = 0;

int delaySpawnPac = 3000;
int delaySpawnMonster = 3000;  
int delaySpawnFruit = 5000;   


// definizione matrice labirinto "lab" come array bidimensionale di Cell
Cell[][] lab = new Cell[9][9];
Pacman Pac = new Pacman(dim*8, dim*8, dim/2, 0, 0, SPEED_SLOW, 255, 255, 0);
Monster Mon = new Monster(dim*4, dim*4, dim/2, MOV_UP, 0, SPEED_FAST, 255, 0, 255);

class Cell{
  int x;
  int y;
  int type;
  int fill;
  
  Cell(int x_pos,int y_pos, int type_c, int fill_c){
   x=x_pos;
   y=y_pos;
   type=type_c;
   fill=fill_c;
   }
  } 

class Pacman{
  int x;        //centro x di Pacman, ovvero la sua posizione x corrente
  int y;        //centro y di Pacman, ovvero la sua posizione y corrente
  int dim;      //dimensione (diametro)
  int move;     //direzione del movimento (vedi sopra)
  int stop;     //valore di stop (0 o 1) 
  int speed;    //velocità
  int fill_r;   //riempimento rosso
  int fill_g;   //riempimento verde
  int fill_b;   //riempimento blu
  Pacman(int x_pos,int y_pos, int dimension, int move_val, int stop_val, int speed_val, int red, int green, int blue){
    x=x_pos;
    y=y_pos;
    dim=dimension;
    move=move_val;
    stop=stop_val;
    speed=speed_val;
    fill_r=red;
    fill_g=green;
    fill_b=blue;
  }
}

class Monster{
  int x;        //centro x di Monster, ovvero la sua posizione x corrente
  int y;        //centro y di Monster, ovvero la sua posizione y corrente
  int dim;      //dimensione (diametro)
  int move;     //direzione del movimento (vedi sopra)
  int stop;     //valore di stop (0 o 1) 
  int speed;    //velocità
  int fill_r;   //riempimento rosso
  int fill_g;   //riempimento verde
  int fill_b;   //riempimento blu
  Monster(int x_pos,int y_pos, int dimension, int move_val, int stop_val, int speed_val, int red, int green, int blue){
    x=x_pos;
    y=y_pos;
    dim=dimension;
    move=move_val;
    stop=stop_val;
    speed=speed_val;
    fill_r=red;
    fill_g=green;
    fill_b=blue;
  }
}

void setup(){
  size(800,800);
  
  
//  x_p=dim*8; y_p=dim*8;
//  x_m=dim*4; y_m=dim*4;
 // restart(GAME_RESET_ALL);
  
  
  translate(dim*3, dim*3);
  define_lab(); //generate labyrinth
  translate(-dim*3, -dim*3); //solo per disegno griglia
  
}

void draw(){
  
  currentMillis = millis();

  background(0);
  smooth(2);
  noStroke();
  
  //disegna griglia
  griglia();
  
  //stampe controllo
  
  fill(255,0,0);
  textSize(30);
  text("Stop " + Pac.stop, 10, 30);
  
  fill(0,0,0);
  
  translate(dim*3, dim*3);
  
  /*
  // disegno rettangolo trasparente lab
  fill(204, 102, 0, 200); //alpha da 0 a 255
  rect(0, 0, 450, 450); */
  
  translate(dim/2,dim/2);
  
  //disegna labirinto
  disegna_lab(); //draw labyrinth, for each cell of the matrix
  
  //disegna Pacman
  if(num_life > 0){
    ellipseMode(CENTER);
    if(killer==0){
      //Pac.fill_r=255;
      //Pac.fill_g=255;
      //Pac.fill_b=0;
      Pac.dim=dim/2;
      }
    else {
     // Pac.fill_r=255;
     // Pac.fill_g=0;
     // Pac.fill_b=0;
     Pac.dim=dim/3*2;
      }
    fill(Pac.fill_r, Pac.fill_g, Pac.fill_b);
    ellipse(Pac.x, Pac.y, Pac.dim, Pac.dim);
    
    }
  else{
    Pac.stop=1;
    Mon.stop=1;
    
    fill(50, 50, 50, 200); //alpha da 0 a 255
    rect(-dim*3-dim/2, -dim*3-dim/2, width, height);
    
    if( currentMillis - previousMillisSpawnPac >= delaySpawnPac ){
      Pac.stop=0;
      Mon.stop=0;
      num_life=MAX_LIVES;
      previousMillisSpawnPac += delaySpawnPac;
      text(" TIME PAC ", 100, 620);
      }
    }
  
  // disegna il monster
  if(num_monster > 0 && num_life > 0){
    Mon.fill_r=255;
    Mon.fill_g=0;
    Mon.fill_b=255;
    fill(Mon.fill_r, Mon.fill_g, Mon.fill_b);
    ellipse(Mon.x, Mon.y, Mon.dim, Mon.dim);
    }
  // altrimenti, se non vi sono più mostri...
  else{
    Mon.stop=1;
    // ... ogni delaySpawnMonster secondi genero il mostro
    if( currentMillis - previousMillisSpawnMonster >= delaySpawnMonster ){
      num_monster=1;
      Mon.stop=0;
      previousMillisSpawnMonster += delaySpawnMonster;
      text(" TIME MONSTER ", 100, 590);
      }
    }
  
  //disegna il Fruit

    if( currentMillis - previousMillisSpawnFruit >= delaySpawnFruit ){
      draw_fruit();
      num_fruit=1;
      previousMillisSpawnFruit += delaySpawnFruit;
      }

  //display everything
  text("LIFE: " + num_life, 200, 480);
  text("eat_monster: " + eat_monster, 200, 520);
  text("num_monster: " + num_monster, 200, 550);
  fill(20,200,79);
  text("num_life: " + num_life, 200, 580);
  // println("-->" + second() % time_spawn_monster); // altro modo per far scorrere time_spawn_monster secondi, ma senza possibilità di reset tempo, utilizza il clock di sistema
  
  switch ( check(Pac.x, Pac.y, Mon.x, Mon.y) ){
    case GAME_LOSE_LIFE:
          
      Pac.x=dim*8; Pac.y=dim*8; // reset position Pacman and Monster
      Mon.x=dim*4; Mon.y=dim*4;
            
      
      num_life--;
      
      previousMillisSpawnPac = currentMillis;
      
       
      break;
    case GAME_EAT_MONSTER:
    //controllo sia che è scaduto il timeout, sia che non vi sono più mostri
      num_monster--;
      Mon.x=dim*4; Mon.y=dim*4;
            
      eat_monster++;
      
      previousMillisSpawnMonster = currentMillis;
    
      break;
    case GAME_EAT_FRUIT:
      
      num_fruit--;
      previousMillisSpawnFruit = currentMillis;
      
      break;
      
    
    }
  
  
  //  println("move ", move);
  //  println("stop ", Pac.stop);
  //  println("cella ", cella);
  
  
  //criteri di movimento Pacman
  if(Pac.stop == 0){
    // se va veloce (SPEED _FAST) devo incrementare di 2 la velocità: se ciò accade quando Pac.x o Pac.y sono in valori dello schero dispari, devo fare in modo, aggiungendo 1 px, 
    // che mi muova su valori pari, in modo che la funzione check possa lavorare correttamente
    if(Pac.speed==SPEED_FAST){
      if(Pac.x % 2 != 0) Pac.x++;
      else if (Pac.y % 2 != 0) Pac.y++;
      }
      
    // mi muovo sullo schermo a seconda della direzione di Pacman  
    if(Pac.move == MOV_SX){
      Pac.x=Pac.x-Pac.speed;
      }
    if(Pac.move == MOV_DX){
      Pac.x=Pac.x+Pac.speed;
      }
    if(Pac.move == MOV_UP){
      Pac.y=Pac.y-Pac.speed;
      }
    if(Pac.move == MOV_DW){
      Pac.y=Pac.y+Pac.speed;
      }
    }
    
  //criteri di movimento Monster
  if(Mon.stop == 0){
    if(Mon.move == MOV_SX){
      Mon.x=Mon.x-Mon.speed;
      }
    if(Mon.move == MOV_DX){
      Mon.x=Mon.x+Mon.speed;
      }
    if(Mon.move == MOV_UP){
      Mon.y=Mon.y-Mon.speed;
      }
    if(Mon.move == MOV_DW){
      Mon.y=Mon.y+Mon.speed;
      }
    }
  
  // arc(0, 0, 100, 100, 0, PI+QUARTER_PI, PIE); //arc(x, y, W, H, startangle, stopangle)

} //fine draw()


// disegna il Fruit in una cella libera (EMPTY o EMPTY_FX) a caso
void draw_fruit(){
  int rand_x, rand_y, flag=0;
  do{
    rand_x=int(random(0, MAX_COLS));
    rand_y=int(random(0, MAX_ROWS));
 //   println("rand_x " + rand_x);
 //   println("rand_y " + rand_y);
    
    for(int i=0; i<MAX_ROWS; i++){
      for(int j=0; j<MAX_COLS; j++){
        Cell cella=lab[i][j];
        if (cella.fill == FRUIT_CELL) cella.fill=EMPTY; /*  ----- aggiungere il fill FRUIT_CELL_FX in modo da effettuare un controllo e ricordare se la cella è già stata raggiunta ----------- */
        else if (cella.fill == EMPTY || cella.fill == PASSED){
          if (rand_x==j && rand_y==i){
            cella.fill=FRUIT_CELL;
            flag=1;
            }
          }
        }
      }
    }
  while(flag==0);
  return;
  }


void keyPressed() {   
  if (key == CODED) {
    
    if (keyCode == UP || keyCode == DOWN || keyCode == LEFT || keyCode == RIGHT ){
      
      key_pressed=keyCode;
      // improvvisi cambiamenti di direzione -> switch movimento
      if (keyCode == UP && Pac.move == MOV_DW)
        Pac.move=MOV_UP;
      if (keyCode == DOWN && Pac.move == MOV_UP)
        Pac.move=MOV_DW;
      if (keyCode == LEFT && Pac.move == MOV_DX)
        Pac.move=MOV_SX;
      if (keyCode == RIGHT && Pac.move == MOV_SX)
        Pac.move=MOV_DX;
      }
    }
  if (key == 'a'){
    killer=1;
    Pac.speed=2;
    }
  if (key ==  's'){
    killer=0;
    Pac.speed=1;
    }
   
   } 


void griglia(){
  int cols, rows, videoScale=dim;
  cols = width/videoScale;
  rows = height/videoScale;
  
  for (int i = 0; i < cols; i++) {
    // Begin loop for rows
    for (int j = 0; j < rows; j++) {

      // Scaling up to draw a rectangle at (x,y)
      int x = i*videoScale;
      int y = j*videoScale;
      fill(255);
      stroke(0);
      // For every column and row, a rectangle is drawn at an (x,y) location scaled and sized by videoScale.
      rect(x, y, videoScale, videoScale);
      
     
      
    }
  }
  
}


//definizione tutte le celle con nome, tipologia e coordinate centro

void define_lab(){
  
  /* mi porto sul centro della prima cella (in alto a sx) in modo da definire il centro delle altre
  tramite sempre traslazione di ampiezza dim */
  translate(dim/2, dim/2); 
  
  //ogni Cell è costituita da coordinata x e y del proprio centro, e dal tipo di cella
  
  lab[0][0] = new Cell (0, 0,         ANG_TL,   EMPTY);
  lab[0][1] = new Cell (dim*1, 0,     BORD_UD,  EMPTY);
  lab[0][2] = new Cell (dim*2, 0,     ANG_TR,   EMPTY);
  lab[0][3] = new Cell (dim*3, 0,     NO_PASS,  WALL);
  lab[0][4] = new Cell (dim*4, 0,     NO_PASS,  WALL);
  lab[0][5] = new Cell (dim*5, 0,     NO_PASS,  WALL);
  lab[0][6] = new Cell (dim*6, 0,     ANG_TL,   EMPTY);
  lab[0][7] = new Cell (dim*7, 0,     BORD_UD,  EMPTY);
  lab[0][8] = new Cell (dim*8, 0,     ANG_TR,   EMPTY);
    
  lab[1][0] = new Cell (0, dim*1,     BORD_LR,  EMPTY);
  lab[1][1] = new Cell (dim*1, dim*1, NO_PASS,  WALL);
  lab[1][2] = new Cell (dim*2, dim*1, BORD_L,   EMPTY);
  lab[1][3] = new Cell (dim*3, dim*1, BORD_UD,  EMPTY);
  lab[1][4] = new Cell (dim*4, dim*1, BORD_U,   EMPTY);
  lab[1][5] = new Cell (dim*5, dim*1, BORD_UD,  EMPTY);
  lab[1][6] = new Cell (dim*6, dim*1, BORD_R,   EMPTY);
  lab[1][7] = new Cell (dim*7, dim*1, NO_PASS,  WALL);
  lab[1][8] = new Cell (dim*8, dim*1, BORD_LR,  EMPTY);
  
  lab[2][0] = new Cell (0, dim*2,     ANG_BL,   EMPTY);
  lab[2][1] = new Cell (dim*1, dim*2, BORD_UD,  EMPTY);
  lab[2][2] = new Cell (dim*2, dim*2, BORD_R,   EMPTY);
  lab[2][3] = new Cell (dim*3, dim*2, NO_PASS,  WALL);
  lab[2][4] = new Cell (dim*4, dim*2, BORD_LR,  EMPTY);
  lab[2][5] = new Cell (dim*5, dim*2, NO_PASS,  WALL);
  lab[2][6] = new Cell (dim*6, dim*2, BORD_L,   EMPTY);
  lab[2][7] = new Cell (dim*7, dim*2, BORD_UD,  EMPTY);
  lab[2][8] = new Cell (dim*8, dim*2, ANG_BR,   EMPTY);
  
  lab[3][0] = new Cell (0, dim*3,     NO_PASS,  WALL);
  lab[3][1] = new Cell (dim*1, dim*3, NO_PASS,  WALL);
  lab[3][2] = new Cell (dim*2, dim*3, BORD_L,   EMPTY);
  lab[3][3] = new Cell (dim*3, dim*3, BORD_UD,  EMPTY);
  lab[3][4] = new Cell (dim*4, dim*3, BORD_D,   EMPTY);
  lab[3][5] = new Cell (dim*5, dim*3, BORD_UD,  EMPTY);
  lab[3][6] = new Cell (dim*6, dim*3, BORD_R,   EMPTY);
  lab[3][7] = new Cell (dim*7, dim*3, NO_PASS,  WALL);
  lab[3][8] = new Cell (dim*8, dim*3, NO_PASS,  WALL);
  
  lab[4][0] = new Cell (0, dim*4,     ANG_TL,   EMPTY);
  lab[4][1] = new Cell (dim*1, dim*4, BORD_UD,  EMPTY);
  lab[4][2] = new Cell (dim*2, dim*4, BORD_R,   EMPTY);
  lab[4][3] = new Cell (dim*3, dim*4, SPAWN_MONSTERS,  SPAWN_CELL);
  lab[4][4] = new Cell (dim*4, dim*4, SPAWN_MONSTERS,  SPAWN_CELL);
  lab[4][5] = new Cell (dim*5, dim*4, SPAWN_MONSTERS,  SPAWN_CELL);
  lab[4][6] = new Cell (dim*6, dim*4, BORD_L,   EMPTY);
  lab[4][7] = new Cell (dim*7, dim*4, BORD_UD,  EMPTY);
  lab[4][8] = new Cell (dim*8, dim*4, ANG_TR,   EMPTY);
  
  lab[5][0] = new Cell (0, dim*5,     BORD_LR,  EMPTY);
  lab[5][1] = new Cell (dim*1, dim*5, NO_PASS,  WALL);
  lab[5][2] = new Cell (dim*2, dim*5, BORD_L,   EMPTY);
  lab[5][3] = new Cell (dim*3, dim*5, BORD_UD,  EMPTY);
  lab[5][4] = new Cell (dim*4, dim*5, BORD_U,   EMPTY);
  lab[5][5] = new Cell (dim*5, dim*5, BORD_UD,  EMPTY);
  lab[5][6] = new Cell (dim*6, dim*5, BORD_R,   EMPTY);
  lab[5][7] = new Cell (dim*7, dim*5, NO_PASS,  WALL);
  lab[5][8] = new Cell (dim*8, dim*5, BORD_LR,  EMPTY);
 
  lab[6][0] = new Cell (0, dim*6,     BORD_L,   EMPTY);
  lab[6][1] = new Cell (dim*1, dim*6, BORD_UD,  EMPTY);
  lab[6][2] = new Cell (dim*2, dim*6, BORD_R,   EMPTY);
  lab[6][3] = new Cell (dim*3, dim*6, NO_PASS,  WALL);
  lab[6][4] = new Cell (dim*4, dim*6, BORD_LR,  EMPTY);
  lab[6][5] = new Cell (dim*5, dim*6, NO_PASS,  WALL);
  lab[6][6] = new Cell (dim*6, dim*6, BORD_L,   EMPTY);
  lab[6][7] = new Cell (dim*7, dim*6, BORD_UD,  EMPTY);
  lab[6][8] = new Cell (dim*8, dim*6, BORD_R,   EMPTY);

  lab[7][0] = new Cell (0, dim*7,     BORD_LR,  EMPTY);
  lab[7][1] = new Cell (dim*1, dim*7, NO_PASS,  WALL);
  lab[7][2] = new Cell (dim*2, dim*7, BORD_L,   EMPTY);
  lab[7][3] = new Cell (dim*3, dim*7, BORD_UD,  EMPTY);
  lab[7][4] = new Cell (dim*4, dim*7, BORD_D,   EMPTY);
  lab[7][5] = new Cell (dim*5, dim*7, BORD_UD,  EMPTY);
  lab[7][6] = new Cell (dim*6, dim*7, BORD_R,   EMPTY);
  lab[7][7] = new Cell (dim*7, dim*7, NO_PASS,  WALL);
  lab[7][8] = new Cell (dim*8, dim*7, BORD_LR,  EMPTY);
  
  lab[8][0] = new Cell (0, dim*8,     ANG_BL,   EMPTY);
  lab[8][1] = new Cell (dim*1, dim*8, BORD_UD,  EMPTY);
  lab[8][2] = new Cell (dim*2, dim*8, ANG_BR,   EMPTY);
  lab[8][3] = new Cell (dim*3, dim*8, NO_PASS,  WALL);
  lab[8][4] = new Cell (dim*4, dim*8, NO_PASS,  WALL);
  lab[8][5] = new Cell (dim*5, dim*8, NO_PASS,  WALL);
  lab[8][6] = new Cell (dim*6, dim*8, ANG_BL,   EMPTY);
  lab[8][7] = new Cell (dim*7, dim*8, BORD_UD,  EMPTY);
  lab[8][8] = new Cell (dim*8, dim*8, ANG_BR,   EMPTY);
  
  translate(-dim/2, -dim/2);
  
  }

void disegna_lab (){
  int i, j;
  Cell cella;

  
 // text("lab[8][8] " + lab[8][8].type, 120, 30);
  
  for(i=0; i<MAX_ROWS; i++){
    for(j=0; j<MAX_COLS; j++){
      cella=lab[i][j];
     
      ellipseMode(CENTER);
      ellipse(cella.x, cella.y, 3, 3);
      
      // text(cella.type, cella.x, cella.y);
        
      
      //disegno riempimenti cella
      noStroke();
   
      switch(cella.fill){
        case EMPTY:
          fill(167,255,169);
          rect(cella.x-dim/2, cella.y-dim/2, dim, dim);
          break;
        case WALL:
          fill(178,178,178);
          rect(cella.x-dim/2, cella.y-dim/2, dim, dim);
          break;
        case SPAWN_CELL:
          fill(255,101,204);
          rect(cella.x-dim/2, cella.y-dim/2, dim, dim);
          break;
        case PASSED:
          fill(71,255,75);
          rect(cella.x-dim/2, cella.y-dim/2, dim, dim);
          break;
        case FRUIT_CELL:
          fruit_red=int(random(0,255));
          fruit_green=int(random(0,255));
          fruit_blue=int(random(0,255));
          fill(fruit_red,fruit_green,fruit_blue);
          rect(cella.x-dim/2, cella.y-dim/2, dim, dim);
          break; 
        }
      
      stroke(65,65,65);
      strokeWeight(3);
      
      //disegno bordi cella
      switch(cella.type) {
         case ANG_TL:      
         
          // text("cella.x " + cella.x + "cella.y " + cella.y + "cella.type " + cella.type, 80, 30);
          
           line(cella.x-dim/2, cella.y-dim/2, cella.x-dim/2, cella.y+dim/2);
           line(cella.x-dim/2, cella.y-dim/2, cella.x+dim/2, cella.y-dim/2);
           break;
         case ANG_BL:
           line(cella.x-dim/2, cella.y-dim/2, cella.x-dim/2, cella.y+dim/2);
           line(cella.x-dim/2, cella.y+dim/2, cella.x+dim/2, cella.y+dim/2);
           break;
         case ANG_TR:
           line(cella.x+dim/2, cella.y-dim/2, cella.x+dim/2, cella.y+dim/2);
           line(cella.x-dim/2, cella.y-dim/2, cella.x+dim/2, cella.y-dim/2);
           break;
         case ANG_BR:
           line(cella.x+dim/2, cella.y-dim/2, cella.x+dim/2, cella.y+dim/2);
           line(cella.x-dim/2, cella.y+dim/2, cella.x+dim/2, cella.y+dim/2);
           break;
         
         case BORD_L:
           line(cella.x-dim/2, cella.y-dim/2, cella.x-dim/2, cella.y+dim/2);
           break;
         case BORD_R:
           line(cella.x+dim/2, cella.y-dim/2, cella.x+dim/2, cella.y+dim/2);
           break;
         case BORD_U:
           line(cella.x-dim/2, cella.y-dim/2, cella.x+dim/2, cella.y-dim/2);
           break;
         case BORD_D:
           line(cella.x-dim/2, cella.y+dim/2, cella.x+dim/2, cella.y+dim/2);
           break;
           
         case BORD_LR:
           line(cella.x-dim/2, cella.y-dim/2, cella.x-dim/2, cella.y+dim/2);
           line(cella.x+dim/2, cella.y-dim/2, cella.x+dim/2, cella.y+dim/2);
           break;
           
         case BORD_UD:
           line(cella.x-dim/2, cella.y-dim/2, cella.x+dim/2, cella.y-dim/2);
           line(cella.x-dim/2, cella.y+dim/2, cella.x+dim/2, cella.y+dim/2);
           break;
         
        case NO_PASS:
           // non disegna alcun bordo
           break;
          
        }
      strokeWeight(1);
      stroke(0);
      }
    }
    
   
  }

int check(int x_p_corr, int y_p_corr, int x_m_corr, int y_m_corr){

  int i, j, collision=0;
  Cell cella;
  
  
//Pacman and Monster collision
  
  // devo verificare sia la collisione lungo asse x
  for(i=Pac.x-Pac.dim/2 ; i<=Pac.x+Pac.dim/2 ; i++)
    for(j=Mon.x-Mon.dim/2 ; j<=Mon.x+Mon.dim/2 ; j++)
      if(i==j) collision=1;
  // che lungo asse y
  for(i=Pac.y-Pac.dim/2 ; i<=Pac.y+Pac.dim/2 ; i++)
    for(j=Mon.y-Mon.dim/2 ; j<=Mon.y+Mon.dim/2 ; j++)
      if(i==j && collision==1) collision=2;
  //quando sono sicuro della collisione verifico se Pacman mangia (killer vale 1) o può essere mangiato (killer vale 0)
  if( collision == 2 ){
    println("BOOOOOOOOOOOOOOOOOM");
    if(killer==1){
      Mon.move=MOV_UP;
      return GAME_EAT_MONSTER;
      }
    else{
      Pac.move=MOV_DX;        
      Pac.stop=1;             
      Mon.move=MOV_UP;
      return GAME_LOSE_LIFE;    
      }
    }
    
// Controllo su ogni Cella e controlli su chi la attraversa (se Pacman o Monster)
  for(i=0; i<MAX_ROWS; i++){
    for(j=0; j<MAX_COLS; j++){
      
      cella=lab[i][j];
      
      //Quando le coordinate del centro di Pacman sono uguali alle coordinate del centro della cella...
      if(cella.x == x_p_corr && cella.y == y_p_corr){
          
          text("Pacman è in: " + i+ ", " + j, 10, 60);
          text("X: " + x_p_corr+ " Y: " + y_p_corr, 10, 80);
          
          
          // cambio colore casuale di Pacman          
          if(cella.fill==FRUIT_CELL){
            Pac.fill_r=fruit_red;
            Pac.fill_g=fruit_green;
            Pac.fill_b=fruit_blue;
            }
            
            
          //...imposta eventuali valori di Pac.stop (blocco il movimento di Pacman per non farlo andare oltre ai "muri" a seconda del tipo di cella in cui mi trovo
          controllo_movimento(cella.type);  
          
          
            
          
          // contrassegno e coloro la cella come conquistata
          cella.fill=PASSED;
        }  
        
      //Quando le coordinate del centro di Monster sono uguali alle coordinate del centro della cella...
      if(cella.x == x_m_corr && cella.y == y_m_corr){
          
          text("Mostro è in: " + i+ ", " + j, 10, 20);
          text("X: " + x_m_corr+ " Y: " + y_m_corr, 10, 40);
          
          int mov_temp;
          
          // ... verifico in quale cella mi trovo: se sono in una di queste celle BORD_U, BORD_D, ...
          // ... cambio la direzione in maniera casuale oppure vario il movimento in direzione di Pacman
          if(cella.type==BORD_U || cella.type==BORD_D || cella.type==BORD_L || cella.type==BORD_R || cella.type==ANG_TL || cella.type==ANG_TR || cella.type==ANG_BL || cella.type==ANG_BR){
            
            
            //Se Pacman non è killer, il Monster deve andare verso Pacman (in maniera più o meno casuale)
            if(killer==0){
              
              // genero un numero casuale che indica la difficoltà, chiamato diff: se vale 1, 2 o 3, il Monster si muove verso Pacman, se vale 0 si muove in maniera casuale (in una direzione diversa dalla precedente)
              int diff=int(random(0,4)); //genera un numero da 0 a 3, generando meno numeri ed inserendo meno condizioni, abbasso la difficoltà (in questo caso è difficoltà possiamo dire che è 3 su 4)
              
              if(diff==1 || diff == 2 || diff == 3){   
                // mi muovo verso Pacman, ma in quale direzione? Lungo x o y? Lo scelgo casualmente con rand_xy
                int rand_xy=int(random(0,2));
                
                if( rand_xy == 1 ){ // mi muovo lungo l'asse x
                  if ( x_m_corr <= x_p_corr )
                    mov_temp=MOV_DX;
                  else mov_temp=MOV_SX;
                  }
                else{
                  if ( y_m_corr <= y_p_corr ) // mi muovo lungo l'asse y
                    mov_temp=MOV_DW;
                  else mov_temp=MOV_UP;
                  }
                }
              // altrimenti, se diff=0, voglio che il movimento succesivo sia generato in maniera casuale, non influenzato dalla posizione di Pacman ...
              else{                                         
                do {mov_temp=int(random(1,5));}   // ... genero un numero casuale di direzione (da 1 a 4, vedi come sono definite MOV_SX e MOV_DW)
                while(mov_temp == Mon.move);            // finchè non ne trovo uno diverso dalla direzione precedente (memorizzata nella variabile Mon.move)
                }
            
            }
            
            //Se Pacman invece è killer, il Monster deve scappare da Pacman (in maniera più o meno casuale)
            else{
              int rand_xy=int(random(0,4)); // più aumento e più aumenta la facilità nel mangiare il Monster
              
              println("----->" + rand_xy);
              
              if( rand_xy == 1 ){ // scappa lungo l'asse x
                if ( x_m_corr <= x_p_corr )
                  mov_temp=MOV_SX;
                else mov_temp=MOV_DX;
                }
              else if( rand_xy == 2 ){
                if ( y_m_corr <= y_p_corr ) // scappa lungo l'asse y
                  mov_temp=MOV_UP;
                else mov_temp=MOV_DW;
                }
              else{
                do {mov_temp=int(random(1,5));}   
                while(mov_temp == Mon.move);       
                }
              }
            
            println(" KILLER__ " + killer + " MOVE_MONST_ " + Mon.move);

            
            Mon.move=mov_temp;                        //sono sicuro che i due valori sono diversi ed aggiorno la variabile che indica la direzione del Monster
            
          }
          
          // imposta eventuali valori di Mon.stop (blocco il movimento del Monster per non farlo andare oltre ai "muri" a seconda del tipo di cella in cui mi trovo
          controllo_movimento_monster(cella.type);  
          
        }
      
      }
    }
  return GAME_OK;
  }
  
void controllo_movimento(int cell_type){
  if (key_pressed == RIGHT) {
     
         //controllo direzioni out ammissibili della cella
         switch(cell_type) {
          
          case BORD_L: 
            Pac.move=MOV_DX;
            Pac.stop=0;
            break;
          case BORD_R: 
            Pac.stop=1;
            break;
          case BORD_U: 
            Pac.move=MOV_DX;
            Pac.stop=0;
            break;
          case BORD_D: 
            Pac.move=MOV_DX;
            Pac.stop=0;
            break;
            
          case ANG_TL: 
            Pac.move=MOV_DX;
            Pac.stop=0;
            break;
          case ANG_TR: 
            Pac.stop=1;
            break;          
          case ANG_BL: 
            Pac.move=MOV_DX;
            Pac.stop=0;
            break;
          case ANG_BR: 
            Pac.stop=1;
            break;
         
          case BORD_UD:
            Pac.move=MOV_DX;
            Pac.stop=0;
            break;
          case BORD_LR:
            Pac.stop=1;
            break;
            
          case FREE:             
            Pac.move=MOV_DX;
            break;
        }
      }
    if (key_pressed == LEFT) {
        //controllo direzioni out ammissibili della cella
         switch(cell_type) {
           
          case BORD_L: 
            Pac.stop=1;
            break;
          case BORD_R: 
            Pac.move=MOV_SX;
            Pac.stop=0;
            break;
          case BORD_U: 
            Pac.move=MOV_SX;
            Pac.stop=0;
            break;
          case BORD_D: 
            Pac.move=MOV_SX;
            Pac.stop=0;
            break;
            
           case ANG_TL: 
            Pac.stop=1;
            break;
           case ANG_TR: 
            Pac.move=MOV_SX;
            Pac.stop=0;
            break;     
           case ANG_BL: 
            Pac.stop=1;
            break;
          case ANG_BR:  
            Pac.move=MOV_SX;
            Pac.stop=0;
            break;
          
          case BORD_UD:
            Pac.move=MOV_SX;
            Pac.stop=0;
            break;
          case BORD_LR:
            Pac.stop=1;
            break;
            
          case FREE:             
            Pac.move=MOV_SX; // muovi a sinistra
            break;
        }
      } 
    if (key_pressed == UP) {
        //controllo direzioni out ammissibili della cella
         switch(cell_type) {
           
          case BORD_L: 
            Pac.move=MOV_UP;
            Pac.stop=0;
            break;
          case BORD_R: 
            Pac.move=MOV_UP;
            Pac.stop=0;
            break;
          case BORD_U: 
            Pac.stop=1;
            break;
          case BORD_D: 
            Pac.move=MOV_UP;
            Pac.stop=0;
            break;
           
           case ANG_TL: 
            Pac.stop=1;
            break;
           case ANG_TR: 
            Pac.stop=1;
            break;
           case ANG_BL:
            Pac.move=MOV_UP;
            Pac.stop=0;
            break;
          case ANG_BR:
            Pac.move=MOV_UP;
            Pac.stop=0;
            break;
            
          case BORD_UD:
            Pac.stop=1;
            break;
          case BORD_LR:
            Pac.move=MOV_UP;
            Pac.stop=0;
            break;
            
          case FREE:             
            Pac.move=MOV_UP; // muovi su
            break;
        }
       }
    if (key_pressed == DOWN) {
        //controllo direzioni out ammissibili della cella
         switch(cell_type) {
           
          case BORD_L: 
            Pac.move=MOV_DW;
            Pac.stop=0;
            break;
          case BORD_R: 
            Pac.move=MOV_DW;
            Pac.stop=0;
            break;
          case BORD_U: 
            Pac.move=MOV_DW;
            Pac.stop=0;
            break;
          case BORD_D:
            Pac.stop=1;
            break;
           
           case ANG_TL: 
            Pac.move=MOV_DW;
            Pac.stop=0;
            break;
           case ANG_TR: 
            Pac.move=MOV_DW;
            Pac.stop=0;
            break;
           case ANG_BL:
            Pac.stop=1;
            break;
          case ANG_BR:
            Pac.stop=1;
            break;
          
          case BORD_UD:
            Pac.stop=1;
            break;
          case BORD_LR:
            Pac.move=MOV_DW;
            Pac.stop=0;
            break;
          
          case FREE:             
            Pac.move=MOV_DW;
            break;
        }
      }
  }

void controllo_movimento_monster(int cell_type){
  if (Mon.move==MOV_DX) {
     
         //controllo direzioni out ammissibili della cella
         switch(cell_type) {
          
          case BORD_L: 
            Mon.move=MOV_DX;
            Mon.stop=0;
            break;
          case BORD_R: 
            Mon.stop=1; //genera random movimento
            break;
          case BORD_U: 
            Mon.move=MOV_DX;
            Mon.stop=0;
            break;
          case BORD_D: 
            Mon.move=MOV_DX;
            Mon.stop=0;
            break;
            
          case ANG_TL: 
            Mon.move=MOV_DX;
            Mon.stop=0;
            break;
          case ANG_TR: 
            Mon.stop=1; //genera random movimento
            break;          
          case ANG_BL: 
            Mon.move=MOV_DX;
            Mon.stop=0;
            break;
          case ANG_BR: 
            Mon.stop=1; //genera random movimento
            break;
         
          case BORD_UD:
            Mon.move=MOV_DX;
            Mon.stop=0;
            break;
          case BORD_LR:
            Mon.stop=1; //genera random movimento
            break;
            
          case FREE:             
            Mon.move=MOV_DX;
            break;
        }
      }
    if (Mon.move==MOV_SX) {
        //controllo direzioni out ammissibili della cella
         switch(cell_type) {
           
          case BORD_L: 
            Mon.stop=1; //genera random movimento
            break;
          case BORD_R: 
            Mon.move=MOV_SX;
            Mon.stop=0;
            break;
          case BORD_U: 
            Mon.move=MOV_SX;
            Mon.stop=0;
            break;
          case BORD_D: 
            Mon.move=MOV_SX;
            Mon.stop=0;
            break;
            
           case ANG_TL: 
            Mon.stop=1; //genera random movimento
            break;
           case ANG_TR: 
            Mon.move=MOV_SX;
            Mon.stop=0;
            break;     
           case ANG_BL: 
            Mon.stop=1; //genera random movimento
            break;
          case ANG_BR:  
            Mon.move=MOV_SX;
            Mon.stop=0;
            break;
          
          case BORD_UD:
            Mon.move=MOV_SX;
            Mon.stop=0;
            break;
          case BORD_LR:
            Mon.stop=1; //genera random movimento
            break;
            
          case FREE:             
            Mon.move=MOV_SX; // muovi a sinistra
            break;
        }
      } 
    if (Mon.move==MOV_UP) {
        //controllo direzioni out ammissibili della cella
         switch(cell_type) {
           
          case BORD_L: 
            Mon.move=MOV_UP;
            Mon.stop=0;
            break;
          case BORD_R: 
            Mon.move=MOV_UP;
            Mon.stop=0;
            break;
          case BORD_U: 
            Mon.stop=1; //genera random movimento
            break;
          case BORD_D: 
            Mon.move=MOV_UP;
            Mon.stop=0;
            break;
           
           case ANG_TL: 
            Mon.stop=1; //genera random movimento
            break;
           case ANG_TR: 
            Mon.stop=1; //genera random movimento
            break;
           case ANG_BL:
            Mon.move=MOV_UP;
            Mon.stop=0;
            break;
          case ANG_BR:
            Mon.move=MOV_UP;
            Mon.stop=0;
            break;
            
          case BORD_UD:
            Mon.stop=1; //genera random movimento
            break;
          case BORD_LR:
            Mon.move=MOV_UP;
            Mon.stop=0;
            break;
            
          case FREE:             
            Mon.move=MOV_UP; // muovi su
            break;
        }
       }
    if (Mon.move==MOV_DW) {
      
         switch(cell_type) {
           
          case BORD_L: 
            Mon.move=MOV_DW;
            Mon.stop=0;
            break;
          case BORD_R: 
            Mon.move=MOV_DW;
            Mon.stop=0;
            break;
          case BORD_U: 
            Mon.move=MOV_DW;
            Mon.stop=0;
            break;
          case BORD_D:
            Mon.stop=1; //genera random movimento
            break;
           
           case ANG_TL: 
            Mon.move=MOV_DW;
            Mon.stop=0;
            break;
           case ANG_TR: 
            Mon.move=MOV_DW;
            Mon.stop=0;
            break;
           case ANG_BL:
            Mon.stop=1; //genera random movimento
            break;
          case ANG_BR:
            Mon.stop=1; //genera random movimento
            break;
          
          case BORD_UD:
            Mon.stop=1; //genera random movimento
            break;
          case BORD_LR:
            Mon.move=MOV_DW;
            Mon.stop=0;
            break;
          
          case FREE:             
            Mon.move=MOV_DW;
            break;
        }
      }
  }
