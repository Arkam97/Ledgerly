import 'package:json_annotation/json_annotation.dart';

part 'customer_bill_dto.g.dart';

@JsonSerializable()
class CustomerBillDto {
  final String billId;
  final String? billNumber;
  final double outstandingAmount;
  @JsonKey(name: 'billDate')
  final DateTime billDate;

  CustomerBillDto({
    required this.billId,
    this.billNumber,
    required this.outstandingAmount,
    required this.billDate,
  });

  factory CustomerBillDto.fromJson(Map<String, dynamic> json) =>
      _$CustomerBillDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerBillDtoToJson(this);
}

