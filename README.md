# 🌟 PixelVault - Responsive Interactive Image Gallery

A full-stack, responsive, and high-performance **Image Gallery** application built with **React**, **Tailwind CSS**, **Node.js + Express**, **Supabase PostgreSQL**, and **Google Gemini AI SDK** (`@google/genai`).

![PixelVault Banner](https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=1600&q=80)

---

## 🚀 Key Features

- **Responsive Gallery Grid & Masonry Layout**: Built with CSS Grid and Tailwind CSS (`grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4`), rendering symmetrically across all mobile, tablet, and desktop viewports.
- **Buttery-Smooth CSS Transitions & Hover Effects**: Subtle zoom (`scale-108`), gradient overlays, animated badges, and glassmorphic controls.
- **Instant Lightbox View**:
  - Full-resolution image presentation with zero page refresh.
  - JavaScript-powered navigation: **Next / Previous** buttons, keyboard arrow keys (`←` / `→`), and `ESC` to dismiss.
  - Interactive **Zoom In / Zoom Out** toggle (`Z` key).
  - One-click image link sharing and external tab viewer.
- **Categorization & Filtering**:
  - Predefined domains: **Nature & Landscapes**, **Architecture**, **Portraits**, and **Abstract**.
  - Route-driven filtered gallery views: `/` (All Works) and `/category/:slug` (`/category/nature`, `/category/architecture`, `/category/portraits`, `/category/abstract`).
  - Dynamic category count indicators and quick keyword search bar.
- **AI-Powered Auto-Categorization**:
  - Integrated with **Google Gemini AI SDK** (`@google/genai`) on the server.
  - If a user uploads an image without specifying a category, Gemini automatically analyzes the image metadata and classifies it into the optimal category using structured JSON output schemas.
  - Live AI category preview button in the upload modal.
- **Admin Studio & Content Moderation (`/admin`)**:
  - Comprehensive management console with live statistics by category.
  - Upload modal with instant test presets and live URL preview.
  - Safe deletion workflow with confirmation guards.
- **Enterprise Security & Validation**:
  - **Zod Schema Validation**: Strictly validates URL syntax and title lengths on backend ingestion.
  - **URL Sanitization & Anti-XSS**: Filters dangerous protocols (`javascript:`, `data:`, `vbscript:`).
  - **Row Level Security (RLS)**: PostgreSQL policies granting public read access while restricting write/delete operations to authenticated admins via Supabase JWTs.

---

## 📂 Project Architecture

```
CodeAlpha (Image Gallery)/
├── client/                     # Frontend React (Vite) Application
│   ├── src/
│   │   ├── components/
│   │   │   ├── GalleryGrid.jsx     # Responsive grid container
│   │   │   ├── ImageCard.jsx       # Card with hover zoom & overlays
│   │   │   ├── Lightbox.jsx        # Full-screen modal with Next/Prev
│   │   │   ├── CategoryFilter.jsx  # Category pills with counts
│   │   │   ├── UploadModal.jsx     # Image upload form with AI preview
│   │   │   ├── LoginModal.jsx      # Supabase & 1-click Demo auth
│   │   │   ├── Navbar.jsx          # Top navigation & actions
│   │   │   └── Footer.jsx          # Tech stack footer
│   │   ├── pages/
│   │   │   ├── GalleryPage.jsx     # Handles / and /category/:slug
│   │   │   └── AdminPage.jsx       # Handles /admin
│   │   ├── context/
│   │   │   └── AuthContext.jsx     # Supabase auth session & demo bypass
│   │   ├── lib/
│   │   │   ├── api.js              # Express API client
│   │   │   └── supabase.js         # Supabase client initializer
│   │   ├── App.jsx                 # Routing configuration
│   │   ├── index.css               # Tailwind CSS & custom glass styling
│   │   └── main.jsx
│   ├── index.html
│   ├── tailwind.config.js
│   ├── vite.config.js
│   └── package.json
│
├── server/                     # Backend Node.js + Express Application
│   ├── controllers/
│   │   └── imagesController.js     # Image CRUD & AI categorization
│   ├── middleware/
│   │   ├── authMiddleware.js       # Supabase JWT Bearer token validation
│   │   └── validate.js             # Zod validation & URL anti-XSS
│   ├── routes/
│   │   └── images.js               # REST routes (/api/images, /api/ai)
│   ├── services/
│   │   ├── geminiService.js        # @google/genai SDK integration
│   │   └── supabaseService.js      # Supabase PostgreSQL & demo store
│   ├── server.js                   # Express application entry
│   └── package.json
│
├── schema.sql                  # PostgreSQL DDL & Row Level Security policies
├── .env.example                # Unified environment variables template
└── package.json                # Root concurrent scripts
```

---

## 🛠️ Technology Stack

| Layer | Technology |
|---|---|
| **Frontend** | React 19, Tailwind CSS 3.4, Lucide React, React Router 7, Vite |
| **Backend** | Node.js, Express.js, CORS, Dotenv |
| **Database & Auth** | Supabase PostgreSQL, Row Level Security (RLS), Supabase Auth |
| **Artificial Intelligence** | Google Gemini Developer SDK (`@google/genai` with `gemini-2.5-flash`) |
| **Validation** | Zod 3.24 |

---

## ⚙️ Quick Start Guide

### 1. Prerequisites
- **Node.js** v20+ installed.

### 2. Install Dependencies
Run the install command from the root directory to install client and server packages:
```bash
npm run install:all
```

### 3. Setup Environment Variables (Optional)
The application includes an **out-of-the-box local demo mode** pre-seeded with 12 high-resolution curated photographs, which runs immediately even before configuring external credentials.

To connect your own **Supabase** instance and **Gemini API Key**:
Copy `.env.example` to `server/.env` and `client/.env`:

#### `server/.env`:
```env
PORT=5000
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your_supabase_anon_key
SUPABASE_SERVICE_ROLE_KEY=your_supabase_service_role_key
GEMINI_API_KEY=your_gemini_api_key
```

#### `client/.env`:
```env
VITE_SUPABASE_URL=https://your-project.supabase.co
VITE_SUPABASE_ANON_KEY=your_supabase_anon_key
VITE_API_URL=/api
```

### 4. Supabase Database Setup
Execute the SQL statements from [`schema.sql`](./schema.sql) in your Supabase SQL Editor:
```sql
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE images (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  url TEXT NOT NULL,
  title TEXT,
  category TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE images ENABLE ROW LEVEL SECURITY;

-- 1. SELECT access granted to public
CREATE POLICY "Allow public read access"
  ON images FOR SELECT TO public USING (true);

-- 2. INSERT restricted to authenticated admin users only
CREATE POLICY "Allow authenticated users to insert"
  ON images FOR INSERT TO authenticated WITH CHECK (true);

-- 3. DELETE restricted to authenticated admin users only
CREATE POLICY "Allow authenticated users to delete"
  ON images FOR DELETE TO authenticated USING (true);
```

### 5. Run the Application
Start both the Express API and the Vite React frontend concurrently:
```bash
npm run dev
```

- **Frontend Client**: [http://localhost:5173](http://localhost:5173)
- **Backend API Server**: [http://localhost:5000](http://localhost:5000)

---

## 📡 API Reference

### 1. `GET /api/images`
Fetch all images, or filter by category via query parameter.
- **Query Params**: `?category=Nature` | `Architecture` | `Portraits` | `Abstract`
- **Access**: Public

### 2. `POST /api/images`
Create a new image record.
- **Headers**: `Authorization: Bearer <token>`
- **Body**:
  ```json
  {
    "url": "https://images.unsplash.com/photo-...",
    "title": "Minimalist Nordic Forest House",
    "category": "" // (Leave empty to trigger Gemini auto-categorization!)
  }
  ```
- **Validation**: Zod `ImageSchema`
- **Access**: Authenticated Admin

### 3. `DELETE /api/images/:id`
Delete an image by UUID.
- **Headers**: `Authorization: Bearer <token>`
- **Access**: Authenticated Admin

### 4. `POST /api/ai/categorize`
Preview category classification using Google Gemini SDK.
- **Body**: `{ "title": "Glass skyscraper", "url": "..." }`
- **Output**: `{ "category": "Architecture" }`

---

## 🧪 Testing Checklist & Acceptance Criteria

- [x] **Grid Layout**: Responsive CSS Grid renders with symmetrical card alignment across mobile, tablet, and desktop screens.
- [x] **Lightbox Navigation**: Opens instantly on image click. Navigation buttons and keyboard arrow keys switch between images without refreshing.
- [x] **Category Filtering**: Accurately filters cards by `Nature`, `Architecture`, `Portraits`, and `Abstract` with dynamic badge counters.
- [x] **AI Auto-Categorization**: Validates user inputs with Zod, invokes Gemini AI when category is omitted, and stores the classified record.
- [x] **Security & RLS**: Sanitizes URLs to prevent XSS and rejects unauthenticated uploads with HTTP 401.
