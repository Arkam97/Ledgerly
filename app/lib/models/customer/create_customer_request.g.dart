// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_customer_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateCustomerRequest _$CreateCustomerRequestFromJson(
        Map<String, dynamic> json) =>
    CreateCustomerRequest(
      name: json['name'] as String,
      contact: json['contact'] as String?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$CreateCustomerRequestToJson(
        CreateCustomerRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'contact': instance.contact,
      'notes': instance.notes,
    };
