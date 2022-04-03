
class Camera{
   
  /*
  Renvoie un objet Caméra 
  @param lon, cola, r : float 
  Declaration des attribut de la clsse caméra Longitude, Colatitude, radius et lightning
  */
 
  
  float longitude;
  float colatitude;
  float radius;
  boolean lightning = false;
  //Premier constructeur si l'objet reçois les valeurs des attributs lors de sa création
  Camera(float lon, float cola,float r ){
    //Initialisation des valeurs des attributs avec les les valeurs passées en paramétre.
    this.longitude = lon;
    this.colatitude = cola;
    this.radius= r;
  }
  //Deuxiéme constructeur si l'objet ne reçois aucune valeurs d'attribut lors de sa création 
  //Dans ce cas on initialise les valeurs des attributs à la positions initiale de la caméra donnée.
  Camera(){
    //Initailisation des valeurs des attributs avec des valeurs calculées pour avoir la position de la caméra donnée dans l'ennoncé.
    this.longitude = (PI/2);
    this.colatitude = (1.1902);
    this.radius = 2692.58;
  }
  
  //Méthode pour mettre à jour la position de la caméra applée dans la fonction draw. 
  void update(){
    //Un appel pour la méthode caméra de processing avec les valeurs des attributs de la classe Camera changés/inchangés pour calculé les coordonnées à passer pour cette déniére et  redéfinir/maintenir la position de la caméra 
    camera( this.radius* sin(this.colatitude) * cos(this.longitude)  ,
    this.radius* sin(this.colatitude) * sin(this.longitude),
    this.radius* cos(this.colatitude) ,   0, 0, 0,    0, 0, -1   );
    // Sunny vertical lightning 
    ambientLight(0x7F, 0x7F, 0x7F); 
    if (this.lightning)   {
      directionalLight(0xA0, 0xA0, 0x60, 0, 0, -1); 
    }
    lightFalloff(0.0f, 0.0f, 1.0f); 
    lightSpecular(0.0f, 0.0f, 0.0f);    
  }  
  /*Méthode pour ajuster(modifier) l'attribut radius donc modifier la postoion de la caméra aprés la mise à jour 
  @param offset : float ->négatif/positif pour augmenter/diminuer le radius(rayon).  
  */
  void adjustRadius(float offset){
    //tester si la valeur du rayon peut être modifier ou pas (si n peut zoomer/dézoomer encore ou pas).
    if (this.radius+offset >= width*0.5 & this.radius+offset <= width*3.0  ) {
      this.radius+=offset; 
    } 
  }
  /*Méthode pour ajuster(modifier) l'attribut Longitude donc modifier la postoion de la caméra aprés la mise à jour 
  @param delta : float ->négatif/positi pour  augmenter/diminuer la valeurs de la longitude .  
  */  
  void adjustLongitude(float delta){
    //tester si la valeur de la longitude peut être modifier ou pas( si on peut encore tourner à droite/gauche ou pas).
    if(this.longitude+delta >=-3*PI/2 & this.longitude+delta <=PI/2){
      this.longitude += delta; 
    }
  
  }
  
  /*Méthode pour ajuster(modifier) l'attribut Longitude donc modifier la postoion de la caméra aprés la mise à jour 
  @param delta : float ->négatif/positi pour  augmenter/diminuer la valeurs de la longitude .  
  */ 
 void adjustColatitude(float delta){
   //tester si la valeur de la longitude peut être modifier ou pas( si on peut encore tourner en haut/bas ou pas).
   if(this.colatitude+delta >=(10^-6) & this.colatitude+delta <=PI/2){
     this.colatitude += delta;  
   }     
 }
 //Méthode pour allumer/éteindre la lumiére orientation caméra.
 void toggle(){
   if(this.lightning == false){
     this.lightning = true;
   }
   else{
     this.lightning = false;
   }
}
}
