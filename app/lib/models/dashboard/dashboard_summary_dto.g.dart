// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_summary_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashboardSummaryDto _$DashboardSummaryDtoFromJson(Map<String, dynamic> json) =>
    DashboardSummaryDto(
      totalOutstanding: (json['totalOutstanding'] as num).toDouble(),
      totalCustomersWithOpen: (json['totalCustomersWithOpen'] as num).toInt(),
      last30DaysPayments: (json['last30DaysPayments'] as num).toDouble(),
      topDebtors: (json['topDebtors'] as List<dynamic>)
          .map((e) => TopDebtorDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DashboardSummaryDtoToJson(
        DashboardSummaryDto instance) =>
    <String, dynamic>{
      'totalOutstanding': instance.totalOutstanding,
      'totalCustomersWithOpen': instance.totalCustomersWithOpen,
      'last30DaysPayments': instance.last30DaysPayments,
      'topDebtors': instance.topDebtors,
    };
