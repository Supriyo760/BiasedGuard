// BiasGuard — Main Entry Point
// Google Solution Challenge 2026

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase will be initialized here once flutterfire configure is run
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: BiasGuardApp()));
}

class BiasGuardApp extends ConsumerWidget {
  const BiasGuardApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      title: 'BiasGuard — FairAI for Every Decision',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark, // Dark by default (Sentinel Obsidian)
      routerConfig: router,
    );
  }
}
