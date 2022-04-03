class Buildings{
  /*
  Renvoie un objet Buildings.
  @param map : Map3D.
  *Déclaration de la shape buldings.
  */
  
  PShape buildings;
  
  
  Buildings(Map3D map){
    
    //Création de la PShape builidings
    this.buildings = createShape(GROUP);
    
    
    //Initialiser la visibilité de la shape buildings à true pour qu'elle soit visible par défaut.
    this.buildings.setVisible(true);
  
  }
  /*
  Méthode qui forme une shape à partir du contenu d'un ficher geojson et l'ajoute à la shape groupe buildings.
  @param : fileName : String, clr : int 
  *fileName le nom du ficher geojson.
  *clr le nombre correspondant à la couleur dont la shape(bâtiment) à rajoutée sera colorier
  *Appelé dans la fonction setup .
  */
  
  void add(String fileName , int clr){
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
        //Récupération de l'objet proprities de chaque feature du ficher
        JSONObject properties = feature.getJSONObject("properties");
        
        //Récupération du nombre d'étage des bâtiments de la feature vu qu'ils ont tous la même proprieté que la feature.
        int levels = properties.getInt("building:levels", 1);
        
        //Décalararion et initialisation de la variable top pour l'utilisé dans l'affectation des vertexs à la shape formant chaque bâtiment.
        float top = Map3D.heightScale * 3.0f * (float)levels;
        
        JSONObject geometry = feature.getJSONObject("geometry");
        switch (geometry.getString("type", "undefined")) {
          case "Polygon":
          //remplissage de la PSHape buildings
          JSONArray coordinates = geometry.getJSONArray("coordinates");
          if (coordinates != null)          
          //Dans cette boucle on récupére chaque polygone des polygones de la features 
         for (int pol=0; pol < coordinates.size(); pol++) {
             JSONArray polygone = coordinates.getJSONArray(pol);             
             //Décalaration et création de la shape walls qui contiendra les murs de chaque polygone (bâtiment).
             PShape walls = createShape();
             walls.beginShape(QUADS);
             walls.fill(clr); walls.noStroke();walls.emissive(0x30);             
             //Décalaration et création de la shape roof qui contiendra le toit de chaque polygone (bâtiment).
             PShape roof = createShape();
             roof.beginShape(POLYGON);
             roof.fill(clr);  roof.noStroke();roof.emissive(0x60);             
            //Dans cette boucle imbriqué dans la boucle de récupération des polygone,
            //On récupérera les points formant chaque polygone(bâtimen) de chaque feature du ficher fileName.
            for(int p = 0; p < polygone.size()-1;p++){            
              //recupération des points de chaque polygone.
              JSONArray point = polygone.getJSONArray(p);
              JSONArray point2 = polygone.getJSONArray(p+1);              
              //convertion du premier points.
              Map3D.GeoPoint gp = map.new GeoPoint( point.getDouble(0),  point.getDouble(1)); 
              //convertion du deuxiéme points .
              Map3D.GeoPoint gp2 = map.new GeoPoint( point2.getDouble(0),  point2.getDouble(1)); 
              //conversion des points déja convertit en point GeoPoin en ObjectPoint.
              Map3D.ObjectPoint op = map.new ObjectPoint(gp);
              Map3D.ObjectPoint op2 = map.new ObjectPoint(gp2);              
              //Vérification que les points apparatiennent au terrain.
              if (op.inside() && op2.inside()){                
                //Affectation des vertex à la shape walls pour formé les murs de chaque bâtiment.
                walls.vertex(op.x,op.y,op.z);
                walls.vertex(op2.x,op2.y,op2.z);
                walls.vertex(op2.x,op2.y,op2.z+top);
                walls.vertex(op.x,op.y,op.z+top);
                //Affectation des vertex à la shape roof pour formé le toit de chaque bâtiment.
                roof.vertex(op.x,op.y,op.z+top);
                
     
              }
          }
             walls.endShape();
             roof.endShape();
             //Ajout des shapes walls et roof aprés formation de chaque polygon(bâtiment) de chaque feature contenue dans la featurCollection du fichier fileName.
             this.buildings.addChild(walls);
             this.buildings.addChild(roof);
             
                            
             }
             
             break;
        }
             
        }
        
    }
    
    /*
  Méthode pour afficher la shape buildings.
  *Appelée dans la fonction draw.
  */
    
    void update(){
      shape(this.buildings);
      
    }
    /*
  Méthode pour gérer la visibilité de la shape buildings.
  *Applée dans la fonction KeyPressed avec la touche B/b.
  */
    
    void toggle(){
    this.buildings.setVisible(!this.buildings.isVisible());
    
  }
    
    
  }
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
