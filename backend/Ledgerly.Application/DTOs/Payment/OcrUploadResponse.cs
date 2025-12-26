namespace Ledgerly.Application.DTOs.Payment;

public class OcrUploadResponse
{
    public Guid FileId { get; set; }
    public string FileUrl { get; set; } = string.Empty;
    public decimal? ParsedAmount { get; set; }
    public DateTime? ParsedDate { get; set; }
    public List<SuggestedBillDto> SuggestedBills { get; set; } = new();
}

public class SuggestedBillDto
{
    public Guid BillId { get; set; }
    public string? BillNumber { get; set; }
    public decimal Outstanding { get; set; }
    public DateTime BillDate { get; set; }
    public string CustomerName { get; set; } = string.Empty;
}

