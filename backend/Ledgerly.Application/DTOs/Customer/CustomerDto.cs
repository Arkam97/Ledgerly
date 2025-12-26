namespace Ledgerly.Application.DTOs.Customer;

public class CustomerDto
{
    public Guid Id { get; set; }
    public Guid OrganizationId { get; set; }
    public string Name { get; set; } = string.Empty;
    public string? Contact { get; set; }
    public string? Notes { get; set; }
    public DateTime CreatedAt { get; set; }
}

