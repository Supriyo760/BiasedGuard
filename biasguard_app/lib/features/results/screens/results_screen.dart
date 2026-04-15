import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/router/app_router.dart';

class ResultsScreen extends StatelessWidget {
  final String scanId;

  const ResultsScreen({super.key, required this.scanId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Audit Results'),
        actions: [
          ElevatedButton.icon(
            onPressed: () => context.pushNamed('report', extra: {'scanId': scanId}),
            icon: const Icon(Icons.picture_as_pdf),
            label: const Text(AppStrings.downloadReport),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.surfaceContainerHigh,
              foregroundColor: AppColors.onSurface,
              elevation: 0,
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section: Score & Status
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildEquityScoreCard(context),
                const SizedBox(width: 24),
                Expanded(child: _buildBiasStatusCard(context)),
              ],
            ),
            const SizedBox(height: 32),

            // Middle Section: Proxy Detection & AI Explanation
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 1, child: _buildProxyDetection(context)),
                const SizedBox(width: 24),
                Expanded(flex: 2, child: _buildAiAnalysis(context)),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        color: AppColors.surfaceContainerLow,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton(
              onPressed: () => context.goNamed('dashboard'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                foregroundColor: AppColors.onSurface,
                side: const BorderSide(color: AppColors.outlineVariant),
              ),
              child: const Text('Return to Dashboard'),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () => context.pushNamed('counterfactual', extra: {'scanId': scanId}),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                backgroundColor: AppColors.gradientStart,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                AppStrings.fixBias,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEquityScoreCard(BuildContext context) {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            AppStrings.equityScore,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 32),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 160,
                height: 160,
                child: CircularProgressIndicator(
                  value: 0.64,
                  strokeWidth: 16,
                  backgroundColor: AppColors.surfaceContainerHighest,
                  color: AppColors.error,
                  strokeCap: StrokeCap.round,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '64',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          color: AppColors.error,
                          height: 1.0,
                        ),
                  ),
                  Text(
                    '/ 100',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.errorContainer.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.errorContainer),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 20),
                const SizedBox(width: 8),
                Text(
                  AppStrings.criticalBias,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.error,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBiasStatusCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Fairness Metrics Breakdown',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 24),
          _MetricRow(
            label: AppStrings.demographicParity,
            value: 0.45,
            statusColor: AppColors.error,
            statusText: 'Failed',
          ),
          const Divider(height: 32),
          _MetricRow(
            label: AppStrings.equalOpportunity,
            value: 0.62,
            statusColor: AppColors.moderateAmber,
            statusText: 'Warning',
          ),
          const Divider(height: 32),
          _MetricRow(
            label: AppStrings.equalizedOdds,
            value: 0.58,
            statusColor: AppColors.moderateAmber,
            statusText: 'Warning',
          ),
          const Divider(height: 32),
          _MetricRow(
            label: AppStrings.predictiveParity,
            value: 0.92,
            statusColor: AppColors.tertiary,
            statusText: 'Passed',
          ),
        ],
      ),
    );
  }

  Widget _buildProxyDetection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.proxyFeatures,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 24),
          _ProxyCard(
            feature: 'District_Code',
            proxyFor: 'Protected Group (Caste/Region)',
            correlation: '0.89',
          ),
          const SizedBox(height: 16),
          _ProxyCard(
            feature: 'Parent_Income_Bracket',
            proxyFor: 'Protected Group (Socio-Economic)',
            correlation: '0.74',
          ),
        ],
      ),
    );
  }

  Widget _buildAiAnalysis(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                AppStrings.aiAnalysis,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.primary,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Audit Pulse Component (subtle container with left accent)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              border: const Border(
                left: BorderSide(color: AppColors.primaryContainer, width: 4),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Analysis Summary",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.primary,
                      ),
                ),
                const SizedBox(height: 16),
                Text(
                  "The model exhibits systemic bias in the 'Demographic Parity' metric. Candidates from specific geographic regions (identified via 'District_Code') are being rejected at a 42% higher rate than the baseline.\n\nFurthermore, the system is utilizing 'Parent_Income_Bracket' as a proxy variable, effectively penalizing candidates despite their academic scores being identical to accepted peers.",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.6),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  final String label;
  final double value;
  final Color statusColor;
  final String statusText;

  const _MetricRow({
    required this.label,
    required this.value,
    required this.statusColor,
    required this.statusText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Expanded(
          flex: 3,
          child: Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: value,
                  backgroundColor: AppColors.surfaceContainerHighest,
                  color: statusColor,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                '${(value * 100).toInt()}%',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        SizedBox(
          width: 100,
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                statusText,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ProxyCard extends StatelessWidget {
  final String feature;
  final String proxyFor;
  final String correlation;

  const _ProxyCard({
    required this.feature,
    required this.proxyFor,
    required this.correlation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.surfaceContainerHighest),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                feature,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontFamily: 'monospace',
                    ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.errorContainer.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'r = $correlation',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.error,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Proxies for: $proxyFor',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}
