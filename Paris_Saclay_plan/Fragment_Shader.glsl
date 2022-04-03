#ifdef GL_ES 
precision mediump float;
precision mediump int; 
#endif 

uniform sampler2D texture;

smooth in vec4 vertColor;
smooth in vec4 vertTexCoord;
smooth in vec2 vertHeat;

void main() {   

   gl_FragColor = texture2D(texture, vertTexCoord.st) * vertColor;
  //Modification des valeur r et g de g_FragColor en fonction des valeurs interpollées de vectHeat 
  gl_FragColor.r =vertHeat[0] ;
  gl_FragColor.g =vertHeat[1] ;
  
  
  
}
