import 'package:json_annotation/json_annotation.dart';
import 'create_bill_item_request.dart';

part 'create_bill_request.g.dart';

@JsonSerializable()
class CreateBillRequest {
  final String customerId;
  final String? billNumber;
  final double totalAmount;
  @JsonKey(name: 'billDate')
  final DateTime billDate;
  final List<CreateBillItemRequest>? items;

  CreateBillRequest({
    required this.customerId,
    this.billNumber,
    required this.totalAmount,
    required this.billDate,
    this.items,
  });

  factory CreateBillRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateBillRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateBillRequestToJson(this);
}

