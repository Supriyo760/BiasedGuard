import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_theme.dart';

class CounterfactualScreen extends StatefulWidget {
  final String scanId;

  const CounterfactualScreen({super.key, required this.scanId});

  @override
  State<CounterfactualScreen> createState() => _CounterfactualScreenState();
}

class _CounterfactualScreenState extends State<CounterfactualScreen> {
  double _reweightingAlpha = 0.5;
  bool _isSimulating = false;
  double _newEquityScore = 0.64; // Base score

  void _runSimulation() async {
    setState(() => _isSimulating = true);
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) {
      setState(() {
        _isSimulating = false;
        // Simulate an improvement based on alpha
        _newEquityScore = 0.64 + (_reweightingAlpha * 0.3); 
        if (_newEquityScore > 0.98) _newEquityScore = 0.98;
      });
    }
  }

  void _applyMitigation() async {
    setState(() => _isSimulating = true);
    await Future.delayed(const Duration(milliseconds: 1000));
    if (mounted) {
      setState(() => _isSimulating = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mitigation rules successfully applied to Model Configuration.'),
          backgroundColor: AppColors.tertiary,
        ),
      );
      context.goNamed('dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Counterfactual Simulator'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Panel: Controls
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(32),
              color: AppColors.surfaceContainerLow,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mitigation Controls',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Adjust reweighting penalities to observe predicted fairness outcomes without retraining the model.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 48),

                  Text('Target Proxy Feature', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primaryContainer),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.link_off, color: AppColors.primary),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'District_Code',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontFamily: 'monospace'),
                            ),
                            Text(
                              'Currently driving 42% of outcome variance',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Reweighting Alpha (α)', style: Theme.of(context).textTheme.titleLarge),
                      Text(
                        _reweightingAlpha.toStringAsFixed(2),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.primary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Slider(
                    value: _reweightingAlpha,
                    min: 0.0,
                    max: 1.0,
                    activeColor: AppColors.primary,
                    inactiveColor: AppColors.surfaceContainerHighest,
                    onChanged: (val) {
                      setState(() => _reweightingAlpha = val);
                    },
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('0.0 (No Mitigation)', style: Theme.of(context).textTheme.bodySmall),
                      Text('1.0 (Strict Parity)', style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                  const Spacer(),
                  
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSimulating ? null : _runSimulation,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        backgroundColor: AppColors.surfaceContainerHigh,
                        foregroundColor: AppColors.onSurface,
                      ),
                      child: _isSimulating
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Text('Simulate Outcomes'),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Right Panel: Live Results
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Predicted Equity Impact', style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 32),
                  
                  // Score Comparison
                  Row(
                    children: [
                      Expanded(
                        child: _buildScoreComparison(
                          context, 
                          title: 'Current Baseline', 
                          score: 0.64, 
                          color: AppColors.error,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Icon(Icons.arrow_forward, size: 32, color: AppColors.outlineVariant),
                      ),
                      Expanded(
                        child: _buildScoreComparison(
                          context, 
                          title: 'Simulated Outcome', 
                          score: _newEquityScore, 
                          color: _newEquityScore > 0.85 ? AppColors.tertiary : AppColors.moderateAmber,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 64),
                  
                  // Accuracy Tradeoff warning
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.moderateAmber.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.moderateAmber.withOpacity(0.3)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.info_outline, color: AppColors.moderateAmber),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Accuracy Trade-off Notice', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.moderateAmber)),
                              const SizedBox(height: 8),
                              Text(
                                'Applying an alpha of ${_reweightingAlpha.toStringAsFixed(2)} improves Demographic Parity by ${((_newEquityScore - 0.64) * 100).toStringAsFixed(1)}%, but is projected to reduce overall model utility (accuracy) by ${(_reweightingAlpha * 4.2).toStringAsFixed(1)}%.',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.onSurfaceVariant, height: 1.5),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _newEquityScore > 0.65 && !_isSimulating ? _applyMitigation : null,
                        icon: const Icon(Icons.check_circle),
                        label: const Text('Export & Apply Ruleset'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                          backgroundColor: AppColors.tertiary,
                          foregroundColor: AppColors.onTertiary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreComparison(BuildContext context, {required String title, required double score, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 2),
      ),
      child: Column(
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          Text(
            '${(score * 100).toInt()}',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text('Equity Score', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant)),
        ],
      ),
    );
  }
}
