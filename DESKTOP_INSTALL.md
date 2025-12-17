# Dreamink Desktop Installation Guide

Dreamink Desktop is a standalone application for screenwriters to organize and structure audiovisual works. It runs completely offline on your computer with no internet connection required.

## System Requirements

- **Windows**: Windows 10 or later (64-bit)
- **Linux**: Any modern distribution with X11 or Wayland (Ubuntu 22.04+, Fedora 39+, Debian 12+)
- **Disk Space**: ~100MB for application + your project data
- **RAM**: 1GB minimum, 2GB recommended

## Windows Installation

### Step 1: Download
Download `DreaminkSetup-1.0.0-windows.exe` from the [latest release](https://github.com/Dreamink-SNPP/dreamink-project/releases/latest).

### Step 2: Run Installer
1. Double-click the installer file
2. If Windows SmartScreen appears, click **More info** → **Run anyway**
3. Follow the installation wizard
4. Choose installation directory (default: `C:\Program Files\Dreamink`)

### Step 3: Launch
- **From Start Menu**: Search for "Dreamink" and click the icon
- **From Desktop**: Double-click the Dreamink shortcut

The application will:
1. Start a local server on port 3000
2. Automatically open your default browser
3. Show the login/registration page

### First Use
1. Create your account (stored locally, not online)
2. All data stays on your computer
3. Works completely offline

### Data Location
- **Application**: `C:\Program Files\Dreamink`
- **Database**: `C:\Program Files\Dreamink\storage\production.sqlite3`

### Backup Your Data
Copy the `C:\Program Files\Dreamink\storage` folder to back up all your projects.

---

## Linux Installation

### Step 1: Download
Download `Dreamink-1.0.0-x86_64.AppImage` from the [latest release](https://github.com/Dreamink-SNPP/dreamink-project/releases/latest).

### Step 2: Make Executable
```bash
chmod +x Dreamink-1.0.0-x86_64.AppImage
```

### Step 3: Run
```bash
./Dreamink-1.0.0-x86_64.AppImage
```

Or double-click in your file manager.

The application will:
1. Start a local server on port 3000
2. Automatically open your default browser
3. Show the login/registration page

### Optional: Integrate with Desktop
Move the AppImage to a convenient location:
```bash
mkdir -p ~/.local/bin
mv Dreamink-*.AppImage ~/.local/bin/dreamink
```

Create a desktop entry:
```bash
cat > ~/.local/share/applications/dreamink.desktop << EOF
[Desktop Entry]
Type=Application
Name=Dreamink Desktop
Exec=$HOME/.local/bin/dreamink
Icon=dreamink
Categories=Office;Utility;
Terminal=false
EOF
```

### Data Location
- **AppImage**: Where you downloaded it
- **Database**: `~/.local/share/Dreamink/storage/production.sqlite3`

### Backup Your Data
```bash
cp -r ~/.local/share/Dreamink/storage ~/dreamink-backup
```

---

## Using Dreamink

### Creating Your First Project
1. After logging in, click **New Project**
2. Enter project title and description
3. Start adding Acts, Sequences, and Scenes

### Organizing Structure
- **Acts**: Major story divisions (e.g., Act 1, Act 2, Act 3)
- **Sequences**: Groups of related scenes within an act
- **Scenes**: Individual story beats

### Drag and Drop
- Drag scenes between sequences
- Drag sequences between acts
- Reorder items by dragging left/right

### Additional Features
- **Characters**: Track character information and traits
- **Locations**: Manage scene locations (interior/exterior)
- **Ideas**: Capture story ideas with tags
- **PDF Export**: Export project structure to PDF

### Offline Mode
The application works completely offline. The yellow "Offline Mode" indicator will appear in the bottom-right if your computer loses internet connection.

---

## Troubleshooting

### Port 3000 Already in Use

**Problem**: Another application is using port 3000.

**Solution (Windows)**:
1. Edit `C:\Program Files\Dreamink\start.bat`
2. Change `-p 3000` to `-p 3001` (or another port)
3. Update browser URL to `http://localhost:3001`

**Solution (Linux)**:
1. Extract the AppImage: `./Dreamink-*.AppImage --appimage-extract`
2. Edit `squashfs-root/usr/bin/dreamink`
3. Change `-p 3000` to `-p 3001`
4. Run: `./squashfs-root/AppRun`

### Browser Doesn't Open Automatically

**Solution**: Manually navigate to `http://localhost:3000` in any browser.

### Application Won't Start

**Windows**:
1. Check Windows Event Viewer for errors
2. Ensure you have administrator privileges
3. Try reinstalling the application

**Linux**:
1. Check if port 3000 is available: `netstat -tuln | grep 3000`
2. Run AppImage from terminal to see error messages
3. Ensure you have execute permissions: `chmod +x Dreamink-*.AppImage`

### Can't Access After Restart

**Solution**: Ensure Dreamink is running. Check:
- **Windows**: Look for Dreamink in system tray or Task Manager
- **Linux**: Run `ps aux | grep dreamink` to check if process is running

### Firewall Blocking Localhost

**Windows**:
1. Open Windows Defender Firewall
2. Allow connections to port 3000 for localhost

**Linux**:
```bash
sudo ufw allow from 127.0.0.1 to any port 3000
```

### Data Migration from Web Version

If you previously used Dreamink with Docker/PostgreSQL:

1. Export your data (if export feature exists) OR
2. Manually recreate projects in the desktop version
3. The desktop version uses SQLite instead of PostgreSQL

---

## Uninstallation

### Windows
1. Go to Settings → Apps → Installed apps
2. Find "Dreamink Desktop"
3. Click Uninstall
4. OR run `C:\Program Files\Dreamink\Uninstall.exe`

### Linux
Simply delete the AppImage file:
```bash
rm ~/.local/bin/dreamink
rm ~/.local/share/applications/dreamink.desktop
```

To remove all data:
```bash
rm -rf ~/.local/share/Dreamink
```

---

## Updates

### Windows
1. Download the new installer
2. Run it to upgrade (preserves your data)

### Linux
1. Download the new AppImage
2. Replace the old file
3. Your data is stored separately and won't be affected

---

## Support

For issues, questions, or feature requests:
- **GitHub Issues**: https://github.com/Dreamink-SNPP/dreamink-project/issues
- **Documentation**: https://github.com/Dreamink-SNPP/dreamink-project

---

## Privacy & Security

- **100% Offline**: No data sent to external servers
- **Local Storage**: All data stored in SQLite database on your computer
- **No Tracking**: No analytics or telemetry
- **Open Source**: Full source code available on GitHub

---

## License

Dreamink is open-source software. See [LICENSE](https://github.com/Dreamink-SNPP/dreamink-project/blob/main/LICENSE) for details.
