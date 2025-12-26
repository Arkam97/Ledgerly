using System.Text.Json;

namespace Ledgerly.Domain.Entities;

public class ReceiptFile : BaseEntity
{
    public Guid OrganizationId { get; set; }
    public string FileUrl { get; set; } = string.Empty;
    public Guid? UploadedBy { get; set; }
    public DateTime UploadedAt { get; set; } = DateTime.UtcNow;
    public JsonDocument? Metadata { get; set; } // Optional: OCR content summary
    
    // Navigation properties
    public Organization Organization { get; set; } = null!;
    public User? Uploader { get; set; }
    public ICollection<Payment> Payments { get; set; } = new List<Payment>();
}

