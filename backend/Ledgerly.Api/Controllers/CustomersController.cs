using Ledgerly.Application.DTOs.Customer;
using Ledgerly.Application.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace Ledgerly.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class CustomersController : ControllerBase
{
    private readonly ICustomerService _customerService;

    public CustomersController(ICustomerService customerService)
    {
        _customerService = customerService;
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
    public async Task<ActionResult<CustomerDto>> CreateCustomer([FromBody] CreateCustomerRequest request)
    {
        var organizationId = GetOrganizationId();
        var customer = await _customerService.CreateCustomerAsync(organizationId, request);
        return CreatedAtAction(nameof(GetCustomer), new { id = customer.Id }, customer);
    }

    [HttpGet]
    public async Task<ActionResult<List<CustomerDto>>> GetCustomers()
    {
        var organizationId = GetOrganizationId();
        var customers = await _customerService.GetCustomersAsync(organizationId);
        return Ok(customers);
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<CustomerDto>> GetCustomer(Guid id)
    {
        var organizationId = GetOrganizationId();
        var customer = await _customerService.GetCustomerByIdAsync(organizationId, id);
        
        if (customer == null)
        {
            return NotFound();
        }
        
        return Ok(customer);
    }
}

