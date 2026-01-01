import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/dashboard/dashboard_summary_dto.dart';
import '../models/dashboard/outstanding_by_customer_dto.dart';
import '../services/dashboard_service.dart';

final dashboardServiceProvider = Provider<DashboardService>((ref) => DashboardService());

final dashboardSummaryProvider = FutureProvider<DashboardSummaryDto>((ref) async {
  final service = ref.read(dashboardServiceProvider);
  return await service.getSummary();
});

final outstandingByCustomerProvider = FutureProvider<List<OutstandingByCustomerDto>>((ref) async {
  final service = ref.read(dashboardServiceProvider);
  return await service.getOutstandingByCustomer();
});

