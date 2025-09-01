# Electron Build Preparation Guide

This guide provides comprehensive steps to prepare and build the Accubridge Weighbridge Management System as an Electron desktop application.

## 📋 Prerequisites

Before starting the build process, ensure you have the following installed:

### System Requirements
- **Operating System:** Windows 10/11 (64-bit)
- **Node.js:** Version 15.14.0 or higher
- **npm:** Version 7.0.0 or higher
- **Python:** Version 3.7+ with pip
- **Git:** Latest version
- **Visual Studio:** 2019 with C++ build tools

### Verify Installation
```powershell
# Check Node.js version
node --version

# Check npm version
npm --version

# Check Python version
python --version

# Check git version
git --version
```

## 🚀 Step-by-Step Build Process

### Step 1: Environment Setup

1. **Clone or Navigate to Project Directory**
   ```powershell
   cd "c:\Users\nithi\Desktop\AgentAi\weighbridge\weighbridgesoftwareaccubridge"
   ```

2. **Install Global Dependencies**
   ```powershell
   # Install Angular CLI globally
   npm install -g @angular/cli@11.2.4

   # Install Electron globally (optional but recommended)
   npm install -g electron@13.1.6

   # Install electron-builder globally
   npm install -g electron-builder@22.10.5
   ```

### Step 2: Install Project Dependencies

1. **Install Root Dependencies**
   ```powershell
   # Clean install of all dependencies
   npm ci

   # Alternative: Regular install
   npm install
   ```

2. **Install App Dependencies**
   ```powershell
   # Navigate to app directory
   cd app

   # Install app-specific dependencies
   npm install

   # Return to root directory
   cd ..
   ```

3. **Install Python Dependencies**
   ```powershell
   # Install Python requirements for printing functionality
   pip install -r requirements.txt

   # Or install from wheel files
   pip install python-requirements/*.whl
   ```

### Step 3: Environment Configuration

1. **Configure Environment Settings**
   - Edit `env.json` for production settings
   - Update database connection strings
   - Set production URLs and paths

2. **Update Electron Main Process**
   ```javascript
   // In app/electron-main.js, set environment to production
   const env = "PROD"; // Change from "DEV" to "PROD"
   ```

3. **Verify Angular Environment**
   - Check `src/environments/environment.prod.ts`
   - Ensure production settings are correct

### Step 4: Database Preparation

1. **Setup Database Schema**
   ```powershell
   # Run the database script on your SQL Server
   # Execute: mssql_db_script_new.sql
   ```

2. **Test Database Connection**
   - Verify SQL Server is running
   - Test connection with configured credentials
   - Ensure database is accessible

### Step 5: Rebuild Native Dependencies

1. **Rebuild Electron Dependencies**
   ```powershell
   # Rebuild native modules for Electron
   npm run rebuild

   # Alternative: Manual rebuild
   ./node_modules/.bin/electron-rebuild
   ```

2. **Rebuild App Dependencies**
   ```powershell
   cd app
   npm run rebuild
   cd ..
   ```

### Step 6: Angular Build Process

1. **Build Angular Application**
   ```powershell
   # Production build with optimization
   npm run build

   # Manual build command
   ng build --prod --base-href ./ --aot --vendor-chunk --common-chunk --delete-output-path --build-optimizer
   ```

2. **Verify Build Output**
   - Check `app/dist/` directory exists
   - Verify all assets are compiled
   - Ensure no build errors

### Step 7: Electron Application Build

1. **Install App Dependencies for Electron**
   ```powershell
   # Install app dependencies for packaging
   npm run postinstall

   # Manual command
   electron-builder install-app-deps
   ```

2. **Test Electron Application**
   ```powershell
   # Test the application before building
   npm run electron-start
   ```

### Step 8: Create Distribution Packages

#### Option A: Build All Platforms
```powershell
# Build both 32-bit and 64-bit versions
npm run distc
```

#### Option B: Build Specific Architecture
```powershell
# Build 64-bit version only
npm run dist

# Build 32-bit version only
npm run dist_32bit
```

#### Option C: Manual Electron Builder Commands
```powershell
# 64-bit Windows build
electron-builder --win --x64

# 32-bit Windows build
electron-builder --win --ia32

# Both architectures
electron-builder --win
```

## 🔧 Configuration Files Overview

### package.json Scripts
```json
{
  "scripts": {
    "build": "ng build --prod --base-href ./ --aot --vendor-chunk --common-chunk --delete-output-path --build-optimizer",
    "rebuild": "electron-rebuild",
    "dist_32bit": "electron-builder --win --ia32",
    "dist": "electron-builder",
    "distp": "npm run build && npm run dist",
    "distc": "npm run build && npm run dist_32bit && npm run dist",
    "postinstall": "electron-builder install-app-deps",
    "electron-start": "electron ./app/electron-main.js"
  }
}
```

### electron-builder.json Configuration
```json
{
  "appId": "com.notamedia.accubridge",
  "productName": "Accubridge",
  "buildVersion": "0.0.1",
  "directories": {
    "app": "app",
    "buildResources": "build-res",
    "output": "release"
  },
  "extraFiles": ["env.json", "print.py"],
  "win": {
    "target": ["nsis"]
  }
}
```

## 🐛 Troubleshooting Common Issues

### Node.js/npm Issues
```powershell
# Clear npm cache
npm cache clean --force

# Delete node_modules and reinstall
Remove-Item -Recurse -Force node_modules
npm install
```

### Python Dependencies
```powershell
# Upgrade pip
python -m pip install --upgrade pip

# Install wheel
pip install wheel

# Install requirements
pip install -r requirements.txt
```

### Electron Rebuild Issues
```powershell
# Install Windows build tools
npm install --global windows-build-tools

# Install specific Visual Studio build tools
npm config set msvs_version 2019
```

### Serial Port Module Issues
```powershell
# Rebuild serialport module specifically
npm rebuild serialport --build-from-source
```

## 📁 Build Output Structure

After successful build, you'll find:

```
release/
├── win-unpacked/                 # Unpacked Windows application
├── Accubridge Setup 0.0.1.exe   # 64-bit installer
├── Accubridge Setup 0.0.1-ia32.exe # 32-bit installer (if built)
├── latest.yml                    # Update metadata
└── builder-debug.yml            # Debug information
```

## ✅ Pre-Build Checklist

- [ ] Node.js and npm are installed and updated
- [ ] Python 3.7+ is installed with pip
- [ ] All dependencies are installed (`npm install`)
- [ ] App dependencies are installed (`cd app && npm install`)
- [ ] Python requirements are installed (`pip install -r requirements.txt`)
- [ ] Native modules are rebuilt (`npm run rebuild`)
- [ ] Environment is set to production (`env = "PROD"`)
- [ ] Database connection is configured
- [ ] Angular build completes successfully (`npm run build`)
- [ ] Electron app starts correctly (`npm run electron-start`)

## 🚢 Deployment Steps

1. **Test the Built Application**
   - Run the unpacked version first
   - Test all functionality including database connection
   - Verify serial port communication
   - Test printing functionality

2. **Create Installer Package**
   - Use the generated `.exe` installer
   - Test installation on clean system
   - Verify all dependencies are included

3. **Distribution**
   - Package with required documentation
   - Include database setup scripts
   - Provide configuration instructions

## 📞 Support

If you encounter issues during the build process:

1. Check the console output for specific error messages
2. Verify all prerequisites are met
3. Ensure the database is properly configured
4. Contact the development team if needed

---

**Build completed successfully!** 🎉

The application is now ready for distribution and deployment.
