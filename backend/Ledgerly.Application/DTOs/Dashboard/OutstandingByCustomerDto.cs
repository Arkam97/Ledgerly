namespace Ledgerly.Application.DTOs.Dashboard;

public class OutstandingByCustomerDto
{
    public Guid CustomerId { get; set; }
    public string CustomerName { get; set; } = string.Empty;
    public decimal TotalOutstanding { get; set; }
    public DateTime? LastBillDate { get; set; }
    public int OpenBillsCount { get; set; }
    public List<CustomerBillDto> Bills { get; set; } = new();
}

public class CustomerBillDto
{
    public Guid BillId { get; set; }
    public string? BillNumber { get; set; }
    public decimal OutstandingAmount { get; set; }
    public DateTime BillDate { get; set; }
}

