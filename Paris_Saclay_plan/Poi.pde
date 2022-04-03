class Poi{
  
  /*
  Renvoie un objet Poi.
  @param map : Map3D.
  */
  
  
  Poi(Map3D map){
    
  }
  
  /*Méthode qui renvoie une liste de points de type objectPoint à partir d'un ficher donnée de type geojson.
  @param fileName : String.
  return : ArrayList<Map3D.ObjectPoint>. 
  */
  
  
 public ArrayList<Map3D.ObjectPoint> getPoints(String  fileName){
       
    
      // Check ressources
      File ressource = dataFile(fileName);
      if (!ressource.exists() || ressource.isDirectory()) {
          println("ERROR: GeoJSON file " + fileName + " not found.");   
          return null; 
        } 
      // Load geojson and check features collection
      JSONObject geojson = loadJSONObject(fileName);
      if (!geojson.hasKey("type")) {
        println("WARNING: Invalid GeoJSON file.");
        return null;
      } 
    else if (!"FeatureCollection".equals(geojson.getString("type", "undefined"))) {
        println("WARNING: GeoJSON file doesn't contain features collection.");
        return null;
      } 
    // Parse features
    JSONArray features =  geojson.getJSONArray("features");
    
    
    if (features == null) {
        println("WARNING: GeoJSON file doesn't contain any feature.");
        return null; 
      } 
      
      //Création de la liste de type ObjectPoint qui va contenir les x,y des points obtenue à partir du fichier fileName.
      ArrayList<Map3D.ObjectPoint> coordonneesList = new ArrayList<Map3D.ObjectPoint>();
      //Parcours des features du ficher.
      for (int f=0; f<features.size(); f++) {
           
        //Récupération de chaque feature à chaque tour de boucle.
          JSONObject feature = features.getJSONObject(f);
          if (!feature.hasKey("geometry"))    
          break;   
                   
          JSONObject geometry = feature.getJSONObject("geometry");
          switch (geometry.getString("type", "undefined")) {
            case "Point":
            
            JSONArray coordinates = geometry.getJSONArray("coordinates");
            if (coordinates != null){  
              
              /*conversion du point de la feature en GeoPoint puis en ObjectPoint
              vu que chaque feature contient un seul point avec x,y comme coordnées.*/
              
              Map3D.GeoPoint gp = map.new GeoPoint( coordinates.getDouble(0),  coordinates.getDouble(1));
              Map3D.ObjectPoint op = map.new ObjectPoint(gp);
              
              //ajout du points obtnue aprés conversion à la liste qu'on va renvoyer aprés parcours et récupération des points de toutes les features du ficher.
              coordonneesList.add(op);
              
              
            }
            
            
          }
      }
      //On renvoie la liste des points objectPoint obtenue.
      return coordonneesList;
    
    
  }
  
 
}
