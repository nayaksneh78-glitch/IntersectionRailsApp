import { Link } from "react-router-dom";

interface SiteHeaderProps {
  showPropertySwitch?: boolean;
}

export function SiteHeader({ showPropertySwitch = false }: SiteHeaderProps) {
  return (
    <header className="masthead">
      <div className="shell masthead-inner">
        <Link className="wordmark" to="/">InterSection</Link>
        {showPropertySwitch && (
          <Link className="switch" to="/properties?select=1">Change property</Link>
        )}
      </div>
    </header>
  );
}
