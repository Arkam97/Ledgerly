using Ledgerly.Application.DTOs.Customer;
using Ledgerly.Domain.Entities;
using Ledgerly.Persistence;
using Microsoft.EntityFrameworkCore;

namespace Ledgerly.Application.Services;

public class CustomerService : ICustomerService
{
    private readonly LedgerlyDbContext _context;

    public CustomerService(LedgerlyDbContext context)
    {
        _context = context;
    }

    public async Task<CustomerDto> CreateCustomerAsync(Guid organizationId, CreateCustomerRequest request)
    {
        var customer = new Customer
        {
            OrganizationId = organizationId,
            Name = request.Name,
            Contact = request.Contact,
            Notes = request.Notes
        };

        _context.Customers.Add(customer);
        await _context.SaveChangesAsync();

        return new CustomerDto
        {
            Id = customer.Id,
            OrganizationId = customer.OrganizationId,
            Name = customer.Name,
            Contact = customer.Contact,
            Notes = customer.Notes,
            CreatedAt = customer.CreatedAt
        };
    }

    public async Task<List<CustomerDto>> GetCustomersAsync(Guid organizationId)
    {
        return await _context.Customers
            .Where(c => c.OrganizationId == organizationId)
            .OrderBy(c => c.Name)
            .Select(c => new CustomerDto
            {
                Id = c.Id,
                OrganizationId = c.OrganizationId,
                Name = c.Name,
                Contact = c.Contact,
                Notes = c.Notes,
                CreatedAt = c.CreatedAt
            })
            .ToListAsync();
    }

    public async Task<CustomerDto?> GetCustomerByIdAsync(Guid organizationId, Guid customerId)
    {
        var customer = await _context.Customers
            .FirstOrDefaultAsync(c => c.Id == customerId && c.OrganizationId == organizationId);

        if (customer == null) return null;

        return new CustomerDto
        {
            Id = customer.Id,
            OrganizationId = customer.OrganizationId,
            Name = customer.Name,
            Contact = customer.Contact,
            Notes = customer.Notes,
            CreatedAt = customer.CreatedAt
        };
    }
}

