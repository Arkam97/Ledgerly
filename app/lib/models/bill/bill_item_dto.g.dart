// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BillItemDto _$BillItemDtoFromJson(Map<String, dynamic> json) => BillItemDto(
      id: json['id'] as String,
      description: json['description'] as String?,
      quantity: (json['quantity'] as num?)?.toDouble(),
      unitPrice: (json['unitPrice'] as num?)?.toDouble(),
      amount: (json['amount'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$BillItemDtoToJson(BillItemDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'quantity': instance.quantity,
      'unitPrice': instance.unitPrice,
      'amount': instance.amount,
    };
