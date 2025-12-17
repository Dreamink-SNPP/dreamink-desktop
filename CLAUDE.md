# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

> [!IMPORTANT]
> **This is the desktop/PWA version of Dreamink.** This repository focuses on offline-capable desktop applications with Progressive Web App features. For the standard web application version, see [dreamink-project](https://github.com/Dreamink-SNPP/dreamink-project).

Dreamink Desktop is an offline-capable application for screenwriters to organize and structure audiovisual works before writing the literary script. It manages dramatic structure using a three-tier hierarchy (Acts → Sequences → Scenes) with a Kanban-style interface, along with characters, locations, and ideas.

**Stack**: Ruby on Rails 8.1.1, Ruby 3.4+, SQLite3, Node.js 22+, Tailwind CSS, Hotwire (Turbo + Stimulus), ESbuild, PWA (Service Worker)

**Key Dependencies**:
- `sqlite3` - Lightweight file-based database for offline use
- `acts_as_list` - Position-based ordering for Acts, Sequences, Scenes
- `bcrypt` - Password hashing for authentication
- `prawn` & `prawn-table` - PDF generation
- `solid_cache`, `solid_queue`, `solid_cable` - Rails 8 database-backed adapters
- `sortablejs` - Drag-and-drop functionality (frontend)
- `dotenv-rails` - Environment variable management

**Desktop/PWA Features**:
- Service Worker for offline caching
- PWA manifest for installable app experience
- Offline indicator UI component
- Desktop build scripts (Linux AppImage, Windows NSIS)
- Ruby-packer for standalone executables

## Prerequisites

- **Ruby**: 3.4+ (project uses 3.4.6)
  - Recommended: Use `rbenv` for Ruby version management (Linux/macOS)
- **Rails**: 8.1.1
- **Node.js**: 22+ (project uses 22.19.0)
- **SQLite3**: Built into Ruby, no separate installation needed for development
- **Bundler**: `gem install bundler` (or installed via `bundle install`)
- **Foreman**: Installed automatically by `bin/dev`

**For Desktop Builds** (optional):
- `ruby-packer` (rubyc) - Creates standalone executables
- `appimagetool` (Linux) - Builds AppImage packages
- `nsis` (Windows) - Creates Windows installers

### Windows Users

> [!CAUTION]
> The Windows setup instructions and scripts (`bin/dev.bat`, `bin/dev.ps1`) have not been tested on actual Windows systems yet. We welcome feedback and bug reports from Windows users to help improve this documentation.

This project uses Unix-style tools and scripts. Windows users have two options:

#### Option 1: WSL2 (Recommended)

Use Windows Subsystem for Linux for the best compatibility:

```powershell
# In PowerShell (Administrator)
wsl --install
```

After installation:
1. Restart your computer
2. Open Ubuntu (installed with WSL2)
3. Install Docker Desktop for Windows with WSL2 backend enabled
4. Follow all setup instructions in your WSL2 Ubuntu environment
5. The `bin/dev` script and all Unix commands will work natively

**Benefits**: Full compatibility, native Linux environment, all documentation applies directly.

#### Option 2: Native Windows

If you prefer native Windows without WSL2:

**Ruby Installation**:
- Use [RubyInstaller for Windows](https://rubyinstaller.org/) instead of `rbenv`
- Download Ruby 3.4.6 installer (with DevKit)
- Verify: `ruby --version` should show `ruby 3.4.6`

**Node.js Installation**:
- Download from [nodejs.org](https://nodejs.org/)
- Verify: `node --version` should show `v22.x`

**SQLite3**:
- Included with Ruby installation (sqlite3 gem)
- No separate installation needed

**Running the Development Server**:
The `bin/dev` script is a Unix shell script. Use one of these alternatives:

```powershell
# Option A: Use the provided Windows batch script (CMD)
bin\dev.bat

# Option B: Use the provided PowerShell script
bin\dev.ps1

# Option C: Run foreman directly
gem install foreman
foreman start -f Procfile.dev
```

**Important Notes for Native Windows**:
- Use backslashes `\` for paths: `bin\dev.bat` instead of `bin/dev`
- Replace `export VAR=value` with `set VAR=value` (CMD) or `$env:VAR="value"` (PowerShell)
- Multi-line commands with `\` won't work; combine into single lines or use `^` (CMD) or `` ` `` (PowerShell)
- `rbenv rehash` is not needed (RubyInstaller doesn't use it)

## Initial Setup

### Local Development Setup

```bash
# 1. Clone the repository
git clone https://github.com/Dreamink-SNPP/dreamink-desktop.git
cd dreamink-desktop

# 2. Install Ruby (if using rbenv)
# The project uses Ruby 3.4.6 (specified in .ruby-version)
# If you don't have it installed:
rbenv install 3.4.6
rbenv rehash

# Verify Ruby version
ruby --version  # Should show: ruby 3.4.6

# 3. Install dependencies
bundle install
npm install

# Important: If using rbenv, rehash after installing gems with executables
rbenv rehash

# 4. Set up database (SQLite3 - no external server needed)
rails db:create
rails db:migrate

# 5. Start the development server
bin/dev
```

Visit `http://localhost:3000` to access the application.

**Note**: Unlike the web version, this desktop version uses SQLite3, so no PostgreSQL container or environment variables are needed. The database is stored in `storage/development.sqlite3`.

## Development Commands

### Starting Development Server
```bash
bin/dev
```
This uses Foreman to run three processes simultaneously (defined in `Procfile.dev`):
- Rails server with debugging enabled on port 3000
- JavaScript bundler in watch mode (ESbuild)
- Tailwind CSS watcher

### Database Setup

**Important**: This desktop version uses SQLite3 for offline capability. No external database server or Docker containers are needed.

Database files are stored locally:
- **Development**: `storage/development.sqlite3`
- **Test**: `storage/test.sqlite3`
- **Production** (desktop builds): `storage/production.sqlite3`

```bash
# Create databases (creates SQLite3 files)
rails db:create

# Run migrations
rails db:migrate

# Seed database (if seed data exists)
rails db:seed
```

**Backing up your data:**
```bash
# Simple file copy
cp storage/development.sqlite3 ~/backups/dreamink-backup-$(date +%Y%m%d).sqlite3

# Or use SQLite3 backup command
sqlite3 storage/development.sqlite3 ".backup storage/development-backup.sqlite3"
```

**Resetting the database:**
```bash
# Drop, recreate, and run migrations
rails db:reset

# Or completely remove and recreate
rm storage/development.sqlite3
rails db:create db:migrate
```

### Testing
```bash
# Run all tests (runs in parallel by default)
rails test

# Run specific test file
rails test test/controllers/scenes_controller_test.rb

# Run system tests (uses Capybara + Selenium + Chrome)
rails test:system

# Run all tests including system tests (like CI does)
bin/rails db:test:prepare test test:system

# Run a single test by line number
rails test test/controllers/scenes_controller_test.rb:42
```

**Important**: Tests use parallel execution by default. Fixtures return Hashes in parallel mode, so use `fixture_to_model(fixture, ModelClass)` helper to convert them to model instances. For authentication in controller tests, use `sign_in_as(user)` helper (sets `session[:session_id]`).

### Code Quality
```bash
# Run RuboCop linter (uses rubocop-rails-omakase)
rubocop
# Or via bin wrapper:
bin/rubocop

# Run Brakeman security scanner
brakeman
# Or via bin wrapper:
bin/brakeman

# Build JavaScript assets (production build)
npm run build

# Watch mode for JavaScript (already included in bin/dev)
npm run build -- --watch
```

### CI Pipeline

GitHub Actions workflow (`.github/workflows/ci.yml`) runs on PRs and pushes to main:
- **scan_ruby**: Runs Brakeman security scan
- **lint**: Runs RuboCop style checks
- **test**: Runs full test suite with SQLite3 (no external database needed)

CI uses `bin/rails db:test:prepare test test:system` to run both unit and system tests.

### Desktop Build Pipeline

GitHub Actions workflow (`.github/workflows/build-desktop.yml`) builds desktop installers:
- **build-linux**: Creates AppImage for Linux (uses ruby-packer + appimagetool)
- **build-windows**: Creates NSIS installer for Windows
- **release**: Automatically publishes artifacts to GitHub Releases on tags

Trigger manually via workflow dispatch or push a version tag (e.g., `v1.0.0`).

## Architecture

### Data Model Hierarchy

The core dramatic structure uses a strict three-level hierarchy with position-based ordering:

**Project** (belongs to User)
└── **Acts** (ordered by position, unique per project)
    └── **Sequences** (ordered by position within act)
        └── **Scenes** (ordered by position within sequence)

Additionally, projects have independent collections:
- **Characters** with internal/external trait associations
- **Locations** (can be interior/exterior)
- **Ideas** with tag support

**Important**: Scenes maintain denormalized references (`act_id`, `project_id`) for performance, automatically synced via the `sync_references` callback.

### Authentication System

Custom Rails 8-style authentication (not Devise):
- Session-based with signed cookies
- Sessions stored in database with expiration support
- `Authentication` concern in controllers provides: `current_user`, `require_authentication`, `start_new_session_for`, `terminate_session`
- `Current` model holds request-scoped session data

### Authorization Pattern

Uses `UserScoped` concern for multi-tenant data isolation:
- All resources scoped to owning user via `for_user(user)` class method
- `owned_by?(user)` instance method checks ownership
- `ProjectAuthorization` concern enforces authorization in controllers

### Reordering & Drag-and-Drop

The structure supports complex reordering using `acts_as_list` gem:
- Acts can move left/right within a project
- Sequences can move left/right within an act or move to different acts
- Scenes can move to different sequences

**Critical**: The `Scene#move_to_sequence` method uses temporary negative positions to avoid unique constraint violations during complex moves. Use `update_columns` to bypass callbacks and validations for performance.

Controller actions handle reordering via:
- `PATCH /projects/:project_id/acts/:id/move_left`
- `PATCH /projects/:project_id/sequences/:id/move_to_act`
- `PATCH /projects/:project_id/scenes/:id/move_to_sequence`

Frontend uses `sortable_controller.js` (Stimulus) with SortableJS library.

### Frontend Architecture

**JavaScript**: Stimulus controllers in `app/javascript/controllers/`
- `sortable_controller.js`: Main drag-and-drop for structure board (complex, ~450 lines)
- `structure_controller.js`: Kanban board UI interactions
- `modal_controller.js`: Modal management
- `collapsible_controller.js`: Collapsible sections
- `flash_controller.js`: Flash message auto-dismissal
- `offline_controller.js`: Offline status indicator (PWA feature)

**PWA Features** (`app/javascript/application.js` and `app/views/pwa/`):
- **Service Worker** (`service-worker.js`): Provides offline functionality
  - Network-first strategy for HTML/API requests
  - Cache-first strategy for static assets (CSS, JS, images)
  - Automatic fallback to cache when offline
- **PWA Manifest** (`manifest.json.erb`): Enables "Add to Home Screen" and standalone mode
- **Offline Indicator**: Yellow notification in bottom-right when connection lost

**CSS**: Tailwind CSS with custom color palette (see `docs/STYLE_GUIDE.md`)
- Primary brand color: `#1B3C53` (dark teal/navy)
- Use `bg-primary`, `text-primary`, `hover:bg-secondary-dark`
- Custom shades: `primary-50` through `primary-900`

**Assets and Branding**:
- **Logo**: `app/assets/images/dreamink-logo.svg` - Main Dreamink logo used throughout the application
- **Favicon**: `public/icon.svg` and `public/icon.png` - Browser tab icons
- Logo appears in:
  - Navbar (`app/views/shared/_navbar.html.erb`) - 32px height
  - Authentication pages (login, registration, forgot password) - 64px height
- Use `<%= image_tag "dreamink-logo.svg", alt: "Dreamink", class: "h-8 w-auto" %>` pattern for displaying the logo

**Build Process**: ESbuild bundles JavaScript from `app/javascript/` to `app/assets/builds/`

### Service Objects

Services located in `app/services/`:
- `Fountain::StructureExporter`: Exports project structure to Fountain screenplay format
- `Pdf::*`: PDF generation services (using Prawn)

### Routing Patterns

Nested resource structure (see `config/routes.rb`):
```ruby
resources :projects do
  resources :acts
  resources :sequences
  resources :scenes
  resources :characters
  resources :locations
  resources :ideas

  get "structure", to: "structures#show"    # Kanban board
  get :fountain_export                      # Export to Fountain format
  get :report                               # PDF report
end
```

**Key routing conventions**:
- All resources nested under `/projects/:project_id`
- Modal endpoints use `_modal` suffix (e.g., `edit_modal`, `new_modal`) to return Turbo Frame responses
- Reordering actions: `move_left`, `move_right`, `move_to_act`, `move_to_sequence`
- Report actions: `report` (single resource), `collection_report` (all resources)
- Scenes support filtering: `by_location` action

**Authentication routes**:
- `GET /login`, `POST /login`, `DELETE /logout`
- `GET /register`, `POST /register`
- `GET /forgot-password`, `POST /forgot-password`, `GET /reset-password/:token`, `PATCH /reset-password/:token`

### Production Configuration

**SSL/HTTPS Settings** (`config/environments/production.rb:28-32`):

```ruby
# SSL is configurable via environment variables
config.assume_ssl = ENV.fetch("RAILS_ASSUME_SSL", "true") == "true"
config.force_ssl = ENV.fetch("RAILS_FORCE_SSL", "true") == "true"
```

**Default behavior:**
- **Kamal/public deployment:** SSL enabled by default (`RAILS_FORCE_SSL=true`)
- **Docker Compose local/LAN:** SSL disabled (`RAILS_FORCE_SSL=false`) for ease of use

**Database configuration** (`config/database.yml`):

This desktop version uses SQLite3 for all environments:
- **Development**: `storage/development.sqlite3`
- **Test**: `storage/test.sqlite3`
- **Production** (desktop builds): `storage/production.sqlite3`

Solid Suite (Cache, Queue, Cable) uses the same SQLite3 database with separate tables.

**Important environment variables:**
- `SECRET_KEY_BASE` - Rails secret key (required for production, auto-generated in desktop builds)
- `RAILS_ENV` - Rails environment (development/test/production)
- `RAILS_FORCE_SSL` - Enable/disable HTTPS enforcement (default: false for desktop)
- `RAILS_SERVE_STATIC_FILES` - Serve static assets via Rails (enabled for desktop)
- `RAILS_LOG_TO_STDOUT` - Send logs to stdout (enabled for desktop builds)

### Internationalization

The app supports Spanish (default) and English:
- Locale files: `config/locales/es.yml`, `config/locales/en.yml`
- Use `I18n.t()` for all user-facing strings
- Scene times of day defined in `Scene::TIMES_OF_DAY` constant

## Development Guidelines

### Testing Patterns

Tests use fixtures in `test/fixtures/` with helper methods in `test/test_helper.rb`:
- **Parallel execution**: Tests run in parallel by default. Use `fixture_to_model(fixture, ModelClass)` to handle Hash fixtures
- **Controller tests**: Verify authentication and authorization. Use `sign_in_as(user)` to authenticate
- **System tests**: Use Capybara + Selenium WebDriver with Chrome
- **Authentication**: Set `session[:session_id]` directly in integration tests (see `Authentication` concern)

### Database Migrations

- Use `db:migrate` after pulling changes
- Unique constraints on position columns prevent duplicates (e.g., `index_acts_on_project_and_position`)
- Recent migrations added session expiration and performance indexes

### Common Development Tasks

**Adding a new model attribute**:
1. Generate migration: `rails g migration AddFieldToModel field:type`
2. Run migration: `rails db:migrate`
3. Add to strong parameters in controller
4. Update form views
5. Add tests for new attribute

**Adding a new Stimulus controller**:
1. Create in `app/javascript/controllers/name_controller.js`
2. Export in `app/javascript/controllers/index.js`
3. Use in view: `data-controller="name"`
4. Available targets: connect(), disconnect(), targets, values, classes

**Working with Turbo Frames**:
- Modal forms use `turbo_frame_tag` with matching IDs
- Controllers respond with `turbo_stream` format for dynamic updates
- Lazy-loaded frames use `src` attribute
- Modal endpoints use `_modal` suffix (e.g., `edit_modal_project_scene_path`)

**Debugging**:
- `bin/dev` enables Ruby debug mode via `RUBY_DEBUG_OPEN=true`
- Insert `debugger` in code to trigger breakpoint
- System test screenshots saved to `tmp/screenshots/` on failure

**Troubleshooting**:
- **"command not found" for gem executables** (foreman, rubocop, etc.): Run `rbenv rehash` after installing new gems
- **Ruby version mismatch**: Ensure `ruby --version` matches `.ruby-version` file (3.4.6)
- **Database errors**: Check that `storage/` directory exists and is writable
- **"database is locked"**: SQLite3 error when multiple processes access DB simultaneously; restart server
- **Service worker not updating**: Hard refresh (Ctrl+Shift+R) or clear browser cache

### Desktop Application Deployment

This version is designed for **local desktop use**, not web hosting. See [DESKTOP_INSTALL.md](DESKTOP_INSTALL.md) for end-user installation instructions.

#### Building Desktop Installers

**Automated via GitHub Actions:**
1. Go to Actions tab → "Build Desktop Apps" workflow
2. Click "Run workflow"
3. Enter version number (e.g., "1.0.0")
4. Wait for builds to complete (~10-15 minutes)
5. Download artifacts from GitHub Releases

**Manual local builds:**

Linux AppImage:
```bash
# Requires: ruby-packer, appimagetool
./bin/build-desktop linux 1.0.0
./installers/linux/build-appimage.sh 1.0.0
```

Windows Installer:
```bash
# Requires: ruby-packer, NSIS (on Windows or via Wine)
# See .github/workflows/build-desktop.yml for build steps
```

**Build output:**
- **Linux**: `dist/Dreamink-<version>-x86_64.AppImage`
- **Windows**: `dist/DreaminkSetup-<version>-windows.exe`

#### Build Architecture

1. **ruby-packer (rubyc)**: Bundles Ruby runtime + Rails app into single executable
2. **Package scripts** (`bin/build-desktop`, `bin/package-prep`): Prepare assets and dependencies
3. **Installers**: Create distribution packages
   - Linux: AppImage (self-contained, no installation needed)
   - Windows: NSIS installer (installs to Program Files)

**Important build considerations:**
- SQLite3 database bundled as empty file, populated on first run
- Assets precompiled during build
- `SECRET_KEY_BASE` generated at runtime
- Binds to `127.0.0.1:3000` (localhost only for security)
