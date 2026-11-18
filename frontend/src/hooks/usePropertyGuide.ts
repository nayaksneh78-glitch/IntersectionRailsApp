import { useEffect, useState } from "react";
import { getPropertyGuide } from "../api/guide";
import type { PropertyGuide } from "../types";

export function usePropertyGuide(propertyId: number) {
  const [guide, setGuide] = useState<PropertyGuide | null>(null);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    let active = true;
    setGuide(null);
    setError(null);
    getPropertyGuide(propertyId).then(
      (result) => {
        if (active) setGuide(result);
      },
      (reason: unknown) => {
        if (active) {
          setError(reason instanceof Error ? reason.message : "The guide could not be loaded.");
        }
      },
    );
    return () => {
      active = false;
    };
  }, [propertyId]);

  return { guide, error };
}
