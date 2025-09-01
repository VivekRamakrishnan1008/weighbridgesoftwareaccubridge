# Accubridge - Weighbridge Management System

![Version](https://img.shields.io/badge/version-1.0.3-blue.svg)
![Platform](https://img.shields.io/badge/platform-Windows-lightgrey.svg)
![License](https://img.shields.io/badge/license-Proprietary-red.svg)

## Overview

**Accubridge** is a comprehensive weighbridge management system developed by Notamedia for industrial weighing operations. The application is built as a desktop solution using **Electron** with **Angular** frontend and **Node.js** backend, designed to manage vehicle weighing processes, record transactions, and generate reports for industrial facilities.

### Key Features

- 🚛 **Vehicle Weight Management** - Complete weighing process from entry to exit
- 📊 **Real-time Weight Reading** - Serial port integration with weighing indicators
- 🎯 **Multi-mode Weighing** - Support for Inbound, Outbound, Internal, and Other weighment types
- 📝 **Comprehensive Reporting** - Detailed weighment reports and analytics
- 🔐 **User Authentication** - Role-based access control system
- 🖨️ **Print Integration** - Direct printer support for weighment slips
- 💾 **Database Management** - MSSQL database with backup functionality
- ⚙️ **System Configuration** - Flexible weighbridge and indicator setup
- 🔄 **SAP Integration** - Direct integration with SAP systems for data synchronization

## Architecture

### Technology Stack

**Frontend:**
- Angular 11.2.5
- Angular Material for UI components
- TypeScript 4.1.5
- RxJS for reactive programming

**Backend:**
- Node.js with Electron 13.1.6
- Microsoft SQL Server integration
- Serial port communication for weighing devices
- Strong-SOAP for SAP integration

**Desktop Application:**
- Electron for cross-platform desktop deployment
- Native Windows printer integration
- Hardware serial port communication

### Project Structure

```
weighbridgesoftwareaccubridge/
├── src/                          # Angular frontend source
│   ├── app/
│   │   ├── admin/               # Administration modules
│   │   ├── authentication/     # User authentication
│   │   ├── weighment/          # Core weighing functionality
│   │   ├── weighbridge-record/ # Weight recording system
│   │   ├── report/             # Reporting system
│   │   └── shared/             # Shared components
│   ├── assets/                 # Static assets
│   └── environments/           # Environment configurations
├── app/                        # Electron backend
│   ├── electron-main.js        # Main Electron process
│   ├── db-service.js          # Database operations
│   ├── my-port-reader.js      # Serial port communication
│   ├── printer-service.js     # Printing functionality
│   └── sap-integration.js     # SAP connectivity
├── build-res/                 # Build resources
├── python-requirements/       # Python dependencies
├── print.py                   # Python printing utility
└── mssql_db_script_new.sql   # Database schema
```

## Core Functionality

### 1. Weighment Process

The application manages a complete weighment workflow:

**First Weight Entry:**
- Vehicle arrives at weighbridge
- Vehicle details are captured (Vehicle No, Driver info, etc.)
- First weight is recorded from weighing indicator
- Tare weight validation for preset vehicles

**Second Weight Entry:**
- Vehicle returns after loading/unloading
- Second weight is captured
- Net weight calculation (|Second Weight - First Weight|)
- Material and customer details are recorded

**Weighment Types Supported:**
- **Inbound** - Materials coming into facility
- **Outbound** - Materials leaving facility (Domestic/Export/Subcontract)
- **Internal** - Internal facility transfers
- **Others** - Custom weighment types

### 2. Hardware Integration

**Weighing Indicators:**
- Serial port communication (RS232/RS485)
- Support for various indicator protocols
- Configurable data parsing (fixed/variable length)
- Real-time weight reading with stability detection

**Printer Integration:**
- Direct Windows printer support
- Custom print formatting using Python script
- Weighment slip generation
- PDF export capability

### 3. Database Management

**MSSQL Database Structure:**
- `weighment` - Main weighment records
- `weighment_details` - Detailed weight measurements
- `app_user` - User management
- `vehicle_tare_weight` - Preset vehicle configurations
- `app_data` - System configuration settings

### 4. User Management

**Role-based Access Control:**
- Admin users with full system access
- Operator users with weighment permissions
- Activity logging for audit trails
- Permission-based feature access

## Installation & Setup

### Prerequisites

- Windows 10/11 operating system
- Microsoft SQL Server (2016 or later)
- Node.js 15.14.0+ and npm
- Python 3.7+ with required packages
- Visual Studio 2019 with C++ module
- Serial port drivers for weighing equipment

### Database Setup

1. **Create Database:**
   ```sql
   CREATE DATABASE weighbridge;
   ```

2. **Run Database Script:**
   Execute `mssql_db_script_new.sql` to create tables and initial data

3. **Configure Connection:**
   Update database settings in environment configuration

### Development Installation

1. **Install Dependencies:**
   ```bash
   # Root directory
   npm install
   
   # App directory
   cd app
   npm install
   cd ..
   ```

2. **Rebuild Dependencies:**
   ```bash
   # Rebuild app dependencies
   npm run rebuild
   ```

3. **Install Python Requirements:**
   ```bash
   pip install -r requirements.txt
   ```

### Production Installation

1. **Download Application:**
   - [32-bit version](https://drive.google.com/file/d/1Tc3P6_hkL7sKsKt3OXvnkigL3KXrPPx3/view?usp=sharing)
   - [64-bit version](https://drive.google.com/file/d/1Z5EJ0rpO3_GT6nFH_ef2O7JYrklWc34s/view?usp=sharing)

2. **Extract and Install:**
   - Extract files to desired location
   - Create shortcut to `Accubridge.exe`

3. **Initial Configuration:**
   - Run application
   - Click "Initial Data" button
   - Enter license key: `616e-9958-8141-3800-1620-1feb`
   - Configure database connection

## Configuration

### Database Configuration

1. **SQL Server Setup:**
   - Ensure SQL Server is running
   - Create SQL authenticated user
   - Enable TCP/IP connections
   - Configure firewall if needed

2. **Connection Settings:**
   - Server name/IP address
   - Database name
   - Username and password
   - Port (default: 1433)

### Application Configuration

1. **Initial Setup:**
   - Login with admin credentials: `admin/Admin123`
   - Navigate to Administration > Data Setup
   - Configure search fields and save

2. **Weighbridge Setup:**
   - Go to Admin → Weighbridge Setup
   - Add weighing indicators
   - Configure COM port settings
   - Test connectivity

3. **System Settings:**
   - Configure weighment validation rules
   - Set zero tolerance parameters
   - Enable stable weight detection
   - Configure weighment types

## Usage Guide

### Development Mode

1. **Start Development Server:**
   ```bash
   npm start
   ```

2. **Configure Environment:**
   - Set `env = "DEV"` in `app/electron-main.js`

3. **Run Electron:**
   ```bash
   npm run electron-start
   ```

### Production Build

1. **Configure Environment:**
   - Set `env = "PROD"` in `app/electron-main.js`

2. **Build Application:**
   ```bash
   # Complete build (32-bit + 64-bit)
   npm run distc
   
   # 64-bit only
   npm run dist
   
   # 32-bit only
   npm run dist_32bit
   ```

### Daily Operations

1. **Vehicle Weighment:**
   - Select weighment type
   - Enter vehicle number
   - Capture first weight
   - Complete weighment with second weight
   - Generate slip

2. **Vehicle Setup:**
   - Register frequent vehicles
   - Set tare weights
   - Configure presets

3. **Reporting:**
   - Generate daily reports
   - Export data
   - Monitor system activity

## Hardware Integration

### Weighing Indicators

**Supported Communication:**
- Serial port (RS232/RS485)
- TCP/IP networking
- USB connections

**Configuration Parameters:**
- Baud rate (9600, 19200, etc.)
- Data bits (7, 8)
- Stop bits (1, 2)
- Parity (None, Even, Odd)
- Flow control

**Weight String Parsing:**
- Fixed length format
- Variable length format
- Custom delimiters
- Character position mapping

### Printer Support

**Printer Types:**
- Dot matrix printers
- Laser/Inkjet printers
- PDF generation

**Print Features:**
- Custom slip formatting
- Logo and header support
- Multiple copy printing
- Automatic paper cutting

## API Integration

### SAP Integration

**SOAP Web Service Integration:**
```javascript
// Data structure for SAP
const RequestData = {
  MT_WEIGHBRIDGE_WEIGHT_DATA_REQ: {
    WEIGHBRIDGE_TAB: {
      WEIGHBRIDGE_DATA: weighmentData
    }
  }
}
```

**Configuration Requirements:**
- SAP endpoint URL
- Username and password
- Service credentials
- Data mapping configuration

### Database API

**Key Operations:**
- Weighment CRUD operations
- User management
- Configuration management
- Report generation
- Backup and restore

## Troubleshooting

### Common Issues

1. **Database Connection Failed:**
   - Verify SQL Server service is running
   - Check connection string parameters
   - Ensure SQL authentication is enabled
   - Test network connectivity

2. **Serial Port Issues:**
   - Check COM port availability
   - Verify cable connections
   - Match baud rate settings
   - Test with device manager

3. **Weight Reading Problems:**
   - Validate indicator configuration
   - Check weight string format
   - Monitor communication logs
   - Test stability settings

4. **License Activation:**
   - Ensure internet connectivity
   - Check license server URL: `https://license-manager.onrender.com`
   - Verify license key format
   - Contact support for activation issues

### Log Files

**Location:**
- Development: Console output
- Production: `%USERPROFILE%\AppData\Roaming\Accubridge\logs\`

**Log Types:**
- Application logs
- Database operation logs
- Serial communication logs
- Print operation logs

## System Requirements

### Minimum Requirements
- **OS:** Windows 10 (64-bit)
- **RAM:** 4GB
- **Storage:** 2GB available space
- **Processor:** Intel i3 or equivalent

### Recommended Requirements
- **OS:** Windows 11 (64-bit)
- **RAM:** 8GB or higher
- **Storage:** 4GB available space
- **Processor:** Intel i5 or equivalent
- **Network:** Ethernet for SAP integration

### Software Dependencies
- Microsoft SQL Server 2012+
- .NET Framework 4.7.2+
- Visual C++ Redistributable
- Python 3.7+ (for printing)

## Security Features

### Data Protection
- Encrypted database connections
- Secure password storage
- User session management
- Activity audit trails

### Access Control
- Role-based permissions
- User authentication
- Session timeout
- Feature-level security

## Support and Maintenance

### Regular Maintenance
- Database backup scheduling
- Log file cleanup
- System performance monitoring
- Security updates

### Support Contacts
- **Developer:** Deep Prakash Nishad
- **Email:** deep.prakash.nishad@gmail.com
- **Repository:** [GitHub](https://github.com/VivekRamakrishnan1008/weighbridgesoftwareaccubridge)

## License

This software is proprietary and developed by Notamedia. All rights reserved.

**Trial License:** `616e-9958-8141-3800-1620-1feb`

For commercial licensing, please contact the development team.

---

**© 2023 Notamedia. All rights reserved.**
