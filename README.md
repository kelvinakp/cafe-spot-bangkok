# ☕ Cafe Spot Bangkok

A mobile app for finding and saving specialty cafes in Bangkok.
Final project for **CSC452**, built with **Flutter**, an **Express.js** REST API, a **TiDB Cloud** (MySQL) database, and **Vercel** hosting.

Live API: <https://cafe-spot-bangkok.vercel.app>

---

## About the app

Cafe Spot Bangkok lets users:

- **Explore** a list of real Bangkok cafes (NANA Coffee Roasters, Factory Coffee, Roots, La Cabra and more), with each cafe's area, vibe, Wi-Fi score, signature drink, price level and how busy it is.
- **Filter** cafes by area (Ari, Thonglor, Silom, Ekkamai, …) and vibe (Quiet, Aesthetic, Pet-friendly, Late-night, …).
- **Open a cafe** to see its full details and photo.
- **Save cafes to My Saves** under a category (Work-friendly, Date spot, Must try, Quiet study, Late-night) with a personal note, then **edit** or **delete** those saves (full CRUD).
- See their **Profile** and log out.

### App flow

```text
Splash → Login → TabMenu
                   ├── Explore   (browse + filter cafes → cafe detail)
                   ├── My Saves  (create / read / update / delete saves)
                   └── Profile   (user info + logout)
```

### Architecture

```text
Flutter app  ──HTTPS──▶  Express API (Vercel)  ──SQL──▶  TiDB Cloud
                         backend/index.js               cafes + favorites
```

---

## Team & responsibilities

The project was built by two members. The **backend was built together**; the **Flutter app was split** between us.

| Area | Aung Kyaw Phyo(6708142) | Myat Bhone Khant(6708345) |
|------|:--------:|:--------:|
| Backend: Express API, TiDB tables, seed data, Vercel deploy | ✅ | ✅ |
| App start: splash, login, tab menu, theme | ✅ | |
| Explore: cafe list, area/vibe filters, cafe detail, images | ✅ | |
| My Saves CRUD: list, create, update, delete | | ✅ |
| Profile & logout | | ✅ |

### Aung Kyaw Phyo(6708142): App shell + Explore

Aung Kyaw Phyo built how the app starts and the Explore tab, where users browse cafes loaded from `GET /cafes`.

```text
lib/main.dart                       App entry, MaterialApp + coffee theme
lib/splash_screen.dart              Splash screen
lib/login_screen.dart               Login form with validation
lib/tab_menu.dart                   Bottom tabs (Explore / My Saves / Profile)
lib/models/cafe.dart                Cafe model + fromJson
lib/widgets/cafe_network_image.dart Cafe image widget (asset / network)
lib/screens/cafe_list_screen.dart   Explore list + area/vibe filter chips
lib/screens/cafe_detail_screen.dart Cafe detail page
lib/services/api_service.dart       baseUrl, fetchCafes(), fetchCafeById()
```

### Myat Bhone Khant(6708345): My Saves CRUD + Profile

Myat Bhone Khant built My Saves, the app's main CRUD feature, and the Profile tab.

```text
lib/models/favorite.dart                  Favorite model + fromJson
lib/screens/favorites_screen.dart         My Saves list + category chips (Read)
lib/screens/create_favorite_screen.dart   Save a cafe form (Create)
lib/screens/update_favorite_screen.dart   Edit a save form (Update)
lib/screens/profile_screen.dart           Profile + logout
lib/services/api_service.dart             Favorites CRUD methods
```

| CRUD | Where in the app | API call |
|------|------------------|----------|
| **C**reate | Create Save form → CREATE | `POST /favorites` |
| **R**ead | My Saves list | `GET /favorites?email=` |
| **U**pdate | EDIT → Update form | `PUT /favorites` |
| **D**elete | DEL + confirm dialog | `DELETE /favorites` |

Deleting a save only removes it from the user's My Saves. The cafe stays in Explore.

### Together: Backend

| Piece | File |
|-------|------|
| API routes | `backend/index.js` |
| Tables + seed data | `backend/seed.sql` |
| Dependencies | `backend/package.json` |
| Vercel config | `backend/vercel.json` |
| DB connection (secret) | `backend/.env` (see `.env.example`) |

**Database tables**

- `cafes` is the shared cafe catalog that Explore reads.
- `favorites` holds each user's saves (`user_email`, `cafe_id`, `category`, `note`), used by My Saves.

**API endpoints**

| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET | `/` | Health check |
| GET | `/cafes` | List all cafes |
| GET | `/cafes/:id` | One cafe |
| POST / PUT / DELETE | `/cafes` | Manage cafes |
| GET | `/favorites?email=` | A user's saves (joined with cafe name, area, image) |
| GET | `/favorites/:id` | One save |
| POST | `/favorites` | Create a save |
| PUT | `/favorites` | Update a save |
| DELETE | `/favorites` | Delete a save |

---

## Project structure

```text
MP-project/
├── backend/               Express API (deployed to Vercel)
│   ├── index.js
│   ├── seed.sql
│   ├── package.json
│   └── vercel.json
├── cafe_spot_bangkok/     Flutter app
│   ├── lib/
│   │   ├── models/
│   │   ├── screens/
│   │   ├── services/
│   │   └── widgets/
│   └── assets/cafes/      Cafe photos
└── README.md
```

---

## Getting started

### 1. Backend

```powershell
cd backend
npm install
npm start
```

- Runs at <http://localhost:3000>.
- Needs `backend/.env` with the TiDB `DATABASE_URL` (copy `.env.example`).
- If the tables are empty, run `seed.sql` against the database (for example in DBeaver).

### 2. Flutter app

```powershell
cd cafe_spot_bangkok
flutter pub get
flutter run
```

The app calls the deployed API by default (`ApiService.deployedUrl`). To use a local backend instead, set `deployedUrl` to an empty string. The app then uses `localhost:3000`, or `10.0.2.2:3000` on the Android emulator.

### Login

- Any email containing `@` and a password of at least 6 characters.
- Demo account with saved cafes: **`demo@gmail.com` / `123456`**

---

## Tech stack

| Layer | Technology |
|-------|-----------|
| Mobile app | Flutter (Dart), `http` package |
| API | Node.js, Express, `mysql2`, `cors`, `dotenv` |
| Database | TiDB Cloud (MySQL-compatible) |
| Hosting | Vercel |
