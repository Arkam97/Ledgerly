// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_bill_item_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateBillItemRequest _$CreateBillItemRequestFromJson(
        Map<String, dynamic> json) =>
    CreateBillItemRequest(
      description: json['description'] as String?,
      quantity: (json['quantity'] as num?)?.toDouble(),
      unitPrice: (json['unitPrice'] as num?)?.toDouble(),
      amount: (json['amount'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$CreateBillItemRequestToJson(
        CreateBillItemRequest instance) =>
    <String, dynamic>{
      'description': instance.description,
      'quantity': instance.quantity,
      'unitPrice': instance.unitPrice,
      'amount': instance.amount,
    };
