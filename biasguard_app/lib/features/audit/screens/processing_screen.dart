import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/router/app_router.dart';
import 'dart:math' as math;

class ProcessingScreen extends StatefulWidget {
  final String scanId;
  final String fileName;

  const ProcessingScreen({
    super.key,
    required this.scanId,
    required this.fileName,
  });

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  int _currentStep = 0;
  
  final List<String> _steps = [
    AppStrings.processingStep1,
    AppStrings.processingStep2,
    AppStrings.processingStep3,
    AppStrings.processingStep4,
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _simulateProcessing();
  }

  void _simulateProcessing() async {
    for (int i = 0; i < _steps.length; i++) {
      if (!mounted) return;
      setState(() {
        _currentStep = i;
      });
      // specific step artificial delays
      await Future.delayed(Duration(milliseconds: i == 2 ? 3000 : 1500));
    }
    
    // Done simulating, navigate to Results
    if (mounted) {
      context.goNamed('results', extra: {'scanId': widget.scanId});
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Spinning Core
              AnimatedBuilder(
                animation: _animController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _animController.value * 2 * math.pi,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const SweepGradient(
                          colors: [
                            AppColors.gradientStart,
                            AppColors.gradientEnd,
                            AppColors.background,
                          ],
                          stops: [0.0, 0.5, 1.0],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.gradientStart.withOpacity(0.2),
                            blurRadius: 32,
                            spreadRadius: 8,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.surfaceContainerHigh,
                          ),
                          child: const Icon(Icons.auto_awesome, color: AppColors.primary, size: 48),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 64),
              
              // Status Text
              Text(
                'Scanning ${widget.fileName}...',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 48),

              // Steps List
              ...List.generate(_steps.length, (index) {
                final isPast = index < _currentStep;
                final isCurrent = index == _currentStep;
                final isFuture = index > _currentStep;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32.0),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isPast 
                              ? AppColors.tertiary
                              : isCurrent 
                                  ? AppColors.primaryContainer
                                  : AppColors.surfaceContainerHigh,
                        ),
                        child: Icon(
                          isPast ? Icons.check : (isCurrent ? Icons.circle : null),
                          size: 14,
                          color: isPast ? AppColors.onTertiary : Colors.white,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        _steps[index],
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: isPast || isCurrent 
                              ? AppColors.onSurface 
                              : AppColors.onSurfaceVariant,
                          fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      if (isCurrent)
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primary,
                          ),
                        )
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
