import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_theme.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('System Overview'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: AppColors.tertiary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'System Healthy',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.tertiary,
                      ),
                ),
              ],
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back, Sentinel.',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Your models have processed 12,408 decisions this week.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 48),

            // Top Quick Stats
            Row(
              children: [
                Expanded(child: _buildStatCard(context, 'Total Scans', '142', Icons.radar, AppColors.primary)),
                const SizedBox(width: 24),
                Expanded(child: _buildStatCard(context, 'Bias Mitigated', '3,480', Icons.shield, AppColors.tertiary)),
                const SizedBox(width: 24),
                Expanded(child: _buildStatCard(context, 'Critical Alerts', '2', Icons.warning_rounded, AppColors.error)),
              ],
            ),
            const SizedBox(height: 48),

            // Main Actions
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildActionCard(
                    context,
                    title: 'New Bias Audit',
                    subtitle: 'Upload a dataset to detect structural biases',
                    icon: Icons.upload_file,
                    color: AppColors.gradientStart,
                    onTap: () => context.goNamed('audit'),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _buildActionCard(
                    context,
                    title: 'Direct Mode',
                    subtitle: 'Get an immediate, neutral AI recommendation',
                    icon: Icons.psychology,
                    color: AppColors.secondaryContainer,
                    onTap: () => context.goNamed('direct-mode'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 48),

            // Recent Activity Activity
            Text(
              'Recent Scans',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildHistoryRow(context, 'Bihar_Scholarship_Q1.csv', 'Critical Bias', AppColors.error),
                  const Divider(),
                  _buildHistoryRow(context, 'Hiring_Tech_Roles_2025.csv', 'Fair', AppColors.tertiary),
                  const Divider(),
                  _buildHistoryRow(context, 'Loan_Approvals_North.csv', 'Moderate Bias', AppColors.moderateAmber),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceContainerHighest),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.surfaceContainerHighest),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(color: color.withOpacity(0.3)),
              ),
              child: Icon(icon, size: 32, color: color),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: AppColors.outlineVariant, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryRow(BuildContext context, String title, String status, Color statusColor) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          const Icon(Icons.insert_drive_file, color: AppColors.outline, size: 28),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text('Today at 10:42 AM', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const SizedBox(width: 24),
          TextButton(
            onPressed: () {},
            child: const Text('View Report'),
          ),
        ],
      ),
    );
  }
}
