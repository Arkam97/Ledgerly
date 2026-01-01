class ApiConfig {
  // Update this to your backend URL
  // 
  // For Android Emulator, use: 'http://10.0.2.2:5042'
  // For iOS Simulator, use: 'http://localhost:5042'
  // For Physical Device, use your computer's IP: 'http://192.168.1.XXX:5042'
  // 
  // To find your IP on Windows: Open PowerShell and run 'ipconfig'
  // Look for "IPv4 Address" under your network adapter
  static const String baseUrl = 'http://10.0.2.2:5042'; // Default for Android Emulator
  static const String apiBaseUrl = '$baseUrl/api';
  
  // Timeout settings
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}

