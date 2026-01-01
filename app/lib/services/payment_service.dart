import 'dart:io';
import 'package:dio/dio.dart';
import '../config/api_config.dart';
import '../models/payment/payment_dto.dart';
import '../models/payment/create_payment_request.dart';
import 'api_service.dart';

class PaymentService {
  final ApiService _apiService = ApiService();

  Future<List<PaymentDto>> getPayments({String? customerId}) async {
    try {
      final queryParams = customerId != null ? {'customerId': customerId} : null;
      final response = await _apiService.dio.get(
        '/payments',
        queryParameters: queryParams,
      );
      
      return (response.data as List)
          .map((json) => PaymentDto.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw Exception('Failed to fetch payments: ${e.message}');
    }
  }

  Future<PaymentDto> createPayment(CreatePaymentRequest request) async {
    try {
      final response = await _apiService.dio.post(
        '/payments',
        data: request.toJson(),
      );
      return PaymentDto.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['message'] ?? 'Failed to create payment');
      }
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<Map<String, dynamic>> uploadReceiptForOcr(File file) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
      });

      final response = await _apiService.dio.post(
        '/payments/ocr',
        data: formData,
      );
      
      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['message'] ?? 'Failed to upload receipt');
      }
      throw Exception('Network error: ${e.message}');
    }
  }
}

