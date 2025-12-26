namespace Ledgerly.Application.DTOs.Bill;

public class CreateBillItemRequest
{
    public string? Description { get; set; }
    public decimal? Quantity { get; set; }
    public decimal? UnitPrice { get; set; }
    public decimal? Amount { get; set; }
}

