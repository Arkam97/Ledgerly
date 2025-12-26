using Ledgerly.Application.DTOs.Bill;
using Ledgerly.Application.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Ledgerly.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class BillsController : ControllerBase
{
    private readonly IBillService _billService;

    public BillsController(IBillService billService)
    {
        _billService = billService;
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

    [HttpPost]
    public async Task<ActionResult<BillDto>> CreateBill([FromBody] CreateBillRequest request)
    {
        try
        {
            var organizationId = GetOrganizationId();
            var bill = await _billService.CreateBillAsync(organizationId, request);
            return CreatedAtAction(nameof(GetBill), new { id = bill.Id }, bill);
        }
        catch (InvalidOperationException ex)
        {
            return BadRequest(new { message = ex.Message });
        }
    }

    [HttpGet]
    public async Task<ActionResult<List<BillDto>>> GetBills([FromQuery] Guid? customerId, [FromQuery] string? status)
    {
        var organizationId = GetOrganizationId();
        var bills = await _billService.GetBillsAsync(organizationId, customerId, status);
        return Ok(bills);
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<BillDto>> GetBill(Guid id)
    {
        var organizationId = GetOrganizationId();
        var bill = await _billService.GetBillByIdAsync(organizationId, id);
        
        if (bill == null)
        {
            return NotFound();
        }
        
        return Ok(bill);
    }
}

