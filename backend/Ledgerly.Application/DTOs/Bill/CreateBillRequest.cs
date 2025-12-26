namespace Ledgerly.Application.DTOs.Bill;

public class CreateBillRequest
{
    public Guid CustomerId { get; set; }
    public string? BillNumber { get; set; }
    public decimal TotalAmount { get; set; }
    public DateTime BillDate { get; set; }
    public List<CreateBillItemRequest>? Items { get; set; }
}

