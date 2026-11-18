const API_BASE_URL = (import.meta.env.VITE_API_BASE_URL ?? "/api/v1").replace(/\/+$/, "");
const PER_PAGE = 100;

interface CollectionResponse<T> {
  data: T[];
  page: number;
  per_page: number;
}

interface RecordResponse<T> {
  data: T;
}

interface ApiErrorResponse {
  error?: string;
  errors?: Record<string, string[]>;
}

async function request<T>(path: string): Promise<T> {
  const response = await fetch(`${API_BASE_URL}/${path}`);
  if (!response.ok) {
    let message = `API request failed (${response.status})`;
    try {
      const body = (await response.json()) as ApiErrorResponse;
      message = body.error ?? (Object.entries(body.errors ?? {})
        .map(([field, errors]) => `${field}: ${errors.join(", ")}`)
        .join("; ") || message);
    } catch {
      // Keep the HTTP status message when the server does not return JSON.
    }
    throw new Error(message);
  }
  return (await response.json()) as T;
}

export async function getCollection<T>(resource: string): Promise<T[]> {
  const records: T[] = [];
  let page = 1;

  while (true) {
    const query = new URLSearchParams({ page: String(page), per_page: String(PER_PAGE) });
    const result = await request<CollectionResponse<T>>(`${resource}?${query}`);
    records.push(...result.data);
    if (result.data.length < PER_PAGE) return records;
    page += 1;
  }
}

export async function getRecord<T>(resource: string, id: number): Promise<T> {
  const result = await request<RecordResponse<T>>(`${resource}/${id}`);
  return result.data;
}
