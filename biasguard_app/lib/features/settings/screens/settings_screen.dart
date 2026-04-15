import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('System Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(32),
        children: [
          Text('Preferences', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 24),
          _buildSwitchTile(context, 'Strict Parity Mode', 'Enforce highest constraints on Equal Opportunity automatically.', true),
          const Divider(),
          _buildSwitchTile(context, 'Data Anonymization', 'Automatically obfuscate PII before sending to Gemini API.', true),
          const Divider(),
          _buildSwitchTile(context, 'Export Reports to GCP', 'Automatically backup generated PDF reports to Google Cloud Storage bucket.', false),
          const SizedBox(height: 48),

          Text('API Connections', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 24),
          _buildApiTile(context, 'Gemini 1.5 Pro', 'Connected (Latency: 112ms)', AppColors.tertiary),
          _buildApiTile(context, 'Firebase Analytics', 'Connected', AppColors.tertiary),
          _buildApiTile(context, 'Workday Integration', 'Disconnected', AppColors.outlineVariant),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(BuildContext context, String title, String subtitle, bool value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(subtitle, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.onSurfaceVariant)),
              ],
            ),
          ),
          Switch(value: value, onChanged: (val) {}, activeColor: AppColors.primary),
        ],
      ),
    );
  }

  Widget _buildApiTile(BuildContext context, String name, String status, Color statusColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.surfaceContainerHighest),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: Theme.of(context).textTheme.titleMedium),
          Text(status, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: statusColor)),
        ],
      ),
    );
  }
}
