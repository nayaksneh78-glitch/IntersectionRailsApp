import type { ReactNode } from "react";

interface HeroProps {
  eyebrow?: string;
  children?: ReactNode;
}

export function Hero({ eyebrow, children }: HeroProps) {
  return (
    <section className="hero">
      {eyebrow && <p className="eyebrow">{eyebrow}</p>}
      <h1>Explore your neighbourhood.</h1>
      {children}
    </section>
  );
}
