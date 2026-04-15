import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/locale_provider.dart';
import '../../audit/screens/audit_screen.dart';
import '../../direct_mode/screens/direct_mode_screen.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isHindi = ref.watch(localeProvider.notifier).isHindi;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.balance, color: AppColors.primary),
            const SizedBox(width: 12),
            Text(
              'BiasGuard',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
            ),
          ],
        ),
        actions: [
          // Language Toggle
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                _buildLangBtn('EN', !isHindi),
                _buildLangBtn('HI', isHindi),
              ],
            ),
          ),
          IconButton(
            onPressed: () => context.pushNamed('history'),
            icon: const Icon(Icons.history),
            tooltip: 'Audit History',
          ),
          IconButton(
            onPressed: () => context.pushNamed('settings'),
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
          ),
          const SizedBox(width: 8),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.onSurfaceVariant,
          tabs: const [
            Tab(text: 'Audit Mode'),
            Tab(text: 'Direct Mode'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          AuditScreen(),
          DirectModeScreen(),
        ],
      ),
    );
  }

  Widget _buildLangBtn(String label, bool active) {
    return GestureDetector(
      onTap: () => ref.read(localeProvider.notifier).toggleLocale(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : AppColors.onSurfaceVariant,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
