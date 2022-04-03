class Land{
  /*
* Returns a Land object.
* Prepares land shadow, wireframe and textured shape
* @param  map  Land associated elevation Map3D object
* @return Land object    
*/

PShape shadow;
PShape wireFrame;
PShape satellite;
Map3D map;

Land(Map3D map,String fileName,ArrayList<Map3D.ObjectPoint> ParkingPoint,ArrayList<Map3D.ObjectPoint> PicNicTbalePoint) {   
  
  //Déclaration et utilisation des variables.
  final float tileSize = 25.0f;     
  this.map = map;     
  float w = (float)Map3D.width;     
  float h = (float)Map3D.height; 
  

  // South West (direct)
  Map3D.ObjectPoint osw = this.map.new ObjectPoint(-w/2.0f, +h/2.0f);
  // North East (direct)
  Map3D.ObjectPoint one = this.map.new ObjectPoint(+w/2.0f, -h/2.0f);
  // North East (direct)
  Map3D.ObjectPoint ose = this.map.new ObjectPoint(+w/2.0f, +h/2.0f);
  // North East (direct)
  Map3D.ObjectPoint onw = this.map.new ObjectPoint(-w/2.0f, -h/2.0f);
  
  // Préparation de la PShape shadow.    
  this.shadow = createShape();     
  this.shadow.beginShape(QUADS);     
  this.shadow.fill(0x992F2F2F);     
  this.shadow.noStroke();     
  
  //Création et affectation des 4 points du rectangle ombre pour le dessin du rectancle Shadow avec une élévation Z = -20.
  this.shadow.vertex(osw.x,osw.y,-20);
  this.shadow.vertex(ose.x,ose.y,-20);
  this.shadow.vertex(one.x,one.y,-20);
  this.shadow.vertex(onw.x,onw.y,-20);
  this.shadow.endShape();     
  
  // Préparation de la PShape Wireframe      
  this.wireFrame = createShape();     
  this.wireFrame.beginShape(QUADS);     
  this.wireFrame.noFill();     
  this.wireFrame.stroke(#888888);     
  this.wireFrame.strokeWeight(0.5f);  
  
  /*Création des 4 points du terrain en prenant la coordonnée d'élevation de l'objet MAP3D passé en paramétre au constructeur à chaque tour de boucle.
  *L'attribution de chaque point de la shape Wirefram (du terrain) à la variable heat pour utilisé leurs interpollation dans les shaders.
  */
  
 for(int i = 0; i<5000; i+=25){
   for(int j= 0; j<3000; j+=25){
     
     //Création et affectation du premier point (gauche) du petit carrée.
      Map3D.ObjectPoint op = this.map.new ObjectPoint(onw.x+i,onw.y+j);
      this.wireFrame.vertex(op.x, op.y, op.z);
      
      //L'attribution du premier point à la variable heat aprés calcule de la distance minimale entre ce dérniers et les positions des tables de picnic et celles des parking à velo.
      this.wireFrame.attrib("heat", calculerDistanceMin(op,ParkingPoint), calculerDistanceMin(op,PicNicTbalePoint)); 
      
      //Création et affectation du deuxiéme point (droite) du petit carrée.
      op = this.map.new ObjectPoint(onw.x+i+25,onw.y+j);
      this.wireFrame.vertex(op.x, op.y, op.z);
      
      //L'attribution du deuxiéme point à la variable heat aprés calcule de la distance minimale entrece dérniers et les positions des table de picnic et celles des parking à velo.
      this.wireFrame.attrib("heat", calculerDistanceMin(op,ParkingPoint), calculerDistanceMin(op,PicNicTbalePoint)); 
      
      //Création et affectation du troisiéme point (en bas à droite) du petit carrée.
      op = this.map.new ObjectPoint(onw.x+i+25,onw.y+j+25);
      this.wireFrame.vertex(op.x, op.y, op.z);
      
      //L'attribution du troisiéme point à la variable heat aprés calcule de la distance minimale entre ce dérniers et les positions des table de picnic et celles des parking à velo.
      this.wireFrame.attrib("heat", calculerDistanceMin(op,ParkingPoint), calculerDistanceMin(op,PicNicTbalePoint));
      
      //Création et affectation du troisiéme point (en bas à gauche) du petit carrée.
      op = this.map.new ObjectPoint(onw.x+i,onw.y+j+25);
      this.wireFrame.vertex(op.x, op.y, op.z);
      
      //L'attribution du quatriéme point à la variable heat aprés calcule de la distance minimale entre ce dérniers et les positions des table de picnic et celles des parking à velo.
      this.wireFrame.attrib("heat", calculerDistanceMin(op,ParkingPoint), calculerDistanceMin(op,PicNicTbalePoint)); 

   }
 }
  this.wireFrame.endShape(); 
  

  
  //Teste de l'image avant de la charger 
  File ressource = dataFile(fileName);
  if (!ressource.exists() || ressource.isDirectory()) {
     println("ERROR: Land texture file " + fileName + " not found.");
     exitActual(); 
   } 
   
   //Chargement de l'image
  PImage uvmap = loadImage(fileName); 
  //Création et Préparation de la PShape satellite.
  this.satellite = createShape();     
  this.satellite.beginShape(QUADS); 
  this.satellite.noStroke();
  this.satellite.texture(uvmap);
  this.satellite.emissive(0xD0);  
  //Initialisation des deux paramétre U,V
  int u = 0;
  int v = 0;  
  //Création des 4 points pour prendre un bout de l'image en prenant la coordonnée d'élevation de l'objet MAP3D passé en paramétre au constructeur à chaque tour de boucle avec normalisation de chaque point.
  for(int i = 0; i<5000; i+=25){
   for(int j= 0; j<3000; j+=25){     
      Map3D.ObjectPoint op = this.map.new ObjectPoint(onw.x+i,onw.y+j);
      PVector n = op.toNormal();
      this.satellite.normal(n.x, n.y, n.z); 
      this.satellite.vertex(op.x, op.y, op.z,u,v);
      
      op = this.map.new ObjectPoint(onw.x+i+25,onw.y+j);
      n = op.toNormal();
      this.satellite.normal(n.x, n.y, n.z); 
      this.satellite.vertex(op.x, op.y, op.z,u+5,v);
      
      op = this.map.new ObjectPoint(onw.x+i+25,onw.y+j+25);
      n = op.toNormal();
      this.satellite.normal(n.x, n.y, n.z);
      this.satellite.vertex(op.x, op.y, op.z,u+5,v+5);
      
      op = this.map.new ObjectPoint(onw.x+i,onw.y+j+25);
      n = op.toNormal();
      this.satellite.normal(n.x, n.y, n.z);
      this.satellite.vertex(op.x, op.y, op.z,u,v+5);
      v=v+5;
   }
   v=0;
   u=u+5;  
 }
   this.satellite.endShape(); 
   
  // Shapes initial visibility
  this.shadow.setVisible(true);
  this.wireFrame.setVisible(false);
  this.satellite.setVisible(true);    
}
  /*Méthode pour afficher les shapes shadow, wirefram, satellite appelé dans la fonction draw.
  *Appelée dans la fpnction draw pour afficher les shapes.
  */
 void update(){
    shape(this.shadow);
    shape(this.wireFrame);
    shape(this.satellite);
  }
  
  /*Méthode pour manipuler la visiblité des shapes wirefram et satellite.
  *Appelée dans la fonction keyPressed avec la touche W/w.  
  */
 void toggle() { 
    this.wireFrame.setVisible(!this.wireFrame.isVisible());
    this.satellite.setVisible(!this.satellite.isVisible());
    
  }
  
  /*
  Méthode qui calcule et renvoie la distance minimale entre la position d'un point de type objectPoint et les positions des points d'une liste du même type.
  @ pram p : Map3D.ObjectPoint , coordonneesL : ArrayList<Map3D.ObjectPoint>
  return  : float
  */
  public float calculerDistanceMin (Map3D.ObjectPoint p,ArrayList<Map3D.ObjectPoint> coordonneesL){
    float min = 1000.0f;
    for (Map3D.ObjectPoint v : coordonneesL){
      float distance = dist(p.x,p.y,p.z,v.x,v.y,v.z);
      if( distance < min){
        min = distance;  
    } 
  }
    return min; 
    
}
}
