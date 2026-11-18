import { BrowserRouter, Route, Routes } from "react-router-dom";
import { CityGemPage } from "./pages/CityGemPage";
import { PropertyGuidePage } from "./pages/PropertyGuidePage";
import { PropertyIndexPage } from "./pages/PropertyIndexPage";
import "./styles.css";

function NotFoundPage() {
  return (
    <>
      <header className="masthead">
        <div className="shell masthead-inner">
          <a className="wordmark" href="/">InterSection</a>
        </div>
      </header>
      <main className="shell"><p className="empty">Page not found.</p></main>
    </>
  );
}

export default function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<PropertyIndexPage />} />
        <Route path="/properties" element={<PropertyIndexPage />} />
        <Route path="/properties/:propertyId" element={<PropertyGuidePage />} />
        <Route path="/properties/:propertyId/city_gems/:cityGemId" element={<CityGemPage />} />
        <Route path="*" element={<NotFoundPage />} />
      </Routes>
    </BrowserRouter>
  );
}
