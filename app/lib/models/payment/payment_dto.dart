import 'package:json_annotation/json_annotation.dart';

part 'payment_dto.g.dart';

@JsonSerializable()
class PaymentDto {
  final String id;
  final String organizationId;
  final String billId;
  final String customerId;
  final String customerName;
  final double amount;
  @JsonKey(name: 'paymentDate')
  final DateTime paymentDate;
  final String? reference;
  final String? receiptFileId;
  final String? receiptFileUrl;
  @JsonKey(name: 'createdAt')
  final DateTime createdAt;

  PaymentDto({
    required this.id,
    required this.organizationId,
    required this.billId,
    required this.customerId,
    required this.customerName,
    required this.amount,
    required this.paymentDate,
    this.reference,
    this.receiptFileId,
    this.receiptFileUrl,
    required this.createdAt,
  });

  factory PaymentDto.fromJson(Map<String, dynamic> json) =>
      _$PaymentDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentDtoToJson(this);
}

