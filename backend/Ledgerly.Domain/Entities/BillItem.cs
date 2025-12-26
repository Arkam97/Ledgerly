namespace Ledgerly.Domain.Entities;

public class BillItem : BaseEntity
{
    public Guid BillId { get; set; }
    public string? Description { get; set; }
    public decimal? Quantity { get; set; }
    public decimal? UnitPrice { get; set; }
    public decimal? Amount { get; set; }
    
    // Navigation properties
    public Bill Bill { get; set; } = null!;
}

