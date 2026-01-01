import 'package:json_annotation/json_annotation.dart';

part 'top_debtor_dto.g.dart';

@JsonSerializable()
class TopDebtorDto {
  final String customerId;
  final String customerName;
  final double outstanding;

  TopDebtorDto({
    required this.customerId,
    required this.customerName,
    required this.outstanding,
  });

  factory TopDebtorDto.fromJson(Map<String, dynamic> json) =>
      _$TopDebtorDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TopDebtorDtoToJson(this);
}

