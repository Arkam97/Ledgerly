import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/auth/login_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'providers/auth_provider.dart';

void main() {
  runApp(const ProviderScope(child: LedgerlyApp()));
}

class LedgerlyApp extends ConsumerWidget {
  const LedgerlyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return MaterialApp(
      title: 'Ledgerly',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0f766e), // Deep teal
          primary: const Color(0xFF0f766e),
          secondary: const Color(0xFFf59e0b), // Warm gold
        ),
        useMaterial3: true,
      ),
      home: authState.isAuthenticated
          ? const DashboardScreen()
          : const LoginScreen(),
    );
  }
}

