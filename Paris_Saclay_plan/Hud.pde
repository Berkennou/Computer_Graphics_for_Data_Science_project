class Hud {
  private PMatrix3D hud;
  
  Hud() {     
  // Should be constructed just after P3D size() or fullScreen()     
  this.hud = g.getMatrix((PMatrix3D) null);   
} 

  private void begin() {     
  g.noLights();   
  g.pushMatrix();
  g.hint(PConstants.DISABLE_DEPTH_TEST);     
  g.resetMatrix();     
  g.applyMatrix(this.hud);   
}

  private void end() {     
     g.hint(PConstants.ENABLE_DEPTH_TEST);     
     g.popMatrix();   
   }
   
  private void displayFPS() {     
    // Bottom left area     
    noStroke();     
    fill(96);     
    rectMode(CORNER);     
    rect(10, height-30, 60, 20, 5, 5, 5, 5);     
   // Value     
   fill(0xF0);     
   textMode(SHAPE);     
   textSize(14);     
   textAlign(CENTER, CENTER);     
   text(String.valueOf((int)frameRate) + " fps", 40, height-20);   
 }
 
 /*
 Méthode qui définit un affichage avec les valeurs des attributs de la classe Camera longitude, colatitude et radius en haut à gauche de l'écran.
 @param camera : Camera 
 */
 
 void displayCamera(Camera camera){
   // l'air en haut à gauche
   noStroke();     
    fill(96);     
    rectMode(CORNER);     
    rect(10, 10, 120, 90, 5, 5, 5, 5);     
   // Valeurs     
   fill(0xF0);     
   textMode(SHAPE);     
   textSize(14);     
   textAlign(CENTER, CENTER);    
   text("Camera",65,20);
   // les élements à affiché dans l'air désigné avec arrondis des chiffre aprés la virgule de la longitude et la colatitude.
   text( "Longitude    "+ String.valueOf((int)degrees(camera.longitude)) + " °", width-(width-70),height -(height-40));
   text( "Colatitude   "+ String.valueOf((int)degrees(camera.colatitude)) + " °",width-(width-70) , height -(height-60));
   text( "Radius  "+ String.valueOf((int)camera.radius)+ " m", width-(width-70), height -(height-80));
   
 }
 
 
 
 /*
 Méthode appelé dans la fonction draw pour afficher le contenu de l'air en haut à gauche et en bas à gauche.
  Elle fait appel elle même au méthode définit précédement :
  *displayFps pour l'affichage de le FPS en bas à gauche
  *dislayCamera pour l'affichage des informations concernat la position de la camera actuelle en haut à gauche.
  *Ces deux appels doivent être entre les appels au méthode begin et end.
 */
 
 void update(Camera camera){
   this.begin();
   this.displayFPS();
   this.displayCamera(camera);
   this.end();
 }
   
}
