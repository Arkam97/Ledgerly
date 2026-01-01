// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_bill_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateBillRequest _$CreateBillRequestFromJson(Map<String, dynamic> json) =>
    CreateBillRequest(
      customerId: json['customerId'] as String,
      billNumber: json['billNumber'] as String?,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      billDate: DateTime.parse(json['billDate'] as String),
      items: (json['items'] as List<dynamic>?)
          ?.map(
              (e) => CreateBillItemRequest.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CreateBillRequestToJson(CreateBillRequest instance) =>
    <String, dynamic>{
      'customerId': instance.customerId,
      'billNumber': instance.billNumber,
      'totalAmount': instance.totalAmount,
      'billDate': instance.billDate.toIso8601String(),
      'items': instance.items,
    };
