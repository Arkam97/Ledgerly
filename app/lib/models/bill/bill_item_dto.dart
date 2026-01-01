import 'package:json_annotation/json_annotation.dart';

part 'bill_item_dto.g.dart';

@JsonSerializable()
class BillItemDto {
  final String id;
  final String? description;
  final double? quantity;
  final double? unitPrice;
  final double? amount;

  BillItemDto({
    required this.id,
    this.description,
    this.quantity,
    this.unitPrice,
    this.amount,
  });

  factory BillItemDto.fromJson(Map<String, dynamic> json) =>
      _$BillItemDtoFromJson(json);

  Map<String, dynamic> toJson() => _$BillItemDtoToJson(this);
}

