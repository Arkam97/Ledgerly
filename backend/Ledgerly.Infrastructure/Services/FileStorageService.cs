using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;

namespace Ledgerly.Infrastructure.Services;

public class FileStorageService : IFileStorageService
{
    private readonly string _uploadsPath;
    private readonly IWebHostEnvironment _environment;

    public FileStorageService(IWebHostEnvironment environment, IConfiguration configuration)
    {
        _environment = environment;
        _uploadsPath = configuration["FileStorage:Path"] ?? Path.Combine(_environment.ContentRootPath, "uploads", "receipts");
        
        // Ensure directory exists
        if (!Directory.Exists(_uploadsPath))
        {
            Directory.CreateDirectory(_uploadsPath);
        }
    }

    public async Task<string> UploadFileAsync(IFormFile file, Guid organizationId)
    {
        if (file == null || file.Length == 0)
        {
            throw new ArgumentException("File is empty");
        }

        // Create organization-specific directory
        var orgPath = Path.Combine(_uploadsPath, organizationId.ToString());
        if (!Directory.Exists(orgPath))
        {
            Directory.CreateDirectory(orgPath);
        }

        // Generate unique filename
        var extension = Path.GetExtension(file.FileName);
        var fileName = $"{Guid.NewGuid()}{extension}";
        var filePath = Path.Combine(orgPath, fileName);

        // Save file
        using (var stream = new FileStream(filePath, FileMode.Create))
        {
            await file.CopyToAsync(stream);
        }

        // Return relative URL (in production, this would be an S3 URL)
        // For local development, return path that can be served statically
        return $"/uploads/receipts/{organizationId}/{fileName}";
    }
}

