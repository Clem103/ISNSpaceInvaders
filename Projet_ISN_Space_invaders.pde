import processing.sound.*;
SoundFile explode;
// taille des Objets
int tVaisseau = 30;
int tEnnemis = 30;
//vitesse ennemis +vaisseau
int eSpeed = 2;
int vSpeed = 2;
// coordonnée vaisseau
int xVaisseau;
int yVaisseau;
int xs1,ys1,xs2,ys2,xs3,ys3;
// position enemies
ArrayList<Integer> xE = new ArrayList();
ArrayList<Integer> yE = new ArrayList();
// touche du jeu
boolean up=   false;
boolean down= false;
boolean left= false;
boolean right=false;
boolean z=    false;
boolean q=    false;
boolean s=    false;
boolean d=    false;
// mode de jeu
int screen ;
// aire triangle
double aireT;
//
PFont f;
PImage fondAccueil,fondJeu,asteroid;
 
void setup(){
  size(800,600);
  f = createFont("TestPolice.otf",1);
  smooth();
  xVaisseau =  width/2;
  yVaisseau = height/2;
  frameRate(180);
  screen = 0;
  aireT = triangleA(xVaisseau, yVaisseau,xVaisseau+tVaisseau, (yVaisseau-tVaisseau/2), xVaisseau+tVaisseau, (yVaisseau+tVaisseau/2));
  explode = new SoundFile(this, "8BitExplosion.mp3"); //Variable qui correspond à un fichier son placé dans /data du dossier projet
  fondAccueil = loadImage("wallpaper-1c6ef.jpg");
  fondJeu = loadImage("pixel-wallpapers14.png");
  asteroid = loadImage("asteroid.jpg");
}
 
void draw(){
  if(screen == 0)
   ecranAcceuil();
  else if (screen == 1){
    background(fondJeu);
    noCursor();
   
    if((int)random(0,30)==0)
    ajouterEnnemis();
    bougerEnnemi();
    bougerVaisseau();
    collision();
    affichage();
  }
}
void mousePressed(){
if (screen == 0 && mouseX<(width)/2+100 && mouseX>(width)/2-100 && mouseY<(height/2)+40 && mouseY>(height/2)-40) screen=1;
}

void ecranAcceuil(){
  
  background(fondAccueil);
  noFill();
  stroke(0,0,0);
  rectMode(CENTER);
  if(mouseX<(width)/2+100 && mouseX>(width)/2-100 && mouseY<(height/2)+40 && mouseY>(height/2)-40){
   fill(255,50); 
  }
  rect(width/2,height/2,200,80); 
  textFont(f,75);
  textAlign(CENTER);
  fill(255,0,0);
  text("ASTROBREAKER",width/2,height/5);
  textFont(f,30);
  text("PLAY/JOUER",width/2,height/2+10); 
}
void ajouterEnnemis(){
  xE.add(tEnnemis);
  yE.add((int)(Math.random()*(height-tEnnemis)));  
}

 void bougerEnnemi(){
  for(int i=0;i<xE.size();i++){
    xE.set(i,xE.get(i)+1);
  }
}

void bougerVaisseau(){
  if((z||up) && (ys2>0))        yVaisseau=yVaisseau-vSpeed;
  if((s||down) && (ys3<height)) yVaisseau=yVaisseau+vSpeed;
  if((q||left) && (xs1>0))      xVaisseau=xVaisseau-vSpeed;
  if((d||right) && (xs2<width)) xVaisseau=xVaisseau+vSpeed;
    
    // nouveau sommet triangle
  xs1=xVaisseau;
  ys1=yVaisseau;
  xs2=xVaisseau+tVaisseau;
  ys2=yVaisseau-tVaisseau/2;
  xs3=xVaisseau+tVaisseau;
  ys3=yVaisseau+tVaisseau/2;
}

void keyPressed(){
  switch(keyCode){
    case UP: up =        true; break;
    case DOWN : down =   true; break;
    case LEFT : left =   true; break;
    case RIGHT : right = true; break;
    case 90: z=          true; break;//z
    case 81: q=          true; break;//q
    case 83: s=          true; break;//s
    case 68: d=          true; break;//d
   
  }
}
void keyReleased(){
   switch(keyCode){
    case UP: up =        false; break;
    case DOWN : down =   false; break;
    case LEFT : left =   false; break;
    case RIGHT : right = false; break;
    case 90: z=          false; break;//z
    case 81: q=          false; break;//q
    case 83: s=          false; break;//s
    case 68: d=          false; break;//d
  }  
}

void Sound(){ //Fonction appelée lors de chaque colision qui produit un son
    explode.amp(0.05);
    explode.play();
}

void collision(){
  float x,y,r;
  r=tEnnemis/2;
 
  for (int i=0 ; i<xE.size();i++)
  {
    x=xE.get(i);y=yE.get(i);
    if(x-tEnnemis>width){
      xE.remove(i);
      yE.remove(i);
    }    
    
    else if((y+r > yVaisseau-tVaisseau/2 && y-tEnnemis/2< yVaisseau+tVaisseau/2 )&&( x+tEnnemis/2>xVaisseau && x-tEnnemis/2<xVaisseau+tVaisseau)){ 
      if (colision(x,y,r))
      {
        xE.remove(i);
        yE.remove(i);
        Sound();
      }  
    }    
  }
}
 
float triangleA(int px1, int py1 , int px2 ,int py2 ,int px3 , int py3){ // calcule l'aire d'un triangle
 
  float A , longA,longB,longC ,longD;
  // A = 1/2||AB vectoriel AC||
  longA=px1-px3;
  longB=py1-py3;
  longC=px2-px3;
  longD= py2-py3;
 
  A=0.5* abs((longA*longD)-(longB*longC));
  return A;
}
   
boolean colision(float x,float y ,float r){
  int xC,yC,xG,yG; // point sur le cerlcle de du vecteur centre gravité triangle centre cercle
  float longux,longuy,angle ,A1,A2,A3,AT;
  // centre de gravité du triangle
  xG = (xs1+xs2+xs3)/3;
  yG = (ys1+ys2+ys3)/3;    
  longux = xG-x;
  longuy = yG-y;
  angle  = atan2(longuy,longux);  
  //calcul du potentiel point de colision
  xC= int(x+cos(angle)*r);
  yC =int(y+sin(angle)*r);
  // calcule des 3 aires créées par le point potentiel de collision
  A1=triangleA(xC,yC,xs1,ys1,xs2,ys2);
  A2=triangleA(xC,yC,xs2,ys2,xs3,ys3);
  A3=triangleA(xC,yC,xs1,ys1,xs3,ys3);
   
  AT= A1+A2+A3;
  // la somme des 3 aire est egal alors le point est dans le triangle
  
  if (aireT==AT)                  return true;   
  else if(colC(xs1 ,ys1 , x,y,r)) return true;  
  else if(colC(xs2 ,ys2 , x,y,r)) return true;
  else if(colC(xs3 ,ys3 , x,y,r)) return true; 
  
  return false;
}
 
boolean colC(float xs,float ys,float xc,float yc,float r){// collision avec cercle et point sommet du triangle
  return (xs-xc)*(xs-xc)+(ys-yc)*(ys-yc)<= r*r;
 
}
 
void affichage(){
  int x,y;
 
  for(int i = 0;i<xE.size();i++){ // affiche chaque ennemi
    x = xE.get(i); y = yE.get(i);
    fill(255);
    stroke(0);
    ellipse(x,y,tEnnemis,tEnnemis);
  }
  fill(255,0,0);
  stroke(255,0,0);
  triangle(xs1, ys1,xs2 ,ys2, xs3, ys3); // affiche triangle

}