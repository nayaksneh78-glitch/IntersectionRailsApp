import { Link } from "react-router-dom";
import type { Property } from "../types";

interface PropertyCardProps {
  property: Property;
}

export function PropertyCard({ property }: PropertyCardProps) {
  return (
    <li className="card">
      <div className="card-body">
        <h2><Link to={`/properties/${property.id}`}>{property.title}</Link></h2>
        {property.description && <p>{property.description}</p>}
        <Link className="text-link" to={`/properties/${property.id}`}>Explore guide →</Link>
      </div>
    </li>
  );
}
