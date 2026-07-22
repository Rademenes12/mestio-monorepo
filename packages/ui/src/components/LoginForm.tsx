"use client"

import { useState, useRef } from 'react'
import Link from 'next/link'
import { Eye, EyeOff, Loader2 } from 'lucide-react'
import { useWebGLBackground } from '../hooks/useWebGLBackground'
import { WaveAnimation } from './WaveAnimation'

export interface LoginFormProps {
  onSignIn: (email: string, password: string) => Promise<{ error?: Error | null }>
  redirectAfterLogin?: string
  registerHref?: string
  resetPasswordHref?: string
  enableWebGL?: boolean
  enableWaves?: boolean
}

export function LoginForm({
  onSignIn,
  redirectAfterLogin = '/dashboard',
  registerHref = '/register',
  resetPasswordHref = '/reset-password',
  enableWebGL = true,
  enableWaves = true,
}: LoginFormProps) {
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [showPassword, setShowPassword] = useState(false)
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')
  const canvasRef = useRef<HTMLCanvasElement>(null)

  // Clip 6: WebGL particle background
  if (enableWebGL) useWebGLBackground(canvasRef)

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setLoading(true)
    setError('')
    try {
      const result = await onSignIn(email, password)
      if (result?.error) throw result.error
      // Redirect handled by parent (next/navigation useRouter)
      if (typeof window !== 'undefined') {
        window.location.href = redirectAfterLogin
      }
    } catch (err: any) {
      setError(err.message || 'Błąd logowania')
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="min-h-screen flex items-center justify-center p-4 relative overflow-hidden">
      {/* Clip 6: WebGL Canvas Background */}
      {enableWebGL && (
        <canvas
          ref={canvasRef}
          className="absolute inset-0 w-full h-full"
          style={{ position: 'fixed', top: 0, left: 0, zIndex: 0 }}
        />
      )}

      <div className="relative z-10 w-full max-w-md">
        {/* Logo */}
        <div className="text-center mb-8">
          <div className="w-16 h-16 bg-gradient-to-br from-[#8864f0] to-[#4da3ff] rounded-2xl mx-auto mb-4 shadow-lg shadow-[#8864f0]/25" />
          <h1
            className="text-2xl font-bold"
            style={{
              background: "linear-gradient(160deg, #ffffff 20%, #85c8ff)",
              WebkitBackgroundClip: "text",
              WebkitTextFillColor: "transparent",
            }}
          >
            Mestio
          </h1>
          <p className="text-white/50 mt-2 text-sm">Zaloguj się do panelu</p>
        </div>

        {/* Clip 6+7: Glassmorphism login card with SVG waves */}
        <div className="relative rounded-[40px] p-8 md:p-12 overflow-hidden"
          style={{
            background: "linear-gradient(#1c182b, #2d2546)",
            backdropFilter: "blur(28px) saturate(160%)",
            border: "1px solid rgba(40, 140, 255, 0.16)",
            boxShadow: "inset 0 1px 0 rgba(255,255,255,0.05), 0 48px 96px -24px rgba(0,0,0,0.5)"
          }}
        >
          {/* Clip 7: SVG Animated Waves at bottom */}
          {enableWaves && <WaveAnimation />}

          <form onSubmit={handleSubmit} className="space-y-5 relative z-10">
            {error && (
              <div className="p-3 bg-red-500/10 border border-red-500/30 rounded-lg text-red-400 text-sm">
                {error}
              </div>
            )}

            {/* Icon-decorated Email Input with floating labels */}
            <div className="relative">
              <div className="relative flex items-center border-b border-white/10 focus-within:border-[#8864f0] transition-colors">
                <svg className="absolute left-0 w-5 h-5 text-white/40 pointer-events-none" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round">
                  <rect width="20" height="16" x="2" y="4" rx="2" />
                  <path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7" />
                </svg>
                <input
                  type="email"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  className="w-full bg-transparent py-3 pl-8 pr-2 text-sm text-white placeholder-transparent focus:outline-none"
                  placeholder="Email"
                  required
                  id="login-email"
                />
                <label
                  htmlFor="login-email"
                  className="absolute left-8 top-1/2 text-white/50 text-sm pointer-events-none transition-all duration-200 ease-[cubic-bezier(0.16,1,0.3,1)] origin-left"
                  style={{
                    transform: email ? 'translateY(-28px) scale(0.725)' : 'translateY(-50%)',
                    transformOrigin: "0 50%",
                  }}
                >
                  Email
                </label>
              </div>
            </div>

            {/* Icon-decorated Password Input with floating labels */}
            <div className="relative">
              <div className="relative flex items-center border-b border-white/10 focus-within:border-[#8864f0] transition-colors">
                <svg className="absolute left-0 w-5 h-5 text-white/40 pointer-events-none" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round">
                  <rect width="18" height="11" x="3" y="11" rx="2" ry="2" />
                  <path d="M7 11V7a5 5 0 0 1 10 0v4" />
                </svg>
                <input
                  type={showPassword ? 'text' : 'password'}
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  className="w-full bg-transparent py-3 pl-8 pr-12 text-sm text-white placeholder-transparent focus:outline-none"
                  placeholder="Hasło"
                  required
                  id="login-password"
                />
                <label
                  htmlFor="login-password"
                  className="absolute left-8 top-1/2 text-white/50 text-sm pointer-events-none transition-all duration-200 ease-[cubic-bezier(0.16,1,0.3,1)] origin-left"
                  style={{
                    transform: password ? 'translateY(-28px) scale(0.725)' : 'translateY(-50%)',
                    transformOrigin: "0 50%",
                  }}
                >
                  Hasło
                </label>
                <button
                  type="button"
                  onClick={() => setShowPassword(!showPassword)}
                  className="absolute right-0 top-1/2 -translate-y-1/2 text-white/30 hover:text-white/60 transition"
                >
                  {showPassword ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
                </button>
              </div>
            </div>

            {/* Remember + Forgot */}
            <div className="flex items-center justify-between text-sm">
              <label className="flex items-center gap-2 text-white/50 cursor-pointer">
                <input type="checkbox" className="rounded border-white/20 bg-white/5 accent-[#8864f0]" />
                Zapamiętaj mnie
              </label>
              <Link href={resetPasswordHref} className="text-[#8864f0] hover:text-[#7854e0] transition text-xs">
                Zapomniałeś hasła?
              </Link>
            </div>

            {/* Hover-animated Submit Button (text slides + arrow appears) */}
            <button
              type="submit"
              disabled={loading}
              className="w-full relative overflow-hidden py-3 bg-[#8864f0] hover:bg-[#7854e0] rounded-xl font-medium transition-all duration-200 ease-[cubic-bezier(0.16,1,0.3,1)] disabled:opacity-50 active:scale-[0.98]"
            >
              <span className="relative z-10 flex items-center justify-center gap-2">
                {loading ? (
                  <>
                    <Loader2 className="w-4 h-4 animate-spin" />
                    Logowanie...
                  </>
                ) : (
                  <>
                    <span className="transition-transform duration-300 group-hover:-translate-x-2">
                      Zaloguj się
                    </span>
                    <span className="absolute right-8 opacity-0 transition-all duration-300 group-hover:opacity-100 group-hover:translate-x-1">
                      →
                    </span>
                  </>
                )}
              </span>
            </button>
          </form>

          {/* Divider */}
          <div className="relative z-10 flex items-center gap-3 my-5">
            <div className="flex-1 h-px bg-white/10" />
            <span className="text-white/30 text-xs uppercase tracking-wider">lub</span>
            <div className="flex-1 h-px bg-white/10" />
          </div>

          {/* SSO Grid (Google + Apple) */}
          <div className="relative z-10 grid grid-cols-2 gap-3">
            <button className="flex items-center justify-center gap-2 py-2.5 bg-white/5 border border-white/10 hover:bg-white/10 rounded-xl transition active:scale-[0.98]">
              <svg className="w-4 h-4" viewBox="0 0 24 24">
                <path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92a5.06 5.06 0 0 1-2.2 3.32v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.1z"/>
                <path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/>
                <path fill="#FBBC05" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"/>
                <path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"/>
              </svg>
              <span className="text-xs text-white/70">Google</span>
            </button>
            <button className="flex items-center justify-center gap-2 py-2.5 bg-white/5 border border-white/10 hover:bg-white/10 rounded-xl transition active:scale-[0.98]">
              <svg className="w-4 h-4" viewBox="0 0 24 24" fill="currentColor">
                <path d="M18.71 19.5c-.83 1.24-1.71 2.45-3.05 2.47-1.34.03-1.77-.79-3.29-.79-1.53 0-2 .77-3.27.82-1.31.05-2.3-1.32-3.14-2.53C4.25 17 2.94 12.45 4.7 9.39c.87-1.52 2.43-2.48 4.12-2.51 1.28-.02 2.5.87 3.29.87.78 0 2.26-1.07 3.81-.91.65.03 2.47.26 3.64 1.98-.09.06-2.17 1.28-2.15 3.81.03 3.02 2.65 4.03 2.68 4.04-.03.07-.42 1.44-1.38 2.83M13 3.5c.73-.83 1.94-1.46 2.94-1.5.13 1.17-.34 2.35-1.04 3.19-.69.85-1.83 1.51-2.95 1.42-.15-1.15.41-2.35 1.05-3.11z"/>
              </svg>
              <span className="text-xs text-white/70">Apple</span>
            </button>
          </div>
        </div>

        <p className="text-center text-white/50 text-sm mt-6">
          Nie masz konta?{' '}
          <Link href={registerHref} className="text-[#8864f0] hover:text-[#7854e0] transition">
            Zarejestruj się
          </Link>
        </p>
      </div>
    </div>
  )
}
