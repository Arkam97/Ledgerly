import 'package:json_annotation/json_annotation.dart';
import 'customer_bill_dto.dart';

part 'outstanding_by_customer_dto.g.dart';

@JsonSerializable()
class OutstandingByCustomerDto {
  final String customerId;
  final String customerName;
  final double totalOutstanding;
  @JsonKey(name: 'lastBillDate')
  final DateTime? lastBillDate;
  final int openBillsCount;
  final List<CustomerBillDto> bills;

  OutstandingByCustomerDto({
    required this.customerId,
    required this.customerName,
    required this.totalOutstanding,
    this.lastBillDate,
    required this.openBillsCount,
    required this.bills,
  });

  factory OutstandingByCustomerDto.fromJson(Map<String, dynamic> json) =>
      _$OutstandingByCustomerDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OutstandingByCustomerDtoToJson(this);
}

