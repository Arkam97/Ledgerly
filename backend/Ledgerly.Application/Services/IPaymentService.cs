using Ledgerly.Application.DTOs.Payment;

using Microsoft.AspNetCore.Http;

namespace Ledgerly.Application.Services;

public interface IPaymentService
{
    Task<PaymentDto> CreatePaymentAsync(Guid organizationId, CreatePaymentRequest request);
    Task<List<PaymentDto>> GetPaymentsAsync(Guid organizationId, Guid? customerId = null);
    Task<OcrUploadResponse> UploadReceiptForOcrAsync(Guid organizationId, Guid userId, IFormFile file);
}

