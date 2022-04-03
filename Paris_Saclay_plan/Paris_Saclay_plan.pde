
//Declaration de l'objet Workspace
WorkSpace workspace;

//Declaration de l'objet Camera
Camera cam ;

//Declaration de l'objet Hud
Hud hud;

//Declaration de l'objet Map3D
Map3D map;

//Declaration de l'objet Land
Land land;

//Declaration de l'objet Gpx
Gpx gpx;

//Declaration de l'objet Railways
Railways railways;

//Declaration de l'objet Roads
Roads roads;

//Declaration de l'objet Building
Buildings buildings;

//Declaration de l'objet Poi
Poi poi;

//Declaration de la variable qui contiendera le sahder.
//PShader myShader;

void setup(){
  
  //Chargement des Vertex_Shader et Fragment_Shader.
  //myShader = loadShader("Fragment_Shader.glsl", "Vertex_Shader.glsl");
  
  size(1200,800,P3D);
  //fullScreen(P3D);
  
  // Setup Head Up Display   
  this.hud = new Hud();   
  smooth(8);   
  frameRate(60);
   
  //initialisation de l'objet Workspace
  this.workspace = new WorkSpace(25000);
  
  //initialisation de l'objet Camera
  this.cam = new Camera();
  
  // Load Height Map
  this.map = new Map3D("paris_saclay.data");
  
  //initialisation de l'objet Poi
   this.poi = new Poi(this.map);
   
   //Création des tableau des points de picnic table et de parking de vélo
   ArrayList<Map3D.ObjectPoint> ParkingPoint = this.poi.getPoints("bicycle_parking.geojson");
   ArrayList<Map3D.ObjectPoint> PicNicTbalePoint = this.poi.getPoints("picnic_table.geojson");
   
   //initialisation de l'objet Land
  this.land =  new  Land(this.map,"paris_saclay.jpg",ParkingPoint,PicNicTbalePoint);
  
  //initialisation de l'objet Gpx
  this.gpx = new Gpx(this.map, "trail.geojson");
  
  //initialisation de l'objet Railways
  this.railways = new Railways(this.map, "railways.geojson");
  
  //initialisation de l'objet Roads
  this.roads = new Roads(this.map, "roads.geojson");
  
  //initialisation de l'objet Building
  this.buildings = new Buildings(this.map);
  
  // Prepare buildings   
  //this.buildings.add("buildings_city.geojson", 0xFFaaaaaa);
  //this.buildings.add("buildings_IPP.geojson", 0xFFCB9837); 
  //this.buildings.add("buildings_EDF_Danone.geojson", 0xFF3030FF); 
  this.buildings.add("buildings_CEA_algorithmes.geojson", 0xFF30FF30); 
  this.buildings.add("buildings_Thales.geojson", 0xFFFF3030); 
  this.buildings.add("buildings_Paris_Saclay.geojson", 0xFFee00dd);

  // Make camera move easier   
  hint(ENABLE_KEY_REPEAT); 
  
}

void draw(){
  
  //Application du shader déja chargé.
  //shader(myShader);
  
  
  
  //Définition de la couleur de l'arriére plan
  background(0x40);
  
  //L'appel à la méthode update de Worksapce pour afficher grid & gizmo
  this.workspace.update();
  
  //L'appel à la méthode update de Camera pour configurer et mettre à jour la camera 
  this.cam.update();
  
  //L'appel à la méthode update de Land pour afficher les PShape du terrain
  this.land.update(); 
  
  //L'appel à la méthode update de Gpx pour affiché le tracé gps
  this.gpx.update();
  
  //L'appel à la méthode update de Railways pour afficher la PShape de la ligne du RER
  this.railways.update();
  
  //L'appel à la méthode update de Roads pour afficher la PShape des différentes routes appartenant au terrain 
  this.roads.update();
  
  //Arret de l'utilsation du shader pour ne pas impacté les bâtiments.
  //resetShader();
  
  //L'appel à la méthode update de Buiding pour afficher la PShape qui groupe tout les bâtiment du terrain 
  this.buildings.update();
  
  //en cas d'un clic gauche de la souris sur une punaise du tracé gpx ça affiche la déscription de ce point  
  if (mouseButton == LEFT){
     this.gpx.afficherDesc(mouseX, mouseY,this.cam);
   } 
   
    
   //L'appel à la méthode update de Hud pour afficher le FPS en bas à gauche et les informations concernant la camera e Haut à gauche.
  this.hud.update(this.cam);
  
   
   
   
}

//L'appel à la méthode qui colorie les punaises du tracé aprés un clic gauche de la souris.
void mousePressed() { 
  if (mouseButton == LEFT) 
     this.gpx.clic(mouseX, mouseY);
   } 
   
//  L'appel au méthode d'afficher/masquer les élements du terrain au cas d'un clic sur une touche spécifique. 
void keyPressed() { 
  switch (key) { 
    case 'b':    
    case 'B':     
    // Afficher/masquer les bâtiments du terrain   
   this.buildings.toggle();
   break;   
 }
  switch (key) { 
    case 'c':    
    case 'C':     
    // Afficher/masquer les différentes routes du terrain    
   this.roads.toggle();
   break;   
 }
  switch (key) { 
    case 'r':    
    case 'R':     
    // Afficher/masquer la ligne du RER B traversant le terrain.   
   this.railways.toggle();
   break;   
 }
  
  switch (key) { 
    case 'x':    
    case 'X':     
    // Afficher/masquer le tracé,le wayPoint et les punaises.    
   this.gpx.toggle();
   break;   
 }
  switch (key) { 
    case 'l':    
    case 'L':     
    // Allumer/éteindre la lumiére directionnelle.    
   this.cam.toggle();
   break;   
 }
  switch (key) { 
    case 'w':    
    case 'W':     
    // afficher/masquer grid & Gizmo & terrain mais pas la wirefram.    
   this.workspace.toggle();  
   this.land.toggle();
   break;   
 }
 //apporter des modifications aprés clic sur les touche ->, <-, up, down,+,- sur les paramétres de la caméra avec les méthode de la classe Camera adjust*
 if (key == CODED) {     
     switch (keyCode) {     
       case UP:       
       
       this.cam.adjustColatitude(PI/18);       
       break;     
       case DOWN:       
      
       this.cam.adjustColatitude(-PI/18);       
       break; 
       case LEFT:       
       
       this.cam.adjustLongitude(+PI/18);       
       break;     
       case RIGHT:      
       
       this.cam.adjustLongitude(-PI/18);       
        break;     
      }  
    } else {     
       switch (key) {     
         case '+':     
             
             this.cam.adjustRadius(-100);
             
              break;     
              case '-':       
             
             this.cam.adjustRadius(+100);
             
              break;     
            }  
          }   
        }
