import { getPlansLive } from "@/lib/pricing";
import PricingSectionClient from "./PricingSectionClient";

export default async function PricingSection() {
  const plans = await getPlansLive();
  return <PricingSectionClient plans={plans} />;
}
