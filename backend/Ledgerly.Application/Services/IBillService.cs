using Ledgerly.Application.DTOs.Bill;

namespace Ledgerly.Application.Services;

public interface IBillService
{
    Task<BillDto> CreateBillAsync(Guid organizationId, CreateBillRequest request);
    Task<List<BillDto>> GetBillsAsync(Guid organizationId, Guid? customerId = null, string? status = null);
    Task<BillDto?> GetBillByIdAsync(Guid organizationId, Guid billId);
}

