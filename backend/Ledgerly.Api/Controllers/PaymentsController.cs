using Ledgerly.Application.DTOs.Payment;
using Ledgerly.Application.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace Ledgerly.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class PaymentsController : ControllerBase
{
    private readonly IPaymentService _paymentService;

    public PaymentsController(IPaymentService paymentService)
    {
        _paymentService = paymentService;
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

    private Guid GetUserId()
    {
        var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
        if (Guid.TryParse(userIdClaim, out var userId))
        {
            return userId;
        }
        throw new UnauthorizedAccessException("Invalid user");
    }

    [HttpPost]
    public async Task<ActionResult<PaymentDto>> CreatePayment([FromBody] CreatePaymentRequest request)
    {
        try
        {
            var organizationId = GetOrganizationId();
            var payment = await _paymentService.CreatePaymentAsync(organizationId, request);
            return CreatedAtAction(nameof(GetPayment), new { id = payment.Id }, payment);
        }
        catch (InvalidOperationException ex)
        {
            return BadRequest(new { message = ex.Message });
        }
    }

    [HttpGet]
    public async Task<ActionResult<List<PaymentDto>>> GetPayments([FromQuery] Guid? customerId)
    {
        var organizationId = GetOrganizationId();
        var payments = await _paymentService.GetPaymentsAsync(organizationId, customerId);
        return Ok(payments);
    }

    [HttpPost("ocr")]
    public async Task<ActionResult<OcrUploadResponse>> UploadReceiptForOcr(IFormFile file)
    {
        if (file == null || file.Length == 0)
        {
            return BadRequest(new { message = "File is required" });
        }

        try
        {
            var organizationId = GetOrganizationId();
            var userId = GetUserId();
            var response = await _paymentService.UploadReceiptForOcrAsync(organizationId, userId, file);
            return Ok(response);
        }
        catch (Exception ex)
        {
            return BadRequest(new { message = ex.Message });
        }
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<PaymentDto>> GetPayment(Guid id)
    {
        var organizationId = GetOrganizationId();
        var payments = await _paymentService.GetPaymentsAsync(organizationId);
        var payment = payments.FirstOrDefault(p => p.Id == id);
        
        if (payment == null)
        {
            return NotFound();
        }
        
        return Ok(payment);
    }
}

