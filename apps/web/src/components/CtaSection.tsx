import Link from "next/link";

export default function CtaSection() {
  return (
    <section className="max-w-[1160px] mx-auto px-6 pt-5 pb-[70px]">
      <div className="bg-gradient-to-br from-azure to-blueprint rounded-[24px] p-[52px] text-center shadow-[0_24px_50px_rgba(23,58,106,.28)]">
        <h2 className="font-heading font-bold text-[32px] text-white tracking-[-0.6px]">
          Gotowy uporządkować zgłoszenia?
        </h2>
        <p className="text-base text-white/80 mt-3">
          Uruchom Mestio dla swojego osiedla w kilka minut.
        </p>
        <Link
          href="/zamow"
          className="inline-block mt-6 text-base font-semibold text-blueprint bg-white px-[30px] py-[15px] rounded-[13px] hover:brightness-95 transition-all"
        >
          Zamów Mestio
        </Link>
        <p className="text-[13.5px] text-white/85 mt-[14px] font-medium">
          Pierwsze 3 miesiące gratis &middot; anuluj kiedy chcesz
        </p>
      </div>
    </section>
  );
}
