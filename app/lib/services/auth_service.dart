import 'package:dio/dio.dart';
import '../config/api_config.dart';
import '../models/auth/login_request.dart';
import '../models/auth/login_response.dart';
import '../models/auth/signup_request.dart';
import '../storage/auth_storage.dart';

class AuthService {
  final Dio _dio;
  final AuthStorage _authStorage = AuthStorage();

  AuthService() : _dio = Dio(BaseOptions(
    baseUrl: ApiConfig.apiBaseUrl,
    connectTimeout: ApiConfig.connectTimeout,
    receiveTimeout: ApiConfig.receiveTimeout,
    headers: {'Content-Type': 'application/json'},
  ));

  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: request.toJson(),
      );
      
      final loginResponse = LoginResponse.fromJson(response.data);
      
      // Save auth data
      await _authStorage.saveAuthData(
        token: loginResponse.token,
        refreshToken: loginResponse.refreshToken,
        userId: loginResponse.userId,
        organizationId: loginResponse.organizationId,
        email: loginResponse.email,
        role: loginResponse.role,
      );
      
      return loginResponse;
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['message'] ?? 'Login failed');
      }
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<LoginResponse> signup(SignupRequest request) async {
    try {
      final response = await _dio.post(
        '/auth/signup',
        data: request.toJson(),
      );
      
      final loginResponse = LoginResponse.fromJson(response.data);
      
      // Save auth data
      await _authStorage.saveAuthData(
        token: loginResponse.token,
        refreshToken: loginResponse.refreshToken,
        userId: loginResponse.userId,
        organizationId: loginResponse.organizationId,
        email: loginResponse.email,
        role: loginResponse.role,
      );
      
      return loginResponse;
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['message'] ?? 'Signup failed');
      }
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<void> logout() async {
    await _authStorage.clearToken();
  }
}

