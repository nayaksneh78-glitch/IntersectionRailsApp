import { Link } from "react-router-dom";
import { googleMapsUrl } from "../api/guide";
import type { GuideGem } from "../types";

interface CityGemCardProps {
  gem: GuideGem;
  propertyId: number;
}

export function CityGemCard({ gem, propertyId }: CityGemCardProps) {
  return (
    <li className="card city-gem-card">
      {gem.image && (
        <img
          alt=""
          className="card-image"
          loading="lazy"
          referrerPolicy="no-referrer"
          src={gem.image}
        />
      )}
      {!gem.image && <div aria-hidden="true" className="card-image" />}
      <div className="card-body">
        <p className="eyebrow">{gem.category.title} · {gem.neighbourhood.title}</p>
        <h3>
          <Link to={`/properties/${propertyId}/city_gems/${gem.id}`}>{gem.title}</Link>
        </h3>
        <p>{gem.short_desc}</p>
        <div className="card-footer">
          <span>#{gem.tag.hashtag}</span>
          <a
            className="text-link"
            href={googleMapsUrl(gem)}
            rel="noopener noreferrer"
            target="_blank"
          >
            Google Maps ↗
          </a>
        </div>
      </div>
    </li>
  );
}
