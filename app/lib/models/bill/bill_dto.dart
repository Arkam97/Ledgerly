import 'package:json_annotation/json_annotation.dart';
import 'bill_item_dto.dart';

part 'bill_dto.g.dart';

@JsonSerializable()
class BillDto {
  final String id;
  final String organizationId;
  final String customerId;
  final String customerName;
  final String? billNumber;
  final double totalAmount;
  final double outstandingAmount;
  @JsonKey(name: 'billDate')
  final DateTime billDate;
  final String status;
  @JsonKey(name: 'createdAt')
  final DateTime createdAt;
  final List<BillItemDto> items;

  BillDto({
    required this.id,
    required this.organizationId,
    required this.customerId,
    required this.customerName,
    this.billNumber,
    required this.totalAmount,
    required this.outstandingAmount,
    required this.billDate,
    required this.status,
    required this.createdAt,
    required this.items,
  });

  factory BillDto.fromJson(Map<String, dynamic> json) =>
      _$BillDtoFromJson(json);

  Map<String, dynamic> toJson() => _$BillDtoToJson(this);
}

