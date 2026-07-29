import { colors } from "@mestio/design-tokens";

export default function PublishingHubPage() {
  return (
    <div className="space-y-6">
      <div>
        <h1 className="font-heading font-bold text-xl" style={{ color: colors.text }}>🚀 Automation Hub</h1>
        <p className="text-sm mt-1" style={{ color: colors.textMuted }}>
          Zarządzaj publikacjami, integracjami i automatyzacjami w jednym miejscu.
        </p>
      </div>

      <div className="grid grid-cols-3 gap-4">
        {[
          { title: "Blog", desc: "Publikuj i zarządzaj artykułami", href: "/owner/blog", color: "#3E7BD6" },
          { title: "Newsletter", desc: "Wysyłaj mailingi do mieszkańców", href: "/owner/newsletter", color: "#8B5CF6" },
          { title: "Automatyzacje", desc: "Reguły i workflow CRM", href: "/owner/automations", color: "#F2A900" },
          { title: "AI Asystent", desc: "Generowanie treści i analiz", href: "/owner/ai", color: "#22C55E" },
          { title: "Media społecznościowe", desc: "Planowanie postów", href: "#", color: "#EF4444" },
          { title: "Integracje", desc: "Trello, Slack, Zapier i więcej", href: "#", color: "#0E1A2B" },
        ].map((card) => (
          <a
            key={card.title}
            href={card.href}
            className="rounded-xl border p-6 transition-all hover:-translate-y-1 hover:shadow-lg"
            style={{ background: "#fff", borderColor: colors.cardBorder, boxShadow: "0 1px 3px rgba(14,26,43,.04)" }}
          >
            <div className="w-10 h-10 rounded-lg flex items-center justify-center mb-4" style={{ background: `${card.color}15` }}>
              <span className="text-lg">{
                card.title === "Blog" ? "📝" :
                card.title === "Newsletter" ? "📧" :
                card.title === "Automatyzacje" ? "⚡" :
                card.title === "AI Asystent" ? "🤖" :
                card.title === "Media społecznościowe" ? "📱" : "🔌"
              }</span>
            </div>
            <h3 className="font-heading font-semibold text-sm mb-1" style={{ color: colors.text }}>{card.title}</h3>
            <p className="text-xs" style={{ color: colors.textMuted }}>{card.desc}</p>
          </a>
        ))}
      </div>
    </div>
  );
}
