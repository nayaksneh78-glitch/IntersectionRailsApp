export interface ApiRecord {
  id: number;
}

export interface Property extends ApiRecord {
  title: string;
  description: string | null;
  address: string | null;
}

export interface PropertyNeighbourhood extends ApiRecord {
  property_id: number;
  neighbourhood_id: number;
  published: boolean;
}

export interface Neighbourhood extends ApiRecord {
  title: string;
  description: string | null;
  tag_id: number;
  published: boolean;
}

export interface Category extends ApiRecord {
  title: string;
  description: string | null;
}

export interface Tag extends ApiRecord {
  title: string;
  hashtag: string;
  description: string | null;
}

export interface CityGem extends ApiRecord {
  title: string;
  short_desc: string;
  long_desc: string | null;
  image: string | null;
  location: string;
  tag_id: number;
  category_id: number;
  neighbourhood_id: number;
  published: boolean;
}

export interface GuideGem extends CityGem {
  category: Category;
  tag: Tag;
  neighbourhood: Neighbourhood;
}

export interface PropertyGuide {
  property: Property;
  neighbourhoods: Neighbourhood[];
  categories: Category[];
  tags: Tag[];
  cityGems: GuideGem[];
}
