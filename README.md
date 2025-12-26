# Ledgerly

A multi-organization billing and payment tracking system with OCR receipt scanning capabilities.

## Architecture

- **Frontend**: Flutter (Android + iOS)
- **Backend**: .NET 8 Web API
- **Database**: PostgreSQL (production) / SQLite (development)
- **File Storage**: S3-compatible storage (AWS S3 / DigitalOcean Spaces / local)
- **OCR**: On-device ML Kit (Google ML Kit for Android/iOS)

## Features

- ✅ Multi-organization support
- ✅ Customer (wholesaler) management
- ✅ Bill creation and tracking
- ✅ Payment processing with receipt upload
- ✅ OCR receipt scanning (automatic date & amount extraction)
- ✅ Dashboard with outstanding balances
- ✅ Collapsible customer list ordered by oldest outstanding bills

## Project Structure

```
Ledgerly/
├── backend/          # .NET Web API
├── app/              # Flutter mobile app
└── docs/             # Documentation
```

## Getting Started

### Backend Setup

```bash
cd backend
dotnet restore
dotnet ef database update
dotnet run
```

### Frontend Setup

```bash
cd app
flutter pub get
flutter run
```

## API Endpoints

### Authentication
- `POST /api/auth/login` - User login
- `POST /api/auth/signup` - Create organization and first user

### Organizations
- `GET /api/organizations/{id}` - Get organization
- `POST /api/organizations` - Create organization

### Customers
- `GET /api/customers` - List customers
- `POST /api/customers` - Create customer
- `GET /api/customers/{id}` - Get customer

### Bills
- `GET /api/bills` - List bills (with filters)
- `POST /api/bills` - Create bill
- `GET /api/bills/{id}` - Get bill

### Payments
- `POST /api/payments` - Create payment
- `GET /api/payments` - List payments
- `POST /api/payments/ocr` - Upload receipt and get OCR results

### Dashboard
- `GET /api/dashboard/summary` - Dashboard summary
- `GET /api/dashboard/outstanding-by-customer` - Outstanding by customer

## License

MIT

