// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentDto _$PaymentDtoFromJson(Map<String, dynamic> json) => PaymentDto(
      id: json['id'] as String,
      organizationId: json['organizationId'] as String,
      billId: json['billId'] as String,
      customerId: json['customerId'] as String,
      customerName: json['customerName'] as String,
      amount: (json['amount'] as num).toDouble(),
      paymentDate: DateTime.parse(json['paymentDate'] as String),
      reference: json['reference'] as String?,
      receiptFileId: json['receiptFileId'] as String?,
      receiptFileUrl: json['receiptFileUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$PaymentDtoToJson(PaymentDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'organizationId': instance.organizationId,
      'billId': instance.billId,
      'customerId': instance.customerId,
      'customerName': instance.customerName,
      'amount': instance.amount,
      'paymentDate': instance.paymentDate.toIso8601String(),
      'reference': instance.reference,
      'receiptFileId': instance.receiptFileId,
      'receiptFileUrl': instance.receiptFileUrl,
      'createdAt': instance.createdAt.toIso8601String(),
    };
