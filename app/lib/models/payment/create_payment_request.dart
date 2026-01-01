import 'package:json_annotation/json_annotation.dart';

part 'create_payment_request.g.dart';

@JsonSerializable()
class CreatePaymentRequest {
  final String billId;
  final String customerId;
  final double amount;
  @JsonKey(name: 'paymentDate')
  final DateTime paymentDate;
  final String? reference;
  final String? receiptFileId;

  CreatePaymentRequest({
    required this.billId,
    required this.customerId,
    required this.amount,
    required this.paymentDate,
    this.reference,
    this.receiptFileId,
  });

  factory CreatePaymentRequest.fromJson(Map<String, dynamic> json) =>
      _$CreatePaymentRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreatePaymentRequestToJson(this);
}

