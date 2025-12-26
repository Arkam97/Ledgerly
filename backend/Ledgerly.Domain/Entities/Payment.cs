namespace Ledgerly.Domain.Entities;

public class Payment : BaseEntity
{
    public Guid OrganizationId { get; set; }
    public Guid BillId { get; set; }
    public Guid CustomerId { get; set; }
    public decimal Amount { get; set; }
    public DateTime PaymentDate { get; set; }
    public string? Reference { get; set; }
    public Guid? ReceiptFileId { get; set; }
    
    // Navigation properties
    public Organization Organization { get; set; } = null!;
    public Bill Bill { get; set; } = null!;
    public Customer Customer { get; set; } = null!;
    public ReceiptFile? ReceiptFile { get; set; }
}

