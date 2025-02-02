uniform float uTime;
uniform sampler2D uPerlinTexture;

varying vec2 vUv;

#include ../includes/rotate2d.glsl

void main(){
  vec3 newPosition = position;
  
  // twist
  float twistPerlin = texture(
    uPerlinTexture, 
    vec2(0.5, uv.y * 0.2 - uTime * 0.005)
  ).r;
  float angle = twistPerlin * 10.;
  newPosition.xz = rotate2D(newPosition.xz, angle);

  // wind
  vec2 windOffset = vec2(
    texture(uPerlinTexture, vec2(0.25, uTime * 0.01)).r - 0.5,
    texture(uPerlinTexture, vec2(0.75, uTime * 0.01)).r - 0.5
  );
  windOffset *= pow(uv.y, 2.0) * 10.;
  newPosition.xz += windOffset;

  // final position
  gl_Position = projectionMatrix * modelViewMatrix * vec4(newPosition, 1.0);

  // varyings
  vUv = uv;
}