// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'outstanding_by_customer_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OutstandingByCustomerDto _$OutstandingByCustomerDtoFromJson(
        Map<String, dynamic> json) =>
    OutstandingByCustomerDto(
      customerId: json['customerId'] as String,
      customerName: json['customerName'] as String,
      totalOutstanding: (json['totalOutstanding'] as num).toDouble(),
      lastBillDate: json['lastBillDate'] == null
          ? null
          : DateTime.parse(json['lastBillDate'] as String),
      openBillsCount: (json['openBillsCount'] as num).toInt(),
      bills: (json['bills'] as List<dynamic>)
          .map((e) => CustomerBillDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OutstandingByCustomerDtoToJson(
        OutstandingByCustomerDto instance) =>
    <String, dynamic>{
      'customerId': instance.customerId,
      'customerName': instance.customerName,
      'totalOutstanding': instance.totalOutstanding,
      'lastBillDate': instance.lastBillDate?.toIso8601String(),
      'openBillsCount': instance.openBillsCount,
      'bills': instance.bills,
    };
