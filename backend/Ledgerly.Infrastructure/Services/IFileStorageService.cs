using Microsoft.AspNetCore.Http;

namespace Ledgerly.Infrastructure.Services;

public interface IFileStorageService
{
    Task<string> UploadFileAsync(IFormFile file, Guid organizationId);
}

