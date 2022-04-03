class Roads{
  /*
  Renvoie un objet Roads.
  @param map : Map3D, fileName : String.
  *Déclaration de la shape roads.
  */
  
  
  PShape roads;
  
  Roads(Map3D map,String fileName){
    
    //Création de la PShape roads
    this.roads = createShape(GROUP);  
    
    //Décalaration des variables et initialisation de celles-ci. 
    String laneKind = "unclassified";
    color laneColor = 0xFFFF0000;
    double laneOffset = 1.50d;
    float laneWidth = 0.5f;
    
    
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
        PShape lane = createShape();
        lane.beginShape(QUAD_STRIP);
        lane.noFill();  
        lane.emissive(0x7F);
        
        JSONObject feature = features.getJSONObject(f);
        if (!feature.hasKey("geometry"))    
        break;
        //Recupération de l'objet proprieté 
        JSONObject properties = feature.getJSONObject("properties");
        //Récupération du type de la route
        laneKind = properties.getString("highway", "unclassified");
        switch (laneKind) {
          case "motorway":
          laneColor = 0xFFe990a0;
          laneOffset = 3.75d;
          laneWidth = 8.0f;
          break;
          case "trunk":
          laneColor = 0xFFfbb29a;
          laneOffset = 3.60d;
          laneWidth = 7.0f;
          break;
          case "trunk_link":
          case "primary":
          laneColor = 0xFFfdd7a1;
          laneOffset = 3.45d;
          laneWidth = 6.0f;
          break;
          case "secondary":
          case "primary_link": 
          laneColor = 0xFFf6fabb;
          laneOffset = 3.30d;
          laneWidth = 5.0f;   
           break;
          case "tertiary":
          case "secondary_link":  
          laneColor = 0xFFE2E5A9;
          laneOffset = 3.15d;
          laneWidth = 4.0f;
          break;
          case "tertiary_link":
          case "residential":
          case "construction":
          case "living_street":
          laneColor = 0xFFB2B485;
          laneOffset = 3.00d;
           laneWidth = 3.5f;
           break;
           case "corridor":
           case "cycleway":
           case "footway":
           case "path":
           case "pedestrian":
           case "service":
           case "steps":
           case "track":
           case "unclassified": 
           laneColor = 0xFFcee8B9;
           laneOffset = 2.85d; 
           laneWidth = 1.0f;  
            break; 
            default:   
            laneColor = 0xFFFF0000;
            laneOffset = 1.50d;  
            laneWidth = 0.5f;  
            println("WARNING: Roads kind not handled : ", laneKind);  
            break; 
          }
          // Display threshold (increase  if more performance needed...) 
          if (laneWidth < 1.0f)   
          break;
          //affectation de la couleur de la route et sa taille(largeur) selon son type à la shape lane 
          //j'ai dévisé la largeur sur 2 pour avoir un ebonne visibilité.
          
         lane.stroke(laneColor);
         lane.strokeWeight(laneWidth/2);
         
        JSONObject geometry = feature.getJSONObject("geometry");
        switch (geometry.getString("type", "undefined")) {
          case "LineString":
          
          //remplissage de la PSHape roads
          JSONArray coordinates = geometry.getJSONArray("coordinates");
          if (coordinates != null)
          

          //Le cas ou le tableau coordinates n'a que deux points 
          //pour ne pas avoir des coupures des voies.
           if(coordinates.size()==2){
            //recupération des points du tracé du fichier fileName avec le nom passé en paramétre au constructeur.
              JSONArray point = coordinates.getJSONArray(0);
              JSONArray point2 = coordinates.getJSONArray(1);
              //convertion du premier  points de la lingne
              Map3D.GeoPoint gp = map.new GeoPoint( point.getDouble(0),  point.getDouble(1)); 
              //convertion du deuxiéme  points de la lingne
              Map3D.GeoPoint gp2 = map.new GeoPoint( point2.getDouble(0),  point2.getDouble(1));
              //Vérifiacation si les deux points appartient au terrain
              if(gp.inside() == true && gp2.inside() == true){ 
                //augmentation de leurs élévations pour qu'ils ne soit pas caché sous la texture.
                gp.elevation += 7.5d;
                gp2.elevation += 7.5d;
                
               //Conversion des deux points en objectPoint  
              Map3D.ObjectPoint op = map.new ObjectPoint(gp);
              Map3D.ObjectPoint op2 = map.new ObjectPoint(gp2);
             
              //Conversion des points en vecteurs pour l'etape de la normalisation.
              op.toVector();
              op2.toVector();
              
              //normalisation du veceteur orthogonal à op et op2
              PVector Va   = new PVector(op.y - op2.y, op2.x - op.x).normalize().mult(15.0/2.0f);
              //normalisation du veceteur orthogonal à op2 et op
              PVector Vb   = new PVector(op2.y - op.y, op.x - op2.x).normalize().mult(15/2.0f);
              
              //le calcule de op' et op''
              lane.normal(0.0f, 0.0f, 1.0f);
              lane.vertex(op.x - Va.x, op.y - Va.y, op.z);
              lane.normal(0.0f, 0.0f, 1.0f);
              lane.vertex(op.x + Va.x, op.y + Va.y, op.z);
              
              //le calcule de op2' et op2''
              lane.normal(0.0f, 0.0f, 1.0f);
              lane.vertex(op2.x + Vb.x, op2.y + Vb.y, op2.z);
              lane.normal(0.0f, 0.0f, 1.0f);
              lane.vertex(op2.x - Vb.x, op2.y - Vb.y, op2.z);
              
          }
          }
           
          //Traitement du cas général pour les tableauxx coordinates
          for (int p=0; p < coordinates.size()-2; p++) {
            
              //recupération des points qui définissent la route  du ficher roads.
              JSONArray point = coordinates.getJSONArray(p);
              JSONArray point2 = coordinates.getJSONArray(p+1);
              JSONArray point3 = coordinates.getJSONArray(p+2);
              
              //convertion du premier  points de la ligne
              Map3D.GeoPoint gp = map.new GeoPoint( point.getDouble(0),  point.getDouble(1)); 
              //convertion du deuxiéme  points de la ligne
              Map3D.GeoPoint gp2 = map.new GeoPoint( point2.getDouble(0),  point2.getDouble(1)); 
              //convertion du troisiéme  points de la ligne
              Map3D.GeoPoint gp3 = map.new GeoPoint( point3.getDouble(0),  point3.getDouble(1));
              
              //Vérifiacation si les trois points appartient au terrain et qui n'ont pas d'élévation négative.
              if((gp.inside() == true && gp2.inside() == true && gp3.inside() == true )&&( gp.elevation>0.0 && gp2.elevation>0.0 && gp3.elevation>0.0)){ 
                
                //Addition de la valeur laneOffset récupérée dans le swich selon le type de la route au points de cette dérniére.
                gp.elevation += laneOffset;
                gp2.elevation += laneOffset;
                gp3.elevation += laneOffset;
                
               //Conversion des trois points en objectPoint  
              Map3D.ObjectPoint op = map.new ObjectPoint(gp);
              Map3D.ObjectPoint op2 = map.new ObjectPoint(gp2);
              Map3D.ObjectPoint op3 = map.new ObjectPoint(gp3);
              
              //Conversion des points en vecteur pour la normalisation.
              op.toVector();
              op2.toVector();
              op3.toVector();
              
              //normalisation du veceteur orthogonal à op et op2
              PVector Va   = new PVector(op.y - op2.y, op2.x - op.x).normalize().mult(laneWidth/2.0f);
              //normalisation du veceteur orthogonal à op et op3
              PVector Vb   = new PVector(op.y - op3.y, op3.x - op.x).normalize().mult(laneWidth/2.0f);
              //normalisation du veceteur orthogonal à op et op3
              PVector Vc   = new PVector(op2.y - op3.y, op3.x - op2.x).normalize().mult(laneWidth/2.0f);
              
              //le calcule de op' et op''
              lane.normal(0.0f, 0.0f, 1.0f);
              lane.vertex(op.x - Va.x, op.y - Va.y, op.z);
              lane.normal(0.0f, 0.0f, 1.0f);
              lane.vertex(op.x + Va.x, op.y + Va.y, op.z);
              
              //le calcule de op2' et op2''
              lane.normal(0.0f, 0.0f, 1.0f);
              lane.vertex(op2.x - Vb.x, op2.y - Vb.y, op2.z);
              lane.normal(0.0f, 0.0f, 1.0f);
              lane.vertex(op2.x + Vb.x, op2.y + Vb.y, op2.z);
              
              //le calcule de op3' et op3''
              lane.normal(0.0f, 0.0f, 1.0f);
              lane.vertex(op3.x - Vc.x, op3.y - Vc.y, op3.z);
              lane.normal(0.0f, 0.0f, 1.0f);
              lane.vertex(op3.x + Vc.x, op3.y + Vc.y, op3.z);
              
             
              }
                            
             }
             
             break;
        }
        lane.endShape();
        //Ajout de la ligne à la shape groupe de lignes du terrain.
        this.roads.addChild(lane);
    }
    //Initialiser la visibilité de la shape roads à true pour qu'elle soit visible par défaut.
    this.roads.setVisible(true);
   
  }
  
  /*
  Méthode pour afficher la shape roads.
  *Appelée dans la fonction draw.
  */
  
  void update(){
    shape(this.roads);   
  }
  /*
  Méthode pour gérer la visibilité de la shape roads.
  *Applée dans la fonction KeyPressed avec la touche C/c.
  */
  void toggle(){
    this.roads.setVisible(!this.roads.isVisible());
    
  }
  
  
  
  
  
  
 
  
}
