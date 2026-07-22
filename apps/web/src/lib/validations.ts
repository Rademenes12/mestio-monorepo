import { z } from "zod";

function isValidNip(nip: string): boolean {
  const digits = nip.replace(/\D/g, "");
  if (digits.length !== 10) return false;
  const weights = [6, 5, 7, 2, 3, 4, 5, 6, 7];
  let sum = 0;
  for (let i = 0; i < 9; i++) {
    sum += parseInt(digits[i]) * weights[i];
  }
  const checksum = sum % 11;
  return checksum !== 10 && checksum === parseInt(digits[9]);
}

export const registrationSchema = z.object({
  email: z.string().email("Nieprawidłowy adres e-mail").max(255),
  password: z
    .string()
    .min(8, "Hasło musi mieć min. 8 znaków")
    .max(72, "Hasło nie może przekraczać 72 znaków"),
  companyName: z
    .string()
    .min(2, "Nazwa firmy musi mieć min. 2 znaki")
    .max(120, "Nazwa firmy nie może przekraczać 120 znaków"),
  nip: z
    .string()
    .regex(
      /^\d{3}-\d{3}-\d{2}-\d{2}$|^\d{10}$/,
      "Nieprawidłowy format NIP (np. 000-000-00-00)"
    )
    .max(13)
    .refine(isValidNip, "Nieprawidłowy NIP — sprawdź sumę kontrolną"),
  contactName: z
    .string()
    .min(2, "Imię i nazwisko wymagane")
    .max(120, "Maksymalnie 120 znaków"),
  phone: z
    .string()
    .min(7, "Numer telefonu wymagany")
    .max(20)
    .regex(
      /^[+\d][\d\s-]{6,}$/,
      "Nieprawidłowy format telefonu (np. +48 600 000 000)"
    ),
  estateName: z
    .string()
    .min(3, "Nazwa osiedla musi mieć min. 3 znaki")
    .max(120, "Maksymalnie 120 znaków"),
  plan: z.enum(["start", "standard", "pro", "enterprise"]),
  acceptRegulamin: z.literal(true, {
    message: "Musisz zaakceptować regulamin",
  }),
  acceptRodo: z.literal(true, {
    message: "Musisz zaakceptować politykę prywatności",
  }),
  acceptNoWithdrawal: z.literal(true, {
    message: "Musisz potwierdzić brak prawa odstąpienia",
  }),
});

export type RegistrationInput = z.infer<typeof registrationSchema>;

export const contactSchema = z.object({
  name: z.string().min(2, "Imię i nazwisko wymagane").max(120),
  email: z.string().email("Nieprawidłowy adres e-mail").max(255),
  message: z
    .string()
    .min(10, "Wiadomość musi mieć min. 10 znaków")
    .max(2000, "Maksymalnie 2000 znaków"),
  acceptRodo: z.literal(true, {
    message: "Musisz zaakceptować politykę prywatności",
  }),
});

export const newsletterSchema = z.object({
  email: z.string().email("Nieprawidłowy adres e-mail").max(255),
  acceptRodo: z.literal(true, {
    message: "Musisz zaakceptować politykę prywatności",
  }),
});

export const crmBlogPostSchema = z.object({
  title: z.string().min(3, "Title must be at least 3 characters"),
  slug: z
    .string()
    .min(3)
    .regex(
      /^[a-z0-9]+(?:-[a-z0-9]+)*$/,
      "Slug must be lowercase with hyphens"
    ),
  content: z.string().min(50, "Content must be at least 50 characters"),
  excerpt: z
    .string()
    .min(10, "Excerpt must be at least 10 characters")
    .max(300, "Excerpt must not exceed 300 characters"),
  cover_image: z.string().url("Invalid URL").optional(),
  author_name: z
    .string()
    .min(2, "Author name must be at least 2 characters"),
  published_at: z.string().optional(),
  tags: z.array(z.string()).optional(),
  status: z.enum(["draft", "published"]).default("published"),
});

export type CrmBlogPostInput = z.infer<typeof crmBlogPostSchema>;
