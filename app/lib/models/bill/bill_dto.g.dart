// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BillDto _$BillDtoFromJson(Map<String, dynamic> json) => BillDto(
      id: json['id'] as String,
      organizationId: json['organizationId'] as String,
      customerId: json['customerId'] as String,
      customerName: json['customerName'] as String,
      billNumber: json['billNumber'] as String?,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      outstandingAmount: (json['outstandingAmount'] as num).toDouble(),
      billDate: DateTime.parse(json['billDate'] as String),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      items: (json['items'] as List<dynamic>)
          .map((e) => BillItemDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BillDtoToJson(BillDto instance) => <String, dynamic>{
      'id': instance.id,
      'organizationId': instance.organizationId,
      'customerId': instance.customerId,
      'customerName': instance.customerName,
      'billNumber': instance.billNumber,
      'totalAmount': instance.totalAmount,
      'outstandingAmount': instance.outstandingAmount,
      'billDate': instance.billDate.toIso8601String(),
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
      'items': instance.items,
    };
