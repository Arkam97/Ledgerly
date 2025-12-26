namespace Ledgerly.Domain.Entities;

public class Bill : BaseEntity
{
    public Guid OrganizationId { get; set; }
    public Guid CustomerId { get; set; }
    public string? BillNumber { get; set; }
    public decimal TotalAmount { get; set; }
    public decimal OutstandingAmount { get; set; }
    public DateTime BillDate { get; set; }
    public string Status { get; set; } = "open"; // open, closed
    
    // Navigation properties
    public Organization Organization { get; set; } = null!;
    public Customer Customer { get; set; } = null!;
    public ICollection<BillItem> Items { get; set; } = new List<BillItem>();
    public ICollection<Payment> Payments { get; set; } = new List<Payment>();
}

