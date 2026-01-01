// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_payment_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreatePaymentRequest _$CreatePaymentRequestFromJson(
        Map<String, dynamic> json) =>
    CreatePaymentRequest(
      billId: json['billId'] as String,
      customerId: json['customerId'] as String,
      amount: (json['amount'] as num).toDouble(),
      paymentDate: DateTime.parse(json['paymentDate'] as String),
      reference: json['reference'] as String?,
      receiptFileId: json['receiptFileId'] as String?,
    );

Map<String, dynamic> _$CreatePaymentRequestToJson(
        CreatePaymentRequest instance) =>
    <String, dynamic>{
      'billId': instance.billId,
      'customerId': instance.customerId,
      'amount': instance.amount,
      'paymentDate': instance.paymentDate.toIso8601String(),
      'reference': instance.reference,
      'receiptFileId': instance.receiptFileId,
    };
