// Layout components
export { Sidebar } from './components/Sidebar'
export type { NavItem } from './components/Sidebar'
export { Navbar } from './components/Navbar'
export type { SubmenuItem } from './components/Navbar'
export { Footer } from './components/Footer'

// Auth components
export { LoginForm } from './components/LoginForm'
export type { LoginFormProps } from './components/LoginForm'
export { SignupForm } from './components/SignupForm'
export type { SignupFormProps } from './components/SignupForm'

// UI components
export { WaveAnimation } from './components/WaveAnimation'
export { Card } from './components/Card'
export { StatusBadge } from './components/StatusBadge'

// Hooks
export { useWebGLBackground } from './hooks/useWebGLBackground'

// Sanitization utilities
export {
  sanitizeHtml,
  sanitizeSql,
  validateEmail,
  validateUrl,
  escapeAttr,
} from './lib/sanitize'
