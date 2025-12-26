using Ledgerly.Application.DTOs.Bill;
using Ledgerly.Domain.Entities;
using Ledgerly.Persistence;
using Microsoft.EntityFrameworkCore;

namespace Ledgerly.Application.Services;

public class BillService : IBillService
{
    private readonly LedgerlyDbContext _context;

    public BillService(LedgerlyDbContext context)
    {
        _context = context;
    }

    public async Task<BillDto> CreateBillAsync(Guid organizationId, CreateBillRequest request)
    {
        // Verify customer belongs to organization
        var customer = await _context.Customers
            .FirstOrDefaultAsync(c => c.Id == request.CustomerId && c.OrganizationId == organizationId);

        if (customer == null)
        {
            throw new InvalidOperationException("Customer not found");
        }

        var bill = new Bill
        {
            OrganizationId = organizationId,
            CustomerId = request.CustomerId,
            BillNumber = request.BillNumber,
            TotalAmount = request.TotalAmount,
            OutstandingAmount = request.TotalAmount, // Initially equals total
            BillDate = request.BillDate,
            Status = "open"
        };

        _context.Bills.Add(bill);

        // Add bill items if provided
        if (request.Items != null && request.Items.Any())
        {
            foreach (var item in request.Items)
            {
                bill.Items.Add(new BillItem
                {
                    Description = item.Description,
                    Quantity = item.Quantity,
                    UnitPrice = item.UnitPrice,
                    Amount = item.Amount
                });
            }
        }

        await _context.SaveChangesAsync();

        return await GetBillByIdAsync(organizationId, bill.Id) ?? throw new Exception("Failed to create bill");
    }

    public async Task<List<BillDto>> GetBillsAsync(Guid organizationId, Guid? customerId = null, string? status = null)
    {
        var query = _context.Bills
            .Include(b => b.Customer)
            .Include(b => b.Items)
            .Where(b => b.OrganizationId == organizationId);

        if (customerId.HasValue)
        {
            query = query.Where(b => b.CustomerId == customerId.Value);
        }

        if (!string.IsNullOrEmpty(status))
        {
            query = query.Where(b => b.Status == status);
        }

        return await query
            .OrderByDescending(b => b.BillDate)
            .Select(b => new BillDto
            {
                Id = b.Id,
                OrganizationId = b.OrganizationId,
                CustomerId = b.CustomerId,
                CustomerName = b.Customer.Name,
                BillNumber = b.BillNumber,
                TotalAmount = b.TotalAmount,
                OutstandingAmount = b.OutstandingAmount,
                BillDate = b.BillDate,
                Status = b.Status,
                CreatedAt = b.CreatedAt,
                Items = b.Items.Select(i => new BillItemDto
                {
                    Id = i.Id,
                    Description = i.Description,
                    Quantity = i.Quantity,
                    UnitPrice = i.UnitPrice,
                    Amount = i.Amount
                }).ToList()
            })
            .ToListAsync();
    }

    public async Task<BillDto?> GetBillByIdAsync(Guid organizationId, Guid billId)
    {
        var bill = await _context.Bills
            .Include(b => b.Customer)
            .Include(b => b.Items)
            .FirstOrDefaultAsync(b => b.Id == billId && b.OrganizationId == organizationId);

        if (bill == null) return null;

        return new BillDto
        {
            Id = bill.Id,
            OrganizationId = bill.OrganizationId,
            CustomerId = bill.CustomerId,
            CustomerName = bill.Customer.Name,
            BillNumber = bill.BillNumber,
            TotalAmount = bill.TotalAmount,
            OutstandingAmount = bill.OutstandingAmount,
            BillDate = bill.BillDate,
            Status = bill.Status,
            CreatedAt = bill.CreatedAt,
            Items = bill.Items.Select(i => new BillItemDto
            {
                Id = i.Id,
                Description = i.Description,
                Quantity = i.Quantity,
                UnitPrice = i.UnitPrice,
                Amount = i.Amount
            }).ToList()
        };
    }
}

