import { useMemo } from "react";
import { useParams, useSearchParams } from "react-router-dom";
import { CityGemCard } from "../components/CityGemCard";
import { FilterForm } from "../components/FilterForm";
import { Hero } from "../components/Hero";
import { LoadState } from "../components/LoadState";
import { SiteHeader } from "../components/SiteHeader";
import { usePropertyGuide } from "../hooks/usePropertyGuide";

export function PropertyGuidePage() {
  const { propertyId: rawPropertyId } = useParams();
  const propertyId = Number(rawPropertyId);
  const { guide, error } = usePropertyGuide(propertyId);
  const [searchParams] = useSearchParams();

  const visibleGems = useMemo(() => {
    if (!guide) return [];
    const categoryId = searchParams.get("category_id");
    const tagId = searchParams.get("tag_id");
    const neighbourhoodId = searchParams.get("neighbourhood_id");
    return guide.cityGems.filter((gem) =>
      (!categoryId || String(gem.category_id) === categoryId) &&
      (!tagId || String(gem.tag_id) === tagId) &&
      (!neighbourhoodId || String(gem.neighbourhood_id) === neighbourhoodId),
    );
  }, [guide, searchParams]);

  if (!Number.isInteger(propertyId) || propertyId < 1) {
    return <><SiteHeader /><main className="shell"><p className="empty">Property not found.</p></main></>;
  }
  if (error || !guide) {
    return <><SiteHeader showPropertySwitch /><main className="shell"><LoadState error={error} /></main></>;
  }

  const hasFilters = ["category_id", "tag_id", "neighbourhood_id"]
    .some((key) => searchParams.has(key));

  return (
    <>
      <SiteHeader showPropertySwitch />
      <main className="shell">
        <Hero eyebrow={`Your guide from ${guide.property.title}`}>
          {guide.property.description && <p>{guide.property.description}</p>}
          {guide.property.address && <p>{guide.property.address}</p>}
        </Hero>
        <FilterForm
          categories={guide.categories}
          tags={guide.tags}
          neighbourhoods={guide.neighbourhoods}
        />
        <section aria-labelledby="places-title" className="listing">
          <div className="listing-heading">
            <h2 id="places-title">Places to explore</h2>
            <span>{visibleGems.length} {visibleGems.length === 1 ? "place" : "places"}</span>
          </div>
          {visibleGems.length ? (
            <ul className="cards">
              {visibleGems.map((gem) => (
                <CityGemCard key={gem.id} gem={gem} propertyId={guide.property.id} />
              ))}
            </ul>
          ) : (
            <p className="empty">
              {hasFilters
                ? "No places match these filters."
                : "This guide doesn’t have any published places yet."}
            </p>
          )}
        </section>
      </main>
    </>
  );
}
