using Ledgerly.Application.DTOs.Dashboard;
using Ledgerly.Persistence;
using Microsoft.EntityFrameworkCore;

namespace Ledgerly.Application.Services;

public class DashboardService : IDashboardService
{
    private readonly LedgerlyDbContext _context;

    public DashboardService(LedgerlyDbContext context)
    {
        _context = context;
    }

    public async Task<DashboardSummaryDto> GetSummaryAsync(Guid organizationId)
    {
        var openBills = await _context.Bills
            .Where(b => b.OrganizationId == organizationId && b.Status == "open")
            .ToListAsync();

        var totalOutstanding = openBills.Sum(b => b.OutstandingAmount);
        var totalCustomersWithOpen = openBills.Select(b => b.CustomerId).Distinct().Count();

        var thirtyDaysAgo = DateTime.UtcNow.AddDays(-30);
        var last30DaysPayments = await _context.Payments
            .Where(p => p.OrganizationId == organizationId && p.PaymentDate >= thirtyDaysAgo)
            .SumAsync(p => p.Amount);

        var topDebtors = await _context.Bills
            .Include(b => b.Customer)
            .Where(b => b.OrganizationId == organizationId && b.Status == "open")
            .GroupBy(b => new { b.CustomerId, b.Customer.Name })
            .Select(g => new TopDebtorDto
            {
                CustomerId = g.Key.CustomerId,
                CustomerName = g.Key.Name,
                Outstanding = g.Sum(b => b.OutstandingAmount)
            })
            .OrderByDescending(d => d.Outstanding)
            .Take(10)
            .ToListAsync();

        return new DashboardSummaryDto
        {
            TotalOutstanding = totalOutstanding,
            TotalCustomersWithOpen = totalCustomersWithOpen,
            Last30DaysPayments = last30DaysPayments,
            TopDebtors = topDebtors
        };
    }

    public async Task<List<OutstandingByCustomerDto>> GetOutstandingByCustomerAsync(Guid organizationId)
    {
        // Get customers with open bills, ordered by oldest last bill date
        var customersWithOpenBills = await _context.Customers
            .Where(c => c.OrganizationId == organizationId)
            .Select(c => new OutstandingByCustomerDto
            {
                CustomerId = c.Id,
                CustomerName = c.Name,
                TotalOutstanding = c.Bills
                    .Where(b => b.OrganizationId == organizationId && b.Status == "open")
                    .Sum(b => b.OutstandingAmount),
                LastBillDate = c.Bills
                    .Where(b => b.OrganizationId == organizationId && b.Status == "open")
                    .OrderByDescending(b => b.BillDate)
                    .Select(b => (DateTime?)b.BillDate)
                    .FirstOrDefault(),
                OpenBillsCount = c.Bills.Count(b => b.OrganizationId == organizationId && b.Status == "open"),
                Bills = c.Bills
                    .Where(b => b.OrganizationId == organizationId && b.Status == "open")
                    .OrderBy(b => b.BillDate)
                    .Select(b => new CustomerBillDto
                    {
                        BillId = b.Id,
                        BillNumber = b.BillNumber,
                        OutstandingAmount = b.OutstandingAmount,
                        BillDate = b.BillDate
                    })
                    .ToList()
            })
            .Where(c => c.TotalOutstanding > 0)
            .OrderBy(c => c.LastBillDate ?? DateTime.MinValue) // Oldest first
            .ToListAsync();

        return customersWithOpenBills;
    }
}

