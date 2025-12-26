using Ledgerly.Application.DTOs.Dashboard;

namespace Ledgerly.Application.Services;

public interface IDashboardService
{
    Task<DashboardSummaryDto> GetSummaryAsync(Guid organizationId);
    Task<List<OutstandingByCustomerDto>> GetOutstandingByCustomerAsync(Guid organizationId);
}

