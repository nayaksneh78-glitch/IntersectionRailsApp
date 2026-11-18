import { Link, useParams } from "react-router-dom";
import { googleMapsUrl } from "../api/guide";
import { LoadState } from "../components/LoadState";
import { SiteHeader } from "../components/SiteHeader";
import { usePropertyGuide } from "../hooks/usePropertyGuide";

export function CityGemPage() {
  const { propertyId: rawPropertyId, cityGemId: rawCityGemId } = useParams();
  const propertyId = Number(rawPropertyId);
  const cityGemId = Number(rawCityGemId);
  const { guide, error } = usePropertyGuide(propertyId);

  if (!Number.isInteger(propertyId) || propertyId < 1 || !Number.isInteger(cityGemId)) {
    return <><SiteHeader /><main className="shell"><p className="empty">Place not found.</p></main></>;
  }
  if (error || !guide) {
    return <><SiteHeader showPropertySwitch /><main className="shell"><LoadState error={error} /></main></>;
  }

  const gem = guide.cityGems.find((item) => item.id === cityGemId);
  if (!gem) {
    return <><SiteHeader showPropertySwitch /><main className="shell"><p className="empty">Place not found.</p></main></>;
  }

  const directMapsUrl =
    /^https:\/\/(?:maps\.app\.goo\.gl\/|goo\.gl\/maps\/)[A-Za-z0-9]+$/.test(gem.location);

  return (
    <>
      <SiteHeader showPropertySwitch />
      <main className="shell">
        <article className="detail">
          <Link className="text-link" to={`/properties/${guide.property.id}`}>← Back to places</Link>
          <header>
            <p className="eyebrow">{gem.category.title} · {gem.neighbourhood.title}</p>
            <h1>{gem.title}</h1>
            <p className="intro">{gem.short_desc}</p>
          </header>
          {gem.image && (
            <img
              alt=""
              className="detail-image"
              referrerPolicy="no-referrer"
              src={gem.image}
            />
          )}
          {gem.long_desc && <div className="description">{gem.long_desc}</div>}
          {!directMapsUrl && <p>{gem.location}</p>}
          <p className="tag">#{gem.tag.hashtag}</p>
          <a
            className="button"
            href={googleMapsUrl(gem)}
            rel="noopener noreferrer"
            target="_blank"
          >
            Open in Google Maps ↗
          </a>
        </article>
      </main>
    </>
  );
}
