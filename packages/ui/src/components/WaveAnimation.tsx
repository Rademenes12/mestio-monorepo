"use client"

export function WaveAnimation() {
  return (
    <div className="absolute bottom-0 left-0 right-0 overflow-hidden pointer-events-none" style={{ height: "40%" }}>
      <svg
        viewBox="0 0 1440 320"
        preserveAspectRatio="none"
        className="absolute bottom-0 left-0 w-full"
        style={{
          transform: "scaleY(3) scaleX(2.25)",
          transformOrigin: "bottom center"
        }}
      >
        <path
          fill="none"
          stroke="rgba(136, 100, 240, 0.3)"
          strokeWidth="1.5"
        >
          <animate
            attributeName="d"
            dur="10s"
            repeatCount="indefinite"
            values="
              M0,160 C120,180 240,140 360,160 C480,180 600,140 720,155 C840,170 960,145 1080,158 C1200,170 1320,140 1440,155 L1440,320 L0,320 Z;
              M0,140 C120,150 240,170 360,145 C480,125 600,160 720,140 C840,120 960,150 1080,135 C1200,120 1320,155 1440,140 L1440,320 L0,320 Z;
              M0,160 C120,180 240,140 360,160 C480,180 600,140 720,155 C840,170 960,145 1080,158 C1200,170 1320,140 1440,155 L1440,320 L0,320 Z
            "
          />
        </path>
        <path
          fill="rgba(136, 100, 240, 0.08)"
        >
          <animate
            attributeName="d"
            dur="8s"
            repeatCount="indefinite"
            values="
              M0,200 C200,170 400,220 600,185 C800,160 1000,210 1200,190 C1300,175 1400,205 1440,195 L1440,320 L0,320 Z;
              M0,180 C200,210 400,165 600,200 C800,225 1000,170 1200,195 C1300,210 1400,175 1440,190 L1440,320 L0,320 Z;
              M0,200 C200,170 400,220 600,185 C800,160 1000,210 1200,190 C1300,175 1400,205 1440,195 L1440,320 L0,320 Z
            "
          />
        </path>
      </svg>
    </div>
  )
}
