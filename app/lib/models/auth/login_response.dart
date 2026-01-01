import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  final String token;
  final String refreshToken;
  final String userId;
  final String organizationId;
  final String email;
  final String role;

  LoginResponse({
    required this.token,
    required this.refreshToken,
    required this.userId,
    required this.organizationId,
    required this.email,
    required this.role,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

