namespace Ledgerly.Domain.Entities;

public class Customer : BaseEntity
{
    public Guid OrganizationId { get; set; }
    public string Name { get; set; } = string.Empty;
    public string? Contact { get; set; }
    public string? Notes { get; set; }
    
    // Navigation properties
    public Organization Organization { get; set; } = null!;
    public ICollection<Bill> Bills { get; set; } = new List<Bill>();
    public ICollection<Payment> Payments { get; set; } = new List<Payment>();
}

