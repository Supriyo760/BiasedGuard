import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_theme.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Audit History'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(32.0),
        children: [
          Text(
            'Complete Organization Record',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'A unified log of all Bias Audits performed across your connected models.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 48),

          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _buildHistoryRow(context, 'Bihar_Scholarship_Q1.csv', 'Critical Bias', AppColors.error, 'Internal Database', '15 Apr 2026'),
                const Divider(height: 1),
                _buildHistoryRow(context, 'Hiring_Tech_Roles_2025.csv', 'Fair', AppColors.tertiary, 'Workday ATS', '14 Apr 2026'),
                const Divider(height: 1),
                _buildHistoryRow(context, 'Loan_Approvals_North.csv', 'Moderate Bias', AppColors.moderateAmber, 'Loan Origination DB', '10 Apr 2026'),
                const Divider(height: 1),
                 _buildHistoryRow(context, 'Credit_Scoring_V3.csv', 'Fair', AppColors.tertiary, 'Data Warehouse', '28 Mar 2026'),
                const Divider(height: 1),
                 _buildHistoryRow(context, 'Ad_Targeting_Metrics.csv', 'Moderate Bias', AppColors.moderateAmber, 'Campaign Manager', '15 Mar 2026'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryRow(BuildContext context, String title, String status, Color statusColor, String source, String date) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.history, color: AppColors.primary),
          ),
          const SizedBox(width: 20),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text('Source: $source', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant)),
              ],
            ),
          ),
          Expanded(
            child: Text(date, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.onSurfaceVariant)),
          ),
          Container(
            width: 120,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status,
              textAlign: TextAlign.center,
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
