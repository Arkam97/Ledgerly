using Ledgerly.Application.DTOs.Auth;

namespace Ledgerly.Application.Services;

public interface IAuthService
{
    Task<LoginResponse> LoginAsync(LoginRequest request);
    Task<LoginResponse> SignupAsync(SignupRequest request);
}

