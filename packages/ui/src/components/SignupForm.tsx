"use client"

import { useState } from 'react'
import Link from 'next/link'
import { Eye, EyeOff, Loader2 } from 'lucide-react'

export interface SignupFormProps {
  onSignUp: (email: string, password: string) => Promise<{ error?: Error | null }>
  redirectAfterSignup?: string
  loginHref?: string
}

export function SignupForm({
  onSignUp,
  redirectAfterSignup = '/dashboard',
  loginHref = '/login',
}: SignupFormProps) {
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [showPassword, setShowPassword] = useState(false)
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setLoading(true)
    setError('')
    try {
      const result = await onSignUp(email, password)
      if (result?.error) throw result.error
      if (typeof window !== 'undefined') {
        window.location.href = redirectAfterSignup
      }
    } catch (err: any) {
      setError(err.message || 'Błąd rejestracji')
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="min-h-screen flex items-center justify-center p-4">
      {/* Background */}
      <div className="absolute inset-0">
        <div className="absolute inset-0 bg-gradient-to-br from-[#0a0a1a] via-[#1c182b] to-[#0a0a1a]" />
        <div className="absolute top-1/3 left-1/4 w-96 h-96 bg-[#8864f0]/10 rounded-full blur-3xl animate-pulse-slow" />
        <div className="absolute bottom-1/3 right-1/4 w-72 h-72 bg-[#4da3ff]/8 rounded-full blur-3xl animate-pulse-slow" />
      </div>

      {/* Clip 4: Split-panel card */}
      <div className="relative w-full max-w-[820px] flex flex-col md:flex-row overflow-hidden glass rounded-[24px] border border-white/10"
        style={{ backdropFilter: "blur(20px)", width: "clamp(320px, 90%, 820px)" }}
      >
        {/* LEFT: Hero Image Panel (Clip 4) */}
        <div className="hidden md:flex md:w-2/5 relative overflow-hidden rounded-l-[24px]">
          <div
            className="absolute inset-0"
            style={{
              background: "radial-gradient(ellipse at center, rgba(136,100,240,0.3) 0%, rgba(13, 12, 21, 0.95) 100%), linear-gradient(135deg, #1c182b, #2d2546)",
            }}
          />
          {/* Decorative elements */}
          <div className="absolute inset-0 flex items-center justify-center">
            <div className="w-24 h-24 rounded-full bg-gradient-to-br from-[#8864f0]/40 to-[#4da3ff]/20 blur-2xl animate-pulse-slow" />
            <div className="absolute w-16 h-16 bg-gradient-to-br from-[#8864f0] to-[#4da3ff] rounded-2xl shadow-lg" />
          </div>
          <div className="absolute bottom-8 left-8 right-8">
            <h3 className="text-white font-bold text-xl mb-2">Dołącz do Mestio</h3>
            <p className="text-white/50 text-sm">Profesjonalne zarządzanie nieruchomościami w jednym miejscu.</p>
          </div>
        </div>

        {/* RIGHT: Form Panel */}
        <div className="flex-1 p-8 md:p-10">
          <div className="max-w-sm mx-auto md:mx-0">
            {/* Mobile logo (visible only on mobile) */}
            <div className="flex md:hidden items-center gap-3 mb-6">
              <div className="w-10 h-10 bg-gradient-to-br from-[#8864f0] to-[#4da3ff] rounded-xl" />
              <span className="text-xl font-bold">Mestio</span>
            </div>

            <h2 className="text-2xl font-bold mb-1">Utwórz konto</h2>
            <p className="text-white/50 text-sm mb-6">Zacznij za darmo, bez karty kredytowej.</p>

            <form onSubmit={handleSubmit} className="space-y-4">
              {error && (
                <div className="p-3 bg-red-500/10 border border-red-500/30 rounded-lg text-red-400 text-sm">
                  {error}
                </div>
              )}

              {/* Email */}
              <div>
                <label className="block text-sm text-white/70 mb-2">Email</label>
                <div className="relative">
                  <svg className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-white/40 pointer-events-none" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                    <rect width="20" height="16" x="2" y="4" rx="2"/><path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"/>
                  </svg>
                  <input
                    type="email"
                    value={email}
                    onChange={(e) => setEmail(e.target.value)}
                    className="w-full pl-10 pr-4 py-2.5 bg-white/5 border border-white/10 rounded-lg text-sm focus:outline-none focus:border-[#8864f0] placeholder:text-white/30 transition-colors"
                    placeholder="jan@firma.pl"
                    required
                  />
                </div>
              </div>

              {/* Password */}
              <div>
                <label className="block text-sm text-white/70 mb-2">Hasło</label>
                <div className="relative">
                  <svg className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-white/40 pointer-events-none" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                    <rect width="18" height="11" x="3" y="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                  </svg>
                  <input
                    type={showPassword ? 'text' : 'password'}
                    value={password}
                    onChange={(e) => setPassword(e.target.value)}
                    className="w-full pl-10 pr-12 py-2.5 bg-white/5 border border-white/10 rounded-lg text-sm focus:outline-none focus:border-[#8864f0] placeholder:text-white/30 transition-colors"
                    placeholder="Minimum 6 znaków"
                    required
                    minLength={6}
                  />
                  <button
                    type="button"
                    onClick={() => setShowPassword(!showPassword)}
                    className="absolute right-3 top-1/2 -translate-y-1/2 text-white/40 hover:text-white/70 transition"
                  >
                    {showPassword ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
                  </button>
                </div>
              </div>

              {/* Submit */}
              <button
                type="submit"
                disabled={loading}
                className="w-full py-2.5 bg-gradient-to-r from-[#8864f0] to-[#7854e0] hover:from-[#7854e0] hover:to-[#6844d0] rounded-lg font-medium transition disabled:opacity-50 flex items-center justify-center gap-2 active:scale-[0.98]"
              >
                {loading ? (
                  <>
                    <Loader2 className="w-4 h-4 animate-spin" />
                    Tworzenie konta...
                  </>
                ) : (
                  'Utwórz konto'
                )}
              </button>
            </form>

            {/* CSS "Or" separator via pseudo-elements */}
            <div className="flex items-center gap-3 my-5">
              <div className="flex-1 h-px bg-white/10" />
              <span className="text-white/30 text-xs uppercase tracking-wider select-none">lub kontynuuj przez</span>
              <div className="flex-1 h-px bg-white/10" />
            </div>

            {/* Social login buttons */}
            <div className="grid grid-cols-2 gap-3">
              <button className="flex items-center justify-center gap-2 py-2.5 bg-white/5 border border-white/10 hover:bg-white/10 rounded-lg transition active:scale-[0.98]">
                <svg className="w-4 h-4" viewBox="0 0 24 24">
                  <path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92a5.06 5.06 0 0 1-2.2 3.32v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.1z"/>
                  <path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/>
                  <path fill="#FBBC05" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"/>
                  <path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"/>
                </svg>
                <span className="text-xs text-white/70">Google</span>
              </button>
              <button className="flex items-center justify-center gap-2 py-2.5 bg-white/5 border border-white/10 hover:bg-white/10 rounded-lg transition active:scale-[0.98]">
                <svg className="w-4 h-4" viewBox="0 0 24 24" fill="currentColor">
                  <path d="M18.71 19.5c-.83 1.24-1.71 2.45-3.05 2.47-1.34.03-1.77-.79-3.29-.79-1.53 0-2 .77-3.27.82-1.31.05-2.3-1.32-3.14-2.53C4.25 17 2.94 12.45 4.7 9.39c.87-1.52 2.43-2.48 4.12-2.51 1.28-.02 2.5.87 3.29.87.78 0 2.26-1.07 3.81-.91.65.03 2.47.26 3.64 1.98-.09.06-2.17 1.28-2.15 3.81.03 3.02 2.65 4.03 2.68 4.04-.03.07-.42 1.44-1.38 2.83M13 3.5c.73-.83 1.94-1.46 2.94-1.5.13 1.17-.34 2.35-1.04 3.19-.69.85-1.83 1.51-2.95 1.42-.15-1.15.41-2.35 1.05-3.11z"/>
                </svg>
                <span className="text-xs text-white/70">Apple</span>
              </button>
            </div>

            <p className="text-center text-white/50 text-sm mt-6">
              Masz już konto?{' '}
              <Link href={loginHref} className="text-[#8864f0] hover:text-[#7854e0] transition">
                Zaloguj się
              </Link>
            </p>
          </div>
        </div>
      </div>
    </div>
  )
}
