interface LoadStateProps {
  error: string | null;
}

export function LoadState({ error }: LoadStateProps) {
  return (
    <p className={error ? "error" : "loading"} role={error ? "alert" : "status"}>
      {error ?? "Loading guide…"}
    </p>
  );
}
