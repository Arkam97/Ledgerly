import 'package:dio/dio.dart';
import '../config/api_config.dart';
import '../models/customer/customer_dto.dart';
import '../models/customer/create_customer_request.dart';
import 'api_service.dart';

class CustomerService {
  final ApiService _apiService = ApiService();

  Future<List<CustomerDto>> getCustomers() async {
    try {
      final response = await _apiService.dio.get('/customers');
      return (response.data as List)
          .map((json) => CustomerDto.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw Exception('Failed to fetch customers: ${e.message}');
    }
  }

  Future<CustomerDto> createCustomer(CreateCustomerRequest request) async {
    try {
      final response = await _apiService.dio.post(
        '/customers',
        data: request.toJson(),
      );
      return CustomerDto.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['message'] ?? 'Failed to create customer');
      }
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<CustomerDto> getCustomerById(String id) async {
    try {
      final response = await _apiService.dio.get('/customers/$id');
      return CustomerDto.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to fetch customer: ${e.message}');
    }
  }
}

