import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/bill/bill_dto.dart';
import '../models/bill/create_bill_request.dart';
import '../services/bill_service.dart';

final billServiceProvider = Provider<BillService>((ref) => BillService());

final billsProvider = FutureProvider.family<List<BillDto>, BillFilter>((ref, filter) async {
  final service = ref.read(billServiceProvider);
  return await service.getBills(
    customerId: filter.customerId,
    status: filter.status,
  );
});

final billProvider = FutureProvider.family<BillDto, String>((ref, id) async {
  final service = ref.read(billServiceProvider);
  return await service.getBillById(id);
});

final createBillProvider = FutureProvider.family<BillDto, CreateBillRequest>((ref, request) async {
  final service = ref.read(billServiceProvider);
  return await service.createBill(request);
});

class BillFilter {
  final String? customerId;
  final String? status;

  const BillFilter({this.customerId, this.status});
}

