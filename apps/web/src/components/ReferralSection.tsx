import Link from "next/link";

export default function ReferralSection() {
  return (
    <section className="max-w-[1160px] mx-auto px-6 py-10">
      <div className="bg-gradient-to-br from-blueprint to-ink rounded-[24px] p-10 flex items-center justify-between gap-[30px] flex-wrap">
        <div className="max-w-[620px]">
          <span className="inline-flex items-center gap-[7px] px-3 py-[5px] rounded-full bg-amber/[.16] text-amber font-mono text-[11px] font-semibold">
            Program poleceń
          </span>
          <h2 className="font-heading font-bold text-[26px] text-white mt-[14px] tracking-[-0.4px]">
            Polecasz Mestio innemu zarządcy? Oboje zyskujecie.
          </h2>
          <p className="text-[15px] text-[#C7D2E0] mt-[10px] leading-relaxed">
            Za każde osiedle, które dołączy z Twojego polecenia, dostajesz{" "}
            <b className="text-white">1 miesiąc gratis</b>, a polecony — 20%
            zniżki na start przez pierwsze 6 miesięcy.
          </p>
        </div>
        <Link
          href="/zamow"
          className="text-[15px] font-semibold text-ink bg-white py-[14px] px-6 rounded-[13px] whitespace-nowrap hover:brightness-95 transition-all"
        >
          Zdobądź swój link
        </Link>
      </div>
    </section>
  );
}
