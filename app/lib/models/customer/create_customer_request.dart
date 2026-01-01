import 'package:json_annotation/json_annotation.dart';

part 'create_customer_request.g.dart';

@JsonSerializable()
class CreateCustomerRequest {
  final String name;
  final String? contact;
  final String? notes;

  CreateCustomerRequest({
    required this.name,
    this.contact,
    this.notes,
  });

  factory CreateCustomerRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateCustomerRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateCustomerRequestToJson(this);
}

