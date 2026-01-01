import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/customer/customer_dto.dart';
import '../models/customer/create_customer_request.dart';
import '../services/customer_service.dart';

final customerServiceProvider = Provider<CustomerService>((ref) => CustomerService());

final customersProvider = FutureProvider<List<CustomerDto>>((ref) async {
  final service = ref.read(customerServiceProvider);
  return await service.getCustomers();
});

final customerProvider = FutureProvider.family<CustomerDto, String>((ref, id) async {
  final service = ref.read(customerServiceProvider);
  return await service.getCustomerById(id);
});

final createCustomerProvider = FutureProvider.family<CustomerDto, CreateCustomerRequest>((ref, request) async {
  final service = ref.read(customerServiceProvider);
  return await service.createCustomer(request);
});

