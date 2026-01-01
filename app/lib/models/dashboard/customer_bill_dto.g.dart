// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_bill_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerBillDto _$CustomerBillDtoFromJson(Map<String, dynamic> json) =>
    CustomerBillDto(
      billId: json['billId'] as String,
      billNumber: json['billNumber'] as String?,
      outstandingAmount: (json['outstandingAmount'] as num).toDouble(),
      billDate: DateTime.parse(json['billDate'] as String),
    );

Map<String, dynamic> _$CustomerBillDtoToJson(CustomerBillDto instance) =>
    <String, dynamic>{
      'billId': instance.billId,
      'billNumber': instance.billNumber,
      'outstandingAmount': instance.outstandingAmount,
      'billDate': instance.billDate.toIso8601String(),
    };
