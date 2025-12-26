# Ledgerly Backend Setup

## Prerequisites

- .NET 8 SDK
- PostgreSQL (or use SQLite for development)

## Database Setup

### Option 1: PostgreSQL (Recommended for Production)

1. Install PostgreSQL
2. Create a database:
   ```sql
   CREATE DATABASE ledgerly;
   ```
3. Update `appsettings.json` with your connection string:
   ```json
   "ConnectionStrings": {
     "DefaultConnection": "Host=localhost;Database=ledgerly;Username=postgres;Password=yourpassword"
   }
   ```

### Option 2: SQLite (For Development)

Update `LedgerlyDbContext.cs` to use SQLite instead of PostgreSQL:

```csharp
builder.Services.AddDbContext<LedgerlyDbContext>(options =>
    options.UseSqlite("Data Source=ledgerly.db"));
```

## Running the Application

1. Restore packages:
   ```bash
   dotnet restore
   ```

2. Create database migration (if using EF Core migrations):
   ```bash
   dotnet ef migrations add InitialCreate --project Ledgerly.Persistence --startup-project Ledgerly.Api
   ```

3. Apply migrations:
   ```bash
   dotnet ef database update --project Ledgerly.Persistence --startup-project Ledgerly.Api
   ```

   Or the application will automatically apply migrations on startup.

4. Run the API:
   ```bash
   cd Ledgerly.Api
   dotnet run
   ```

The API will be available at `https://localhost:5001` or `http://localhost:5000`

## API Documentation

Once running, visit `https://localhost:5001/swagger` for Swagger UI documentation.

## Testing the API

### Signup (Create Organization + Admin User)

```bash
POST /api/auth/signup
{
  "organizationName": "My Company",
  "email": "admin@example.com",
  "password": "password123",
  "name": "Admin User"
}
```

### Login

```bash
POST /api/auth/login
{
  "email": "admin@example.com",
  "password": "password123"
}
```

Use the returned `token` in the `Authorization: Bearer <token>` header for subsequent requests.

## Environment Variables

For production, set these environment variables or update `appsettings.json`:

- `Jwt:SecretKey` - A secure random string (at least 32 characters)
- `ConnectionStrings:DefaultConnection` - Your database connection string
- `FileStorage:Path` - Path for storing uploaded files (default: `uploads/receipts`)

