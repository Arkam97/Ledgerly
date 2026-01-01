# Deployment Guide

## Backend Deployment

### Option 1: Local Development (SQLite)

The backend is already configured to use SQLite by default. Just run:
```bash
cd backend/Ledgerly.Api
dotnet run
```

### Option 2: PostgreSQL on VPS

1. **Install PostgreSQL:**
   ```bash
   sudo apt update
   sudo apt install postgresql postgresql-contrib
   ```

2. **Create database:**
   ```sql
   sudo -u postgres psql
   CREATE DATABASE ledgerly;
   CREATE USER ledgerly_user WITH PASSWORD 'your_password';
   GRANT ALL PRIVILEGES ON DATABASE ledgerly TO ledgerly_user;
   ```

3. **Update appsettings.json:**
   ```json
   {
     "ConnectionStrings": {
       "DefaultConnection": "Host=localhost;Database=ledgerly;Username=ledgerly_user;Password=your_password"
     },
     "Database": {
       "UseSqlite": false
     }
   }
   ```

4. **Deploy application:**
   ```bash
   dotnet publish -c Release -o /opt/ledgerly
   ```

5. **Create systemd service** (`/etc/systemd/system/ledgerly.service`):
   ```ini
   [Unit]
   Description=Ledgerly API
   After=network.target

   [Service]
   Type=notify
   WorkingDirectory=/opt/ledgerly
   ExecStart=/usr/bin/dotnet /opt/ledgerly/Ledgerly.Api.dll
   Restart=always
   RestartSec=10
   User=www-data
   Environment=ASPNETCORE_ENVIRONMENT=Production

   [Install]
   WantedBy=multi-user.target
   ```

6. **Start service:**
   ```bash
   sudo systemctl enable ledgerly
   sudo systemctl start ledgerly
   ```

### Option 3: Docker

1. **Create Dockerfile** (already in backend):
   ```dockerfile
   FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
   WORKDIR /app
   EXPOSE 80
   EXPOSE 443

   FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
   WORKDIR /src
   COPY ["Ledgerly.Api/Ledgerly.Api.csproj", "Ledgerly.Api/"]
   COPY ["Ledgerly.Application/Ledgerly.Application.csproj", "Ledgerly.Application/"]
   # ... copy all projects
   RUN dotnet restore "Ledgerly.Api/Ledgerly.Api.csproj"
   COPY . .
   WORKDIR "/src/Ledgerly.Api"
   RUN dotnet build "Ledgerly.Api.csproj" -c Release -o /app/build

   FROM build AS publish
   RUN dotnet publish "Ledgerly.Api.csproj" -c Release -o /app/publish

   FROM base AS final
   WORKDIR /app
   COPY --from=publish /app/publish .
   ENTRYPOINT ["dotnet", "Ledgerly.Api.dll"]
   ```

2. **Build and run:**
   ```bash
   docker build -t ledgerly-api ./backend
   docker run -d -p 5042:80 ledgerly-api
   ```

## Flutter App Deployment

### Android

1. **Build APK:**
   ```bash
   cd app
   flutter build apk --release
   ```

2. **Build App Bundle (for Play Store):**
   ```bash
   flutter build appbundle --release
   ```

### iOS

1. **Build for iOS:**
   ```bash
   cd app
   flutter build ios --release
   ```

2. **Archive and upload via Xcode**

## Environment Variables

### Backend (.NET)

Set these environment variables or update `appsettings.json`:

- `Jwt:SecretKey` - Secure random string (at least 32 characters)
- `ConnectionStrings:DefaultConnection` - Database connection string
- `FileStorage:Path` - Path for file uploads (or configure S3)

### Flutter App

Update `lib/config/api_config.dart` with your production backend URL.

## CI/CD

GitHub Actions workflows are configured for:
- Backend CI: Build and test .NET solution
- Flutter CI: Analyze and build Flutter app
- Deploy: Automated deployment (configure secrets)

## Security Checklist

- [ ] Change JWT secret key in production
- [ ] Use HTTPS in production
- [ ] Configure CORS properly
- [ ] Set up proper file storage (S3/DigitalOcean Spaces)
- [ ] Enable database backups
- [ ] Set up monitoring and logging
- [ ] Configure firewall rules
- [ ] Use environment variables for secrets

