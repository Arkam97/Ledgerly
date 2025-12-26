namespace Ledgerly.Application.DTOs.Payment;

public class PaymentDto
{
    public Guid Id { get; set; }
    public Guid OrganizationId { get; set; }
    public Guid BillId { get; set; }
    public Guid CustomerId { get; set; }
    public string CustomerName { get; set; } = string.Empty;
    public decimal Amount { get; set; }
    public DateTime PaymentDate { get; set; }
    public string? Reference { get; set; }
    public Guid? ReceiptFileId { get; set; }
    public string? ReceiptFileUrl { get; set; }
    public DateTime CreatedAt { get; set; }
}

