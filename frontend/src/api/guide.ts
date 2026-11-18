import { getCollection, getRecord } from "./client";
import type {
  Category,
  CityGem,
  GuideGem,
  Neighbourhood,
  Property,
  PropertyGuide,
  PropertyNeighbourhood,
  Tag,
} from "../types";

function compareRecords<T extends { title: string; id: number }>(left: T, right: T) {
  return left.title.localeCompare(right.title) || left.id - right.id;
}

export async function getProperties(): Promise<Property[]> {
  return (await getCollection<Property>("properties")).sort(compareRecords);
}

export async function getPropertyGuide(propertyId: number): Promise<PropertyGuide> {
  const [property, assignments, allNeighbourhoods, allGems, allCategories, allTags] =
    await Promise.all([
      getRecord<Property>("properties", propertyId),
      getCollection<PropertyNeighbourhood>("property_neighbourhoods"),
      getCollection<Neighbourhood>("neighbourhoods"),
      getCollection<CityGem>("city_gems"),
      getCollection<Category>("categories"),
      getCollection<Tag>("tags"),
    ]);

  const neighbourhoodById = new Map(allNeighbourhoods.map((item) => [item.id, item]));
  const neighbourhoods = assignments
    .filter((item) => item.property_id === propertyId && item.published)
    .map((item) => neighbourhoodById.get(item.neighbourhood_id))
    .filter((item): item is Neighbourhood => item !== undefined && item.published)
    .sort(compareRecords);
  const neighbourhoodIds = new Set(neighbourhoods.map((item) => item.id));
  const categoriesById = new Map(allCategories.map((item) => [item.id, item]));
  const tagsById = new Map(allTags.map((item) => [item.id, item]));

  const cityGems = allGems
    .filter((gem) => gem.published && neighbourhoodIds.has(gem.neighbourhood_id))
    .sort(compareRecords)
    .filter((gem, index, list) =>
      list.findIndex((candidate) =>
        candidate.title === gem.title && candidate.location === gem.location,
      ) === index,
    )
    .flatMap((gem): GuideGem[] => {
      const category = categoriesById.get(gem.category_id);
      const tag = tagsById.get(gem.tag_id);
      const neighbourhood = neighbourhoodById.get(gem.neighbourhood_id);
      return category && tag && neighbourhood
        ? [{ ...gem, category, tag, neighbourhood }]
        : [];
    });

  const categoryIds = new Set(cityGems.map((gem) => gem.category_id));
  const tagIds = new Set(cityGems.map((gem) => gem.tag_id));

  return {
    property,
    neighbourhoods,
    categories: allCategories.filter((item) => categoryIds.has(item.id)).sort(compareRecords),
    tags: allTags.filter((item) => tagIds.has(item.id)).sort(compareRecords),
    cityGems,
  };
}

export function googleMapsUrl(gem: CityGem): string {
  if (/^https:\/\/(?:maps\.app\.goo\.gl\/|goo\.gl\/maps\/)[A-Za-z0-9]+$/.test(gem.location)) {
    return gem.location;
  }
  const query = new URLSearchParams({ api: "1", query: `${gem.title}, ${gem.location}` });
  return `https://www.google.com/maps/search/?${query}`;
}
