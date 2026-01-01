import 'package:json_annotation/json_annotation.dart';

part 'signup_request.g.dart';

@JsonSerializable()
class SignupRequest {
  final String organizationName;
  final String email;
  final String password;
  final String name;

  SignupRequest({
    required this.organizationName,
    required this.email,
    required this.password,
    required this.name,
  });

  factory SignupRequest.fromJson(Map<String, dynamic> json) =>
      _$SignupRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SignupRequestToJson(this);
}

