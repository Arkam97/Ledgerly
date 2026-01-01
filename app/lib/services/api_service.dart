import 'package:dio/dio.dart';
import '../config/api_config.dart';
import '../storage/auth_storage.dart';

class ApiService {
  late final Dio _dio;
  final AuthStorage _authStorage = AuthStorage();

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConfig.apiBaseUrl,
      connectTimeout: ApiConfig.connectTimeout,
      receiveTimeout: ApiConfig.receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    // Add interceptor for authentication token
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _authStorage.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (error, handler) {
        if (error.response?.statusCode == 401) {
          // Handle unauthorized - clear token and redirect to login
          _authStorage.clearToken();
        }
        return handler.next(error);
      },
    ));
  }

  Dio get dio => _dio;
}

