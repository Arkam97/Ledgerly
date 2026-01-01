import 'package:json_annotation/json_annotation.dart';

part 'customer_dto.g.dart';

@JsonSerializable()
class CustomerDto {
  final String id;
  final String organizationId;
  final String name;
  final String? contact;
  final String? notes;
  @JsonKey(name: 'createdAt')
  final DateTime createdAt;

  CustomerDto({
    required this.id,
    required this.organizationId,
    required this.name,
    this.contact,
    this.notes,
    required this.createdAt,
  });

  factory CustomerDto.fromJson(Map<String, dynamic> json) =>
      _$CustomerDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerDtoToJson(this);
}

