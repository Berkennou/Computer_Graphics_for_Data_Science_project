
class WorkSpace{
  /*
  Renvoie un objet Worksapce
  @param size : int
  Déclaration de deux PShape gizmo & grid
  */
  PShape gizmo;
  PShape grid;
  WorkSpace(int size){
    // Gizmo
    this.gizmo = createShape(); 
    this.gizmo.beginShape(LINES); 
    this.gizmo.noFill();
    this.gizmo.strokeWeight(3.0f); 
    // Red X 
    this.gizmo.stroke(0xAAFF3F7F); 
    this.gizmo.vertex(0,0,0);
    this.gizmo.vertex(250,0,0);
    //ajout d'une ligne fine pour l'axe X
    this.gizmo.strokeWeight(1.0f);
    this.gizmo.vertex(-size,0,0);
    this.gizmo.vertex(size,0,0);
    this.gizmo.strokeWeight(3.0f);
    // Green Y 
    this.gizmo.stroke(0xAA3FFF7F); 
    this.gizmo.vertex(0,0,0);
    this.gizmo.vertex(0,250,0);
    //ajout d'une ligne fine pour l'axe Y
    this.gizmo.strokeWeight(0.15f);
    this.gizmo.vertex(0,-size,0);
    this.gizmo.vertex(0,size,0); 
    // Blue Z 
    this.gizmo.strokeWeight(3.0f);
    this.gizmo.stroke(0xAA3F7FFF); 
    this.gizmo.vertex(0,0,0);
    this.gizmo.vertex(0,0,250);
    this.gizmo.endShape(); 
    
    // Grid 
    //Préparation pour remplir la PShape Grid
    this.grid = createShape(); 
    this.grid.beginShape(QUADS); 
    this.grid.noFill(); 
    this.grid.stroke(0x77836C3D); 
    this.grid.strokeWeight(0.5f); 

    // les deux boucles imbriqué pour déssiner les QUADS de la PShape Grid.

    for(int i=-size ; i<=size;i=i+250){
      for(int j=0 ; j<=size;j=j+250){
        this.grid.vertex(i,j,0);
        this.grid.vertex(i,j+250,0);
        this.grid.vertex(i+250,j+250,0);
        this.grid.vertex(i+250,j,0);
        
       this.grid.vertex(i,-j,0);
       this.grid.vertex(i,-j-250,0);
       this.grid.vertex(i+250,-j-250,0);
       this.grid.vertex(i+250,-j,0);
  
      }
 
    }
    
    this.grid.endShape(); 
    
  }
  
  /*Méthode pour afficher les deux PShape Gride & Gizmo 
  *Appelée dans la fonction draw du programme principale.
  */
  void update(){
    shape(this.gizmo);
    shape(this.grid);

  }
  
  /**  * Toggle Grid & Gizmo visibility.  */ 
  void toggle() {   
    this.gizmo.setVisible(!this.gizmo.isVisible());
    this.grid.setVisible(!this.grid.isVisible());
  }
}
