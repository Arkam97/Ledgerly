using Ledgerly.Application.DTOs.Auth;
using Ledgerly.Domain.Entities;
using Ledgerly.Infrastructure.Services;
using Ledgerly.Persistence;
using Microsoft.EntityFrameworkCore;

namespace Ledgerly.Application.Services;

public class AuthService : IAuthService
{
    private readonly LedgerlyDbContext _context;
    private readonly IPasswordHasher _passwordHasher;
    private readonly IJwtService _jwtService;

    public AuthService(
        LedgerlyDbContext context,
        IPasswordHasher passwordHasher,
        IJwtService jwtService)
    {
        _context = context;
        _passwordHasher = passwordHasher;
        _jwtService = jwtService;
    }

    public async Task<LoginResponse> LoginAsync(LoginRequest request)
    {
        var user = await _context.Users
            .Include(u => u.Organization)
            .FirstOrDefaultAsync(u => u.Email == request.Email);

        if (user == null || !_passwordHasher.VerifyPassword(request.Password, user.PasswordHash))
        {
            throw new UnauthorizedAccessException("Invalid email or password");
        }

        var token = _jwtService.GenerateToken(user);
        var refreshToken = _jwtService.GenerateRefreshToken();

        return new LoginResponse
        {
            Token = token,
            RefreshToken = refreshToken,
            UserId = user.Id,
            OrganizationId = user.OrganizationId,
            Email = user.Email,
            Role = user.Role
        };
    }

    public async Task<LoginResponse> SignupAsync(SignupRequest request)
    {
        // Check if email already exists
        if (await _context.Users.AnyAsync(u => u.Email == request.Email))
        {
            throw new InvalidOperationException("Email already registered");
        }

        // Create organization
        var organization = new Organization
        {
            Name = request.OrganizationName
        };

        _context.Organizations.Add(organization);
        await _context.SaveChangesAsync();

        // Create admin user
        var user = new User
        {
            OrganizationId = organization.Id,
            Email = request.Email,
            PasswordHash = _passwordHasher.HashPassword(request.Password),
            Role = "admin"
        };

        _context.Users.Add(user);
        await _context.SaveChangesAsync();

        var token = _jwtService.GenerateToken(user);
        var refreshToken = _jwtService.GenerateRefreshToken();

        return new LoginResponse
        {
            Token = token,
            RefreshToken = refreshToken,
            UserId = user.Id,
            OrganizationId = user.OrganizationId,
            Email = user.Email,
            Role = user.Role
        };
    }
}

