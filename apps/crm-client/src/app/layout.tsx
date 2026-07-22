import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
title: "Mestio — Panel Zarządu",
description: "Zarządzanie osiedlem — zgłoszenia, kontakty, zadania, komunikaty",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="pl" className="h-full antialiased">
      <body className="min-h-full font-body bg-paper">{children}</body>
    </html>
  );
}
