using Ledgerly.Domain.Entities;

namespace Ledgerly.Infrastructure.Services;

public interface IJwtService
{
    string GenerateToken(User user);
    string GenerateRefreshToken();
    bool ValidateToken(string token);
}

