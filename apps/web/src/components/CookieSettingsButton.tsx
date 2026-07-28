"use client";

export default function CookieSettingsButton() {
  return (
    <button
      type="button"
      onClick={() => {
        localStorage.removeItem("cookie-consent");
        window.dispatchEvent(new Event("cookie-consent-changed"));
        window.location.reload();
      }}
      className="text-[13.5px] text-[#C7D2E0] hover:text-white text-left cursor-pointer transition-colors"
    >
      Ustawienia cookie
    </button>
  );
}
