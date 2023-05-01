import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

Minim minim;
AudioPlayer[] mainplayer;
int indice;

PImage spriteSheet;
PImage[] perso= new PImage[4*4];
int colonne=0;
int ligne=0;
int coordX_perso=0;
int coordY_perso=0;
PImage bg;
PImage bg_layer;
int y;  
int ca;
static final int FADE = 2500;
void setup() {
  size(600, 600 );
  bg = loadImage("ultimeroute.png");
  bg_layer= loadImage("ultimelayer.png");
  spriteSheet = loadImage("marche.png");
  for (int colonne = 0; colonne < 4; colonne++) {
    for (int ligne = 0; ligne < 4; ligne++) {
      text(str(colonne+ligne*4), colonne*32+16, ligne*48+17);
      perso[colonne+ligne*4] = spriteSheet.get(colonne*32, ligne*48, 32, 48);
    }
  }
  imageMode(CENTER);
  coordX_perso= width/2;
  coordY_perso= height/2;
  
     minim = new Minim(this);
     mainplayer= new AudioPlayer[2];
     mainplayer[0] = minim.loadFile("bush.mp3");
     mainplayer[1] = minim.loadFile("Route.mp3");
     indice=1;
     mainplayer[indice].play();
     mainplayer[indice].loop();
}

void draw() {
  stroke(226, 204, 0);
  line(0, y, width, y);
  y++;
  if (y > height) {
    y = 0;
  }
  int posx=floor(coordX_perso*bg_layer.width/600);
  int posy=floor(coordY_perso*bg_layer.height/600);
  ca = bg_layer.get(posx, posy);
  

  image(bg, width/2, height/2, 600, 600);
  fill(ca);
  //println(hex(ca));
  noStroke();
  rect(25, 25, 50, 50);
  image(perso[colonne+ligne*4], coordX_perso, coordY_perso);
}

void deplacer() {
  if (frameCount%3==0) {
    colonne++;
    if (colonne > 3) {
      colonne=0;
    }
  }
}

void agir(int dx, int dy) {
 int xprevu = coordX_perso + dx;
 int yprevu = coordY_perso + dy;
 int posx2=floor(xprevu*bg_layer.width/600);
 int posy2=floor(yprevu*bg_layer.height/600);
 color c = bg_layer.get(posx2, posy2);
 if (ca==c) {
   coordX_perso=xprevu;
   coordY_perso=yprevu;
   deplacer();
 }
 else
 {
     if(c==unhex("FFFF0000")) { // buissons
       indice=0;
       mainplayer[indice].play();
       mainplayer[indice].loop();
       mainplayer[indice].shiftGain(mainplayer[indice].getGain(),2500,FADE);
       
       coordX_perso=xprevu;
       coordY_perso=yprevu;
       deplacer();
     }
       

     if (c==unhex("FFFFFFFF")) { // sol
       indice=0;
       mainplayer[indice].pause();
       
       coordX_perso=xprevu;
       coordY_perso=yprevu;
       deplacer();
     }
       
      if (c==unhex("FF000000")) { // mur
       indice=0;
       mainplayer[indice].pause();
   }
 }
   
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      ligne=3;
      agir(0,-4);
    } else if (keyCode == DOWN) {
      ligne=0;
      agir(0,4);
    } else if (keyCode == LEFT) {
      ligne=1;
      agir(-4,0);
    } else if (keyCode == RIGHT) {
      ligne=2;
      agir(4,0);
    }
  }
}
