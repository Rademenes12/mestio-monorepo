"use client"
import { useEffect, useRef } from 'react'

const VERTEX_SHADER = `#version 300 es
in vec2 a_position;
out vec2 v_uv;
void main() {
  gl_Position = vec4(a_position, 0.0, 1.0);
  v_uv = a_position * 0.5 + 0.5;
}`

const FRAGMENT_SHADER = `#version 300 es
precision highp float;
in vec2 v_uv;
out vec4 fragColor;
uniform float uTime;
uniform vec2 uResolution;

float sdCircle(vec2 p, float r) {
  return length(p) - r;
}

void main() {
  vec2 uv = (v_uv - 0.5) * 2.0;
  uv.x *= uResolution.x / uResolution.y;
  
  vec3 col = vec3(0.04, 0.04, 0.10); // #0A0A1A
  float t = uTime * 0.3;
  
  for (int i = 0; i < 8; i++) {
    float fi = float(i);
    float r = 0.3 + 0.4 * cos(fi * 1.3 + t * 0.7);
    float a = fi * 0.785 + t * (0.5 + fi * 0.15);
    vec2 pos = vec2(r * cos(a), r * sin(a) * 0.6);
    
    float d = sdCircle(uv - pos, 0.08 + 0.04 * sin(fi + t));
    float glow = 0.02 / (abs(d) + 0.02);
    vec3 particleColor = mix(
      vec3(0.533, 0.392, 0.941),  // #8864f0
      vec3(0.302, 0.639, 1.0),     // #4da3ff
      fi / 7.0
    );
    col += particleColor * glow * 0.25;
  }
  
  fragColor = vec4(col, 1.0);
}`

function createShader(gl: WebGL2RenderingContext, type: number, source: string): WebGLShader {
  const shader = gl.createShader(type)!
  gl.shaderSource(shader, source)
  gl.compileShader(shader)
  if (!gl.getShaderParameter(shader, gl.COMPILE_STATUS)) {
    console.error('Shader compile error:', gl.getShaderInfoLog(shader))
    gl.deleteShader(shader)
    throw new Error('Shader compilation failed')
  }
  return shader
}

export function useWebGLBackground(canvasRef: React.RefObject<HTMLCanvasElement | null>) {
  const animFrameRef = useRef<number>(0)
  const glRef = useRef<WebGL2RenderingContext | null>(null)
  const programRef = useRef<WebGLProgram | null>(null)

  useEffect(() => {
    const canvas = canvasRef.current
    if (!canvas) return

    const gl = canvas.getContext('webgl2', { alpha: false })
    if (!gl) return
    glRef.current = gl

    const vs = createShader(gl, gl.VERTEX_SHADER, VERTEX_SHADER)
    const fs = createShader(gl, gl.FRAGMENT_SHADER, FRAGMENT_SHADER)
    const program = gl.createProgram()!
    gl.attachShader(program, vs)
    gl.attachShader(program, fs)
    gl.linkProgram(program)
    programRef.current = program
    gl.deleteShader(vs)
    gl.deleteShader(fs)

    const vertices = new Float32Array([-1, -1, 1, -1, -1, 1, 1, 1])
    const buf = gl.createBuffer()
    gl.bindBuffer(gl.ARRAY_BUFFER, buf)
    gl.bufferData(gl.ARRAY_BUFFER, vertices, gl.STATIC_DRAW)

    const aPosition = gl.getAttribLocation(program, 'a_position')
    const uTime = gl.getUniformLocation(program, 'uTime')
    const uResolution = gl.getUniformLocation(program, 'uResolution')

    const resize = () => {
      canvas.width = canvas.clientWidth * window.devicePixelRatio
      canvas.height = canvas.clientHeight * window.devicePixelRatio
      gl.viewport(0, 0, canvas.width, canvas.height)
    }
    resize()
    window.addEventListener('resize', resize)

    const startTime = performance.now()
    const render = (now: number) => {
      gl.useProgram(program)
      gl.enableVertexAttribArray(aPosition)
      gl.bindBuffer(gl.ARRAY_BUFFER, buf)
      gl.vertexAttribPointer(aPosition, 2, gl.FLOAT, false, 0, 0)
      gl.uniform1f(uTime, (now - startTime) * 0.001)
      gl.uniform2f(uResolution, canvas.width, canvas.height)
      gl.drawArrays(gl.TRIANGLE_STRIP, 0, 4)
      animFrameRef.current = requestAnimationFrame(render)
    }
    render(startTime)

    return () => {
      window.removeEventListener('resize', resize)
      cancelAnimationFrame(animFrameRef.current)
      if (programRef.current) gl.deleteProgram(programRef.current)
    }
  }, [canvasRef])
}
