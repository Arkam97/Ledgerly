using Ledgerly.Application.DTOs.Payment;
using Ledgerly.Domain.Entities;
using Ledgerly.Infrastructure.Services;
using Ledgerly.Persistence;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;

namespace Ledgerly.Application.Services;

public class PaymentService : IPaymentService
{
    private readonly LedgerlyDbContext _context;
    private readonly IFileStorageService _fileStorageService;

    public PaymentService(LedgerlyDbContext context, IFileStorageService fileStorageService)
    {
        _context = context;
        _fileStorageService = fileStorageService;
    }

    public async Task<PaymentDto> CreatePaymentAsync(Guid organizationId, CreatePaymentRequest request)
    {
        // Verify bill belongs to organization and customer
        var bill = await _context.Bills
            .Include(b => b.Customer)
            .FirstOrDefaultAsync(b => b.Id == request.BillId 
                && b.OrganizationId == organizationId 
                && b.CustomerId == request.CustomerId);

        if (bill == null)
        {
            throw new InvalidOperationException("Bill not found");
        }

        // Validate payment amount
        if (request.Amount <= 0)
        {
            throw new InvalidOperationException("Payment amount must be greater than zero");
        }

        if (request.Amount > bill.OutstandingAmount)
        {
            throw new InvalidOperationException("Payment amount cannot exceed outstanding amount");
        }

        // Create payment
        var payment = new Payment
        {
            OrganizationId = organizationId,
            BillId = request.BillId,
            CustomerId = request.CustomerId,
            Amount = request.Amount,
            PaymentDate = request.PaymentDate,
            Reference = request.Reference,
            ReceiptFileId = request.ReceiptFileId
        };

        _context.Payments.Add(payment);

        // Update bill outstanding amount
        bill.OutstandingAmount -= request.Amount;

        // Mark bill as closed if outstanding is zero or less
        if (bill.OutstandingAmount <= 0)
        {
            bill.Status = "closed";
            bill.OutstandingAmount = 0; // Ensure it's not negative
        }

        await _context.SaveChangesAsync();

        // Reload with relations
        await _context.Entry(payment)
            .Reference(p => p.Customer)
            .LoadAsync();

        await _context.Entry(payment)
            .Reference(p => p.ReceiptFile)
            .LoadAsync();

        return new PaymentDto
        {
            Id = payment.Id,
            OrganizationId = payment.OrganizationId,
            BillId = payment.BillId,
            CustomerId = payment.CustomerId,
            CustomerName = payment.Customer.Name,
            Amount = payment.Amount,
            PaymentDate = payment.PaymentDate,
            Reference = payment.Reference,
            ReceiptFileId = payment.ReceiptFileId,
            ReceiptFileUrl = payment.ReceiptFile?.FileUrl,
            CreatedAt = payment.CreatedAt
        };
    }

    public async Task<List<PaymentDto>> GetPaymentsAsync(Guid organizationId, Guid? customerId = null)
    {
        var query = _context.Payments
            .Include(p => p.Customer)
            .Include(p => p.ReceiptFile)
            .Where(p => p.OrganizationId == organizationId);

        if (customerId.HasValue)
        {
            query = query.Where(p => p.CustomerId == customerId.Value);
        }

        return await query
            .OrderByDescending(p => p.PaymentDate)
            .Select(p => new PaymentDto
            {
                Id = p.Id,
                OrganizationId = p.OrganizationId,
                BillId = p.BillId,
                CustomerId = p.CustomerId,
                CustomerName = p.Customer.Name,
                Amount = p.Amount,
                PaymentDate = p.PaymentDate,
                Reference = p.Reference,
                ReceiptFileId = p.ReceiptFileId,
                ReceiptFileUrl = p.ReceiptFile != null ? p.ReceiptFile.FileUrl : null,
                CreatedAt = p.CreatedAt
            })
            .ToListAsync();
    }

    public async Task<OcrUploadResponse> UploadReceiptForOcrAsync(Guid organizationId, Guid userId, IFormFile file)
    {
        // Upload file
        var fileUrl = await _fileStorageService.UploadFileAsync(file, organizationId);

        // Create receipt file record
        var receiptFile = new ReceiptFile
        {
            OrganizationId = organizationId,
            FileUrl = fileUrl,
            UploadedBy = userId,
            UploadedAt = DateTime.UtcNow
        };

        _context.ReceiptFiles.Add(receiptFile);
        await _context.SaveChangesAsync();

        // Note: OCR parsing is done on the client side (Flutter ML Kit)
        // This endpoint just stores the file and returns metadata
        // The client will parse the file and send back the parsed amount/date

        // Get suggested bills for the organization (will be filtered by client based on customer match)
        var openBills = await _context.Bills
            .Include(b => b.Customer)
            .Where(b => b.OrganizationId == organizationId && b.Status == "open")
            .OrderByDescending(b => b.BillDate)
            .Take(10)
            .Select(b => new SuggestedBillDto
            {
                BillId = b.Id,
                BillNumber = b.BillNumber,
                Outstanding = b.OutstandingAmount,
                BillDate = b.BillDate,
                CustomerName = b.Customer.Name
            })
            .ToListAsync();

        return new OcrUploadResponse
        {
            FileId = receiptFile.Id,
            FileUrl = receiptFile.FileUrl,
            ParsedAmount = null, // Client will parse
            ParsedDate = null, // Client will parse
            SuggestedBills = openBills
        };
    }
}

