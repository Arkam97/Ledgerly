import 'package:json_annotation/json_annotation.dart';

part 'create_bill_item_request.g.dart';

@JsonSerializable()
class CreateBillItemRequest {
  final String? description;
  final double? quantity;
  final double? unitPrice;
  final double? amount;

  CreateBillItemRequest({
    this.description,
    this.quantity,
    this.unitPrice,
    this.amount,
  });

  factory CreateBillItemRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateBillItemRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateBillItemRequestToJson(this);
}

