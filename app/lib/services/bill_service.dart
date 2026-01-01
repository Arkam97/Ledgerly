import 'package:dio/dio.dart';
import '../config/api_config.dart';
import '../models/bill/bill_dto.dart';
import '../models/bill/create_bill_request.dart';
import 'api_service.dart';

class BillService {
  final ApiService _apiService = ApiService();

  Future<List<BillDto>> getBills({
    String? customerId,
    String? status,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (customerId != null) queryParams['customerId'] = customerId;
      if (status != null) queryParams['status'] = status;

      final response = await _apiService.dio.get(
        '/bills',
        queryParameters: queryParams.isEmpty ? null : queryParams,
      );
      
      return (response.data as List)
          .map((json) => BillDto.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw Exception('Failed to fetch bills: ${e.message}');
    }
  }

  Future<BillDto> createBill(CreateBillRequest request) async {
    try {
      final response = await _apiService.dio.post(
        '/bills',
        data: request.toJson(),
      );
      return BillDto.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['message'] ?? 'Failed to create bill');
      }
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<BillDto> getBillById(String id) async {
    try {
      final response = await _apiService.dio.get('/bills/$id');
      return BillDto.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to fetch bill: ${e.message}');
    }
  }
}

