namespace Ledgerly.Application.DTOs.Dashboard;

public class DashboardSummaryDto
{
    public decimal TotalOutstanding { get; set; }
    public int TotalCustomersWithOpen { get; set; }
    public decimal Last30DaysPayments { get; set; }
    public List<TopDebtorDto> TopDebtors { get; set; } = new();
}

public class TopDebtorDto
{
    public Guid CustomerId { get; set; }
    public string CustomerName { get; set; } = string.Empty;
    public decimal Outstanding { get; set; }
}

