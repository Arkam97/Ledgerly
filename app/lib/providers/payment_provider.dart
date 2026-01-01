import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/payment/payment_dto.dart';
import '../models/payment/create_payment_request.dart';
import '../services/payment_service.dart';

final paymentServiceProvider = Provider<PaymentService>((ref) => PaymentService());

final paymentsProvider = FutureProvider.family<List<PaymentDto>, String?>((ref, customerId) async {
  final service = ref.read(paymentServiceProvider);
  return await service.getPayments(customerId: customerId);
});

final createPaymentProvider = FutureProvider.family<PaymentDto, CreatePaymentRequest>((ref, request) async {
  final service = ref.read(paymentServiceProvider);
  return await service.createPayment(request);
});

