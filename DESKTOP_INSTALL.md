# Dreamink Desktop Installation Guide

Dreamink Desktop is a portable application for screenwriters to organize and structure audiovisual works. It runs completely offline on your computer with no internet connection required.

## System Requirements

- **Windows**: Windows 10 or later (64-bit)
- **Linux**: Any modern distribution (Ubuntu 22.04+, Fedora 39+, Debian 12+)
- **macOS**: macOS 11+ (Intel or Apple Silicon)
- **Ruby**: 3.4+ (required - see installation below)
- **Disk Space**: ~200MB for application + your project data
- **RAM**: 1GB minimum, 2GB recommended

---

## Step 1: Install Ruby

Dreamink Desktop requires Ruby 3.4+. Install it first if you haven't already:

### Windows

1. Download [RubyInstaller for Windows](https://rubyinstaller.org/)
2. Choose **Ruby 3.4.6 with MSYS2 DevKit**
3. Run the installer and follow the wizard
4. When prompted, run `ridk install` and select option 3 (MSYS2 and MINGW development toolchain)
5. Verify installation:
   ```cmd
   ruby --version
   gem install bundler
   ```

### Linux (Ubuntu/Debian)

```bash
# Install via package manager (may not be latest version)
sudo apt-get update
sudo apt-get install ruby-full build-essential

# OR install via rbenv (recommended for latest version)
curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
source ~/.bashrc
rbenv install 3.4.6
rbenv global 3.4.6
gem install bundler
```

### Linux (Fedora/RHEL)

```bash
sudo dnf install ruby ruby-devel rubygem-bundler
# Verify version is 3.4+
ruby --version
```

### macOS

```bash
# Using Homebrew
brew install rbenv ruby-build
rbenv install 3.4.6
rbenv global 3.4.6
echo 'eval "$(rbenv init -)"' >> ~/.zshrc
source ~/.zshrc
gem install bundler
```

---

## Step 2: Download Dreamink Desktop

Download the portable bundle for your operating system from the [latest release](https://github.com/Dreamink-SNPP/dreamink-desktop/releases/latest):

- **Windows**: `Dreamink-X.X.X-Windows-Portable.zip`
- **Linux**: `Dreamink-X.X.X-Linux-Portable.tar.gz`

---

## Step 3: Extract and Run

### Windows

1. Extract the ZIP file to a location of your choice (e.g., `C:\Dreamink`)
2. Open the extracted folder
3. Double-click **`start-dreamink.bat`**
4. On first run, Windows may ask for firewall permission - click **Allow**
5. Your browser will open automatically to http://localhost:3000

### Linux

```bash
# Extract the archive
tar -xzf Dreamink-*-Linux-Portable.tar.gz

# Enter the directory
cd dreamink-*-linux

# Run the startup script
./start-dreamink.sh
```

Your browser will open automatically to http://localhost:3000

### macOS

```bash
# Extract and run (same as Linux)
tar -xzf Dreamink-*-Linux-Portable.tar.gz
cd dreamink-*-linux
./start-dreamink.sh
```

---

## First Run

On first launch, Dreamink will:

1. Initialize the database (~5-10 seconds)
2. Start a local web server on port 3000
3. Open your default browser

**Create your account:**
- All data is stored locally on your computer
- No internet connection required
- No external servers involved
- 100% private and offline

---

## Using Dreamink

### Starting the Application

**Windows:**
- Double-click `start-dreamink.bat` in the application folder

**Linux/macOS:**
- Run `./start-dreamink.sh` in the application folder

### Stopping the Application

- Press `Ctrl+C` in the terminal/command window
- OR close the terminal/command window

### Accessing from Other Devices

The startup script also shows your local network IP. Other devices on your LAN can access Dreamink at:
- `http://YOUR_IP:3000`

This is useful for accessing from tablets or other computers on your home network!

### Data Location

All your projects and data are stored in:
- `storage/production.sqlite3` (main database)
- Additional SQLite databases for cache/queue/cable

### Backing Up Your Data

Simply copy the entire `storage` folder:

**Windows:**
```cmd
xcopy /E /I C:\Dreamink\storage C:\Backup\dreamink-backup
```

**Linux/macOS:**
```bash
cp -r ~/dreamink-*/storage ~/dreamink-backup
```

---

## Troubleshooting

### "ruby: command not found"
Ruby is not installed or not in your PATH. Reinstall Ruby and verify with `ruby --version`.

### "bundle: command not found"
Install Bundler: `gem install bundler`

### Port 3000 Already in Use

Edit the startup script and change `-p 3000` to `-p 3001` (or another port):

**Windows** (`start-dreamink.bat`):
```batch
bundle exec rails server -p 3001 -b 127.0.0.1
```

**Linux/macOS** (`start-dreamink.sh`):
```bash
bundle exec rails server -p 3001 -b 0.0.0.0
```

### Browser Doesn't Open Automatically

Manually navigate to `http://localhost:3000` in your browser.

### "An error occurred while installing..." (Gem installation errors)

On Linux, you may need development packages:
```bash
# Ubuntu/Debian
sudo apt-get install build-essential libsqlite3-dev

# Fedora/RHEL
sudo dnf install @development-tools sqlite-devel
```

### Slow Startup

First run takes longer as it installs Ruby gems and initializes the database. Subsequent starts are much faster.

---

## Uninstallation

Simply delete the application folder. Your data will be removed with it, so **backup first** if needed!

**Windows:**
```cmd
rmdir /S /Q C:\Dreamink
```

**Linux/macOS:**
```bash
rm -rf ~/dreamink-*-linux
```

---

## Updates

To update to a new version:

1. Backup your `storage` folder
2. Download the new version
3. Extract to the same location (or a new location)
4. Copy your `storage` folder from the old version to the new version
5. Run the new version

Your data will be preserved!

---

## Advanced: Running as a Service

For power users who want Dreamink to start automatically:

### Linux (systemd)

Create `/etc/systemd/system/dreamink.service`:
```ini
[Unit]
Description=Dreamink Desktop
After=network.target

[Service]
Type=simple
User=YOUR_USERNAME
WorkingDirectory=/home/YOUR_USERNAME/dreamink-VERSION-linux
ExecStart=/bin/bash start-dreamink.sh
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

Enable and start:
```bash
sudo systemctl enable dreamink
sudo systemctl start dreamink
```

### Windows (Task Scheduler)

1. Open Task Scheduler
2. Create Basic Task
3. Trigger: At startup
4. Action: Start a program
5. Program: `C:\Dreamink\start-dreamink.bat`
6. Finish

---

## Support

For issues, questions, or feature requests:
- **GitHub Issues**: https://github.com/Dreamink-SNPP/dreamink-desktop/issues
- **Documentation**: Check CLAUDE.md and README.md in the repository

---

## Privacy & Security

- **100% Offline**: No data sent to external servers
- **Local Storage**: All data stored in SQLite database on your computer
- **No Tracking**: No analytics or telemetry
- **Open Source**: Full source code available on GitHub

---

## License

Dreamink is open-source software. See [LICENSE](https://github.com/Dreamink-SNPP/dreamink-desktop/blob/main/LICENSE) for details.
