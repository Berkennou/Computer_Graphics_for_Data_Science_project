

class Railways{
  /*
  Renvoie un objet Railways
  @param map : Map3D, fileName : String
  *Déclaration de la shape railways
  */
  
  PShape railways;
  
  Railways(Map3D map,String fileName){
    //Création de la PShape railways
    this.railways = createShape(GROUP);          
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
        lane.stroke(0xFFF5EDED);
        lane.strokeWeight(3.0f);
        lane.emissive(0x7F);
        JSONObject feature = features.getJSONObject(f);
        if (!feature.hasKey("geometry"))    
        break;   
        JSONObject geometry = feature.getJSONObject("geometry");
        switch (geometry.getString("type", "undefined")) {
          case "LineString":
          //remplissage de la PSHape railways
          JSONArray coordinates = geometry.getJSONArray("coordinates");
          if (coordinates != null)
          //Le cas ou le tableau coordinates n'a que deux points
          //Pour ne avoir des coupures dans la voie du RER
          if(coordinates.size()==2){
          //recupération des points du tracé du fichier railways avec le nom passé en paramétre au constructeur.
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
              //normalisation du veceteur orthogonal à op2 et op1
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
              //recupération des points du tracé du fichier railways avec le nom passé en paramétre au constructeur.
              JSONArray point = coordinates.getJSONArray(p);
              JSONArray point2 = coordinates.getJSONArray(p+1);
              JSONArray point3 = coordinates.getJSONArray(p+2);              
              //convertion du premier  points de la lingne
              Map3D.GeoPoint gp = map.new GeoPoint( point.getDouble(0),  point.getDouble(1)); 
              //convertion du deuxiéme  points de la lingne
              Map3D.GeoPoint gp2 = map.new GeoPoint( point2.getDouble(0),  point2.getDouble(1)); 
              //convertion du troisiéme  points de la lingne
              Map3D.GeoPoint gp3 = map.new GeoPoint( point3.getDouble(0),  point3.getDouble(1));              
              //Vérifiacation si les trois points appartient au terrain
              if(gp.inside() == true && gp2.inside() == true && gp3.inside() == true){                 
                //augmentation de leurs élévations pour qu'ils ne soit pas caché sous la texture.
                gp.elevation += 7.5d;
                gp2.elevation += 7.5d;
                gp3.elevation += 7.5d;                
               //Conversion des points en objectPoint  
              Map3D.ObjectPoint op = map.new ObjectPoint(gp);
              Map3D.ObjectPoint op2 = map.new ObjectPoint(gp2);
              Map3D.ObjectPoint op3 = map.new ObjectPoint(gp3);              
              //Conversion des points en vecteurs pour l'etape de la normalisation.
              op.toVector();
              op2.toVector();
              op3.toVector();              
              //normalisation du veceteur orthogonal à op et op2
              PVector Va   = new PVector(op.y - op2.y, op2.x - op.x).normalize().mult(15.0/2.0f);
              //normalisation du veceteur orthogonal à op et op3
              PVector Vb   = new PVector(op.y - op3.y, op3.x - op.x).normalize().mult(15.0/2.0f);
              //normalisation du veceteur orthogonal à op2 et op3
              PVector Vc   = new PVector(op2.y - op3.y, op3.x - op2.x).normalize().mult(15/2.0f);
              
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
        //addition de la shape au groupe railways pour en recréer une autre shape avec les points suivants des features du fichier.
        this.railways.addChild(lane);
    }
    
    //Définir la visiblité par défaut à la valeur true pour que railways (ligne RER B) soit visible par défaut sur le terrain.
    this.railways.setVisible(true);
   
  }
  
  /*
  Méthode pour afficher la shape railways.
  *Appelée dans la fonction draw.
  */
  void update(){
    shape(this.railways);   
  }
  /*
  Méthode pour gérer la visibilité de la shape railways.
  *Applée dans la fonction KeyPressed avec la touche R/r.
  */
  void toggle(){
    this.railways.setVisible(!this.railways.isVisible());
    
  }
  
  
  
  
  
  
 
  
}
