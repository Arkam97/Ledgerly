namespace Ledgerly.Application.DTOs.Customer;

public class CreateCustomerRequest
{
    public string Name { get; set; } = string.Empty;
    public string? Contact { get; set; }
    public string? Notes { get; set; }
}

