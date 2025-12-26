namespace Ledgerly.Application.DTOs.Payment;

public class CreatePaymentRequest
{
    public Guid BillId { get; set; }
    public Guid CustomerId { get; set; }
    public decimal Amount { get; set; }
    public DateTime PaymentDate { get; set; }
    public string? Reference { get; set; }
    public Guid? ReceiptFileId { get; set; }
}

