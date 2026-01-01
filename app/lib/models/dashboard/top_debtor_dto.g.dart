// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'top_debtor_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TopDebtorDto _$TopDebtorDtoFromJson(Map<String, dynamic> json) => TopDebtorDto(
      customerId: json['customerId'] as String,
      customerName: json['customerName'] as String,
      outstanding: (json['outstanding'] as num).toDouble(),
    );

Map<String, dynamic> _$TopDebtorDtoToJson(TopDebtorDto instance) =>
    <String, dynamic>{
      'customerId': instance.customerId,
      'customerName': instance.customerName,
      'outstanding': instance.outstanding,
    };
