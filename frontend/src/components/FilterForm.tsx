import { useEffect, useState, type FormEvent } from "react";
import { Link, useSearchParams } from "react-router-dom";
import type { Category, Neighbourhood, Tag } from "../types";

interface FilterFormProps {
  categories: Category[];
  tags: Tag[];
  neighbourhoods: Neighbourhood[];
}

export function FilterForm({ categories, tags, neighbourhoods }: FilterFormProps) {
  const [searchParams, setSearchParams] = useSearchParams();
  const [categoryId, setCategoryId] = useState(searchParams.get("category_id") ?? "");
  const [tagId, setTagId] = useState(searchParams.get("tag_id") ?? "");
  const [neighbourhoodId, setNeighbourhoodId] = useState(
    searchParams.get("neighbourhood_id") ?? "",
  );

  useEffect(() => {
    setCategoryId(searchParams.get("category_id") ?? "");
    setTagId(searchParams.get("tag_id") ?? "");
    setNeighbourhoodId(searchParams.get("neighbourhood_id") ?? "");
  }, [searchParams]);

  function applyFilters(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    const next = new URLSearchParams();
    if (categoryId) next.set("category_id", categoryId);
    if (tagId) next.set("tag_id", tagId);
    if (neighbourhoodId) next.set("neighbourhood_id", neighbourhoodId);
    setSearchParams(next);
  }

  const hasFilters = categoryId || tagId || neighbourhoodId;

  return (
    <form className="filters" onSubmit={applyFilters}>
      <div>
        <label htmlFor="category_id">Category</label>
        <select id="category_id" value={categoryId} onChange={(event) => setCategoryId(event.target.value)}>
          <option value="">All categories</option>
          {categories.map((category) => (
            <option key={category.id} value={category.id}>{category.title}</option>
          ))}
        </select>
      </div>
      <div>
        <label htmlFor="tag_id">Tag</label>
        <select id="tag_id" value={tagId} onChange={(event) => setTagId(event.target.value)}>
          <option value="">All tags</option>
          {tags.map((tag) => <option key={tag.id} value={tag.id}>{tag.title}</option>)}
        </select>
      </div>
      <div>
        <label htmlFor="neighbourhood_id">Neighbourhood</label>
        <select
          id="neighbourhood_id"
          value={neighbourhoodId}
          onChange={(event) => setNeighbourhoodId(event.target.value)}
        >
          <option value="">All neighbourhoods</option>
          {neighbourhoods.map((neighbourhood) => (
            <option key={neighbourhood.id} value={neighbourhood.id}>{neighbourhood.title}</option>
          ))}
        </select>
      </div>
      <button className="button" type="submit">Apply filters</button>
      {hasFilters && <Link className="reset" to=".">Clear</Link>}
    </form>
  );
}
