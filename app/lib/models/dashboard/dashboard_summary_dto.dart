import 'package:json_annotation/json_annotation.dart';
import 'top_debtor_dto.dart';

part 'dashboard_summary_dto.g.dart';

@JsonSerializable()
class DashboardSummaryDto {
  final double totalOutstanding;
  final int totalCustomersWithOpen;
  final double last30DaysPayments;
  final List<TopDebtorDto> topDebtors;

  DashboardSummaryDto({
    required this.totalOutstanding,
    required this.totalCustomersWithOpen,
    required this.last30DaysPayments,
    required this.topDebtors,
  });

  factory DashboardSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$DashboardSummaryDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DashboardSummaryDtoToJson(this);
}

