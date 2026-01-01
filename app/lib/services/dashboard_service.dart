import 'package:dio/dio.dart';
import '../config/api_config.dart';
import '../models/dashboard/dashboard_summary_dto.dart';
import '../models/dashboard/outstanding_by_customer_dto.dart';
import 'api_service.dart';

class DashboardService {
  final ApiService _apiService = ApiService();

  Future<DashboardSummaryDto> getSummary() async {
    try {
      final response = await _apiService.dio.get('/dashboard/summary');
      return DashboardSummaryDto.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to fetch dashboard summary: ${e.message}');
    }
  }

  Future<List<OutstandingByCustomerDto>> getOutstandingByCustomer() async {
    try {
      final response = await _apiService.dio.get('/dashboard/outstanding-by-customer');
      return (response.data as List)
          .map((json) => OutstandingByCustomerDto.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw Exception('Failed to fetch outstanding by customer: ${e.message}');
    }
  }
}

