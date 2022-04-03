class Gpx{
  
  /*
  Renvoie un objet Gpx
  @param map : Map3D , fileName String
  Déclaration les PShape track, posts et thumbtacks ainsi que le tableau qui va contenir la déscription de chaque point.
  */
  
  PShape track;
  PShape  posts;
  PShape  thumbtacks;
  String[] descriptions;
  
  Gpx(Map3D map,String fileName){
    
   //Initialisation du tableau description pour stocker les descriptions des points du WayPoint.
   this.descriptions = new String[7];
   int i=0;
    
    
    //Création de la PShape pour le tracé
    this.track = createShape();     
    this.track.beginShape();     
    this.track.noFill();     
    this.track.stroke(0xFFEA1AEA);
    this.track.strokeWeight(2.5f);
    
    //Création de la pshape pour les poteaux
    this.posts = createShape();     
    this.posts.beginShape(LINES);     
    this.posts.noFill();     
    this.posts.stroke(0xFFEA1AEA);
    this.posts.strokeWeight(1.5f);
    
    //création de pshape pour les punaises
    this.thumbtacks = createShape();     
    this.thumbtacks.beginShape(POINTS);     
    this.thumbtacks.noFill();
    this.thumbtacks.stroke(0xFFFF3F3F);
    this.thumbtacks.strokeWeight(10.0f);
    
    // Check ressources
    File ressource = dataFile(fileName);
    if (!ressource.exists() || ressource.isDirectory()) {
        println("ERROR: GeoJSON file " + fileName + " not found.");   
        return; 
      } 
    // Load geojson and check features collection
    JSONObject geojson = loadJSONObject(fileName);
    if (!geojson.hasKey("type")) {
      println("WARNING: Invalid GeoJSON file.");
      return;
    } 
  else if (!"FeatureCollection".equals(geojson.getString("type", "undefined"))) {
      println("WARNING: GeoJSON file doesn't contain features collection.");
      return;
    } 
  // Parse features
  JSONArray features =  geojson.getJSONArray("features");
  if (features == null) {
      println("WARNING: GeoJSON file doesn't contain any feature.");
      return; 
    } 
    
    for (int f=0; f<features.size(); f++) {
        JSONObject feature = features.getJSONObject(f);
        if (!feature.hasKey("geometry"))    
        break;   
        JSONObject geometry = feature.getJSONObject("geometry");
        switch (geometry.getString("type", "undefined")) {
          case "LineString":
          // GPX Track
          JSONArray coordinates = geometry.getJSONArray("coordinates");
          if (coordinates != null)         
          for (int p=0; p < coordinates.size(); p++) {            
              //recupération des points du tracé du ficheirr geotrail
              JSONArray point = coordinates.getJSONArray(p);
              //convertion des points de la ligne vers un format processing
              Map3D.GeoPoint gp = map.new GeoPoint( point.getDouble(0),  point.getDouble(1)); 
              Map3D.ObjectPoint op = map.new ObjectPoint(gp);
              // affectation des points pour dessiné ces dérniers sous forme d'une ligne dans la PShape du tracé.
              this.track.vertex(op.x,op.y,op.z);
          }  
             break;
             case "Point":
            // GPX WayPoint
            if (geometry.hasKey("coordinates")) {
              //recupération des points des poteaux et des punaises du fichier geotrail
              JSONArray point = geometry.getJSONArray("coordinates");
              //convertion de points pour les punaise et les poteaux en format processing
              Map3D.GeoPoint gp = map.new GeoPoint( point.getDouble(0),  point.getDouble(1));
              Map3D.ObjectPoint op = map.new ObjectPoint(gp);
              //affectation des points pour les deux pshape pour dessiné les lignes pour les poteaux et les puaises ou j'ai choisie de mettre le deuxiéme points du poteaux à une hauteur de 500 pour bien les visualiser.
              this.posts.vertex(op.x,op.y,op.z);
              this.posts.vertex(op.x,op.y,op.z+200);
              this.thumbtacks.vertex(op.x,op.y,op.z+200);
              
              if (feature.hasKey("properties")) {   
                //Affectation de la chaîne de caractéres de la description de chaque points du type Point à un élements du tableau descriptions.
              this.descriptions[i] = feature.getJSONObject("properties").getString("desc");   
              i++;
            }
              
              
              
              
              
            }
              break;
              default:     
                println("WARNING: GeoJSON '" + geometry.getString("type", "undefined") + "' geometry type not handled.");
                  break; 
             
        }
    }
    
    
    this.track.endShape();
    this.posts.endShape();
    this.thumbtacks.endShape();
    

    
    
    //Définir la visibilité des shapes à vrai pour qu'elles soit visible par défaut.
    this.track.setVisible(true);
    this.posts.setVisible(true);
    this.thumbtacks.setVisible(true);
    
    
  }
  
  
  /*
  Méthode pour afficher les shapes.
  *appelée dans la fontion draw. 
  */
  void update(){
    shape(this.track);
    shape(this.posts);
    shape(this.thumbtacks);
    
  }
  
  /*
  Méthode pour gérer la visibilité des shapes.
  *Appelée dans la fonction KeyPressed.
  */
  
 void toggle(){
    this.track.setVisible(!this.track.isVisible());
    this.posts.setVisible(!this.posts.isVisible());
    this.thumbtacks.setVisible(!this.thumbtacks.isVisible());      

 }  

 /*
 Méthode pour modifier la couleur des points de la shape thumbtacks (punaises) en cas de clic gauche de la souris sur celle-ci.
 @pram mx, my : float 
 * mx, my les coordonées x et y de la postion de la souris sur l'écran.
 *Appleé dans la fonction mousePressed.
 
 */
 
  void clic(float mX, float mY){
    //Création de la variable PVector pour stocker le point de la shape thumtacks.
    PVector hit = new PVector();
    //Boucle pour parcourir tout les points de la shape thumtacks.
    for(int v= 0;  v  <  this.thumbtacks.getVertexCount() ; v++){  
        this.thumbtacks.getVertex(v,hit);
    //comparer les coordonnées des points avec celles de la souris sur l'ecran.
      if (dist(mX, mY,screenX(hit.x,hit.y,hit.z),screenY(hit.x,hit.y,hit.z)) <5 ){
        //Redéfinir la couleurs de la punaises si la position de la souris est trop proche de la positions de celle-ci lors du clic gauche.
        this.thumbtacks.setStroke(v,0xFF3FFF7F);
      }
      else{
        //Redéfinir la couleur initiale de la punaise en cas de non clic.
        this.thumbtacks.setStroke(v, 0xFFFF3F3F);  
    }

 }
}

/* 
Méthode pour afficher la description du points (punaise) de la shape thumtacks.
 @param mX,mY : float , camera : Camera.
 * mx, my les coordonées x et y de la postion de la souris sur l'écran.
 *camera est l'objet caméra lors de du clic gauche de la souris.
 *Appleé dans la fonction draw lors du test mouseButton.
*/

 void afficherDesc(float mX, float mY,Camera camera){ 
          //Création de la variable PVector pour stocker le point de la shape thumtacks.
          PVector hit = new PVector();
          //Boucle pour parcourir tout les points de la shape thumtacks.
          for(int v= 0;  v  <  this.thumbtacks.getVertexCount() ; v++){
            this.thumbtacks.getVertex(v,hit);            
            //comparer les coordonnées des points avec celles de la souris sur l'ecran.
            if (dist(mX, mY,screenX(hit.x,hit.y,hit.z),screenY(hit.x,hit.y,hit.z)) <5 ){
              //afficher la description contenue dans le tableau déja crée et remplit  du point (punaise) si la position de la souris est trop proche de la positions de celui-ci lors du clic gauche.
                pushMatrix();
                lights();
                fill(0xFFFFFFFF);
                translate(hit.x, hit.y, hit.z + 10.0f);
                rotateZ(-camera.longitude-HALF_PI);
                rotateX(-camera.colatitude);
                g.hint(PConstants.DISABLE_DEPTH_TEST);
                textMode(SHAPE);
                textSize(58);
                textAlign(LEFT, CENTER);
                text(this.descriptions[v], 0, 0);
                g.hint(PConstants.ENABLE_DEPTH_TEST);
                popMatrix();
          }
        }
 }
       
  
}  
  
