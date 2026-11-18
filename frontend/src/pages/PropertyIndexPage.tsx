import { useEffect, useState } from "react";
import { useNavigate, useSearchParams } from "react-router-dom";
import { getProperties } from "../api/guide";
import { Hero } from "../components/Hero";
import { LoadState } from "../components/LoadState";
import { PropertyCard } from "../components/PropertyCard";
import { SiteHeader } from "../components/SiteHeader";
import type { Property } from "../types";

export function PropertyIndexPage() {
  const [properties, setProperties] = useState<Property[] | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [searchParams] = useSearchParams();
  const navigate = useNavigate();

  useEffect(() => {
    let active = true;
    getProperties().then(
      (result) => {
        if (active) setProperties(result);
      },
      (reason: unknown) => {
        if (active) {
          setError(reason instanceof Error ? reason.message : "Properties could not be loaded.");
        }
      },
    );
    return () => {
      active = false;
    };
  }, []);

  useEffect(() => {
    if (properties?.length === 1 && !searchParams.has("select")) {
      navigate(`/properties/${properties[0].id}`, { replace: true });
    }
  }, [navigate, properties, searchParams]);

  return (
    <>
      <SiteHeader />
      <main className="shell">
        <Hero>
          <p>Choose where you’re staying to discover nearby places.</p>
        </Hero>
        {error ? <LoadState error={error} /> : properties === null ? (
          <LoadState error={null} />
        ) : properties.length ? (
          <ul aria-label="Properties" className="cards">
            {properties.map((property) => <PropertyCard key={property.id} property={property} />)}
          </ul>
        ) : (
          <p className="empty">No property guides are available yet.</p>
        )}
      </main>
    </>
  );
}
