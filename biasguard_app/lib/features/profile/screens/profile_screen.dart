import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 48,
                  backgroundColor: AppColors.primary,
                  child: Text('SA', style: TextStyle(fontSize: 32, color: Colors.white)),
                ),
                const SizedBox(width: 32),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('System Admin', style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 8),
                    Text('admin@sentinel.biasguard.ai', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.onSurfaceVariant)),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.tertiary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text('Enterprise Plan', style: TextStyle(color: AppColors.tertiary, fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
              ],
            ),
            const SizedBox(height: 64),
            Text('Account Statistics', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: _buildStatCard(context, 'Total Audits Initiated', '47')),
                const SizedBox(width: 24),
                Expanded(child: _buildStatCard(context, 'Mitigation Rules Exported', '12')),
                const SizedBox(width: 24),
                Expanded(child: _buildStatCard(context, 'Direct Mode Queries', '109')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.onSurfaceVariant)),
          const SizedBox(height: 16),
          Text(value, style: Theme.of(context).textTheme.headlineLarge),
        ],
      ),
    );
  }
}
