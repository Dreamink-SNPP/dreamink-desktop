#!/bin/bash
set -e

VERSION=${1:-1.0.0}
APPDIR="dist/Dreamink.AppDir"

echo "=== Building Dreamink AppImage v$VERSION ==="

# Create AppDir structure
mkdir -p $APPDIR/usr/{bin,lib,share}
mkdir -p $APPDIR/usr/share/{applications,icons/hicolor/512x512/apps}

# Copy application files
echo "Copying application files..."
cp -r dist/dreamink-$VERSION-linux/* $APPDIR/usr/bin/
mv $APPDIR/usr/bin/dreamink $APPDIR/usr/bin/dreamink.bin

# Create launcher wrapper
echo "Creating launcher wrapper..."
cat > $APPDIR/usr/bin/dreamink << 'EOF'
#!/bin/bash
APPDIR="$(dirname "$(dirname "$(readlink -f "$0")")")"
cd "$APPDIR/usr/bin"

export RAILS_ENV=production
export SECRET_KEY_BASE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 64 | head -n 1)
export RAILS_SERVE_STATIC_FILES=true
export RAILS_LOG_TO_STDOUT=true
export RAILS_FORCE_SSL=false

# Initialize database if needed
if [ ! -f storage/production.sqlite3 ]; then
  echo "Initializing database..."
  ./dreamink.bin db:migrate
fi

# Start server and open browser
echo "Starting Dreamink..."
xdg-open http://localhost:3000 &
./dreamink.bin server -p 3000 -b 127.0.0.1
EOF

chmod +x $APPDIR/usr/bin/dreamink

# Create .desktop file
echo "Creating desktop entry..."
cat > $APPDIR/usr/share/applications/dreamink.desktop << EOF
[Desktop Entry]
Type=Application
Name=Dreamink Desktop
Comment=Offline screenwriting structure organizer
Exec=dreamink
Icon=dreamink
Categories=Office;Utility;
Terminal=false
StartupNotify=true
EOF

# Copy icon
echo "Copying icon..."
cp public/icon.png $APPDIR/usr/share/icons/hicolor/512x512/apps/dreamink.png
cp public/icon.png $APPDIR/dreamink.png
cp installers/linux/dreamink.desktop $APPDIR/

# Create AppRun
echo "Creating AppRun..."
ln -s usr/bin/dreamink $APPDIR/AppRun

# Build AppImage
echo "Building AppImage..."
if ! command -v appimagetool &> /dev/null; then
    echo "Error: appimagetool not found!"
    echo "Please install it from: https://github.com/AppImage/AppImageKit/releases"
    exit 1
fi

appimagetool $APPDIR dist/Dreamink-$VERSION-x86_64.AppImage

echo "AppImage created: dist/Dreamink-$VERSION-x86_64.AppImage"
echo "Make it executable: chmod +x dist/Dreamink-$VERSION-x86_64.AppImage"
