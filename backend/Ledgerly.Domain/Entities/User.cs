namespace Ledgerly.Domain.Entities;

public class User : BaseEntity
{
    public Guid OrganizationId { get; set; }
    public string Email { get; set; } = string.Empty;
    public string PasswordHash { get; set; } = string.Empty;
    public string Role { get; set; } = "operator"; // admin, operator
    
    // Navigation properties
    public Organization Organization { get; set; } = null!;
    public ICollection<ReceiptFile> UploadedReceipts { get; set; } = new List<ReceiptFile>();
}

