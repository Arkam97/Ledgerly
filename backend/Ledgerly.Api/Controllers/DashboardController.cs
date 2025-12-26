using Ledgerly.Application.DTOs.Dashboard;
using Ledgerly.Application.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Ledgerly.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class DashboardController : ControllerBase
{
    private readonly IDashboardService _dashboardService;

    public DashboardController(IDashboardService dashboardService)
    {
        _dashboardService = dashboardService;
    }

    private Guid GetOrganizationId()
    {
        var orgIdClaim = User.FindFirst("OrganizationId")?.Value;
        if (Guid.TryParse(orgIdClaim, out var orgId))
        {
            return orgId;
        }
        throw new UnauthorizedAccessException("Invalid organization");
    }

    [HttpGet("summary")]
    public async Task<ActionResult<DashboardSummaryDto>> GetSummary()
    {
        var organizationId = GetOrganizationId();
        var summary = await _dashboardService.GetSummaryAsync(organizationId);
        return Ok(summary);
    }

    [HttpGet("outstanding-by-customer")]
    public async Task<ActionResult<List<OutstandingByCustomerDto>>> GetOutstandingByCustomer()
    {
        var organizationId = GetOrganizationId();
        var outstanding = await _dashboardService.GetOutstandingByCustomerAsync(organizationId);
        return Ok(outstanding);
    }
}

