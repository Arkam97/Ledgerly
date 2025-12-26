using Ledgerly.Application.DTOs.Customer;

namespace Ledgerly.Application.Services;

public interface ICustomerService
{
    Task<CustomerDto> CreateCustomerAsync(Guid organizationId, CreateCustomerRequest request);
    Task<List<CustomerDto>> GetCustomersAsync(Guid organizationId);
    Task<CustomerDto?> GetCustomerByIdAsync(Guid organizationId, Guid customerId);
}

