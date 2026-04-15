import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/router/app_router.dart';
import '../../../core/services/auth_service.dart';
import 'dart:math' as math;

class ProcessingScreen extends StatefulWidget {
  final String scanId;
  final String fileName;
  final String storagePath;
  final bool isDemo;
  final String? useCase;

  const ProcessingScreen({
    super.key,
    required this.scanId,
    required this.fileName,
    required this.storagePath,
    this.isDemo = false,
    this.useCase,
  });

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  int _currentStep = 0;
  StreamSubscription? _statusSubscription;
  final AuthService _auth = AuthService();
  
  // Mapping backend statuses to our UI steps
  final Map<String, int> _statusMap = {
    'uploading': 0,
    'processing': 1,
    'detecting': 1,
    'calculating': 2,
    'metrics_complete': 2,
    'analysing': 3,
    'analysis_complete': 4,
    'error': -1,
  };

  final List<String> _steps = [
    AppStrings.processingStep1, // Data validation
    AppStrings.processingStep2, // Detecting Sensitive Groups
    AppStrings.processingStep3, // Calculating Metrics
    AppStrings.processingStep4, // AI Analysis
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    if (widget.isDemo) {
      _simulateProcessing();
    } else {
      _startRealProcessing();
    }
  }

  void _startRealProcessing() async {
    final uid = _auth.currentUid ?? 'anonymous';
    
    // 1. Trigger the Cloud Function (CF1)
    try {
      final response = await http.post(
        Uri.parse('https://us-central1-biasguard-2026.cloudfunctions.net/parseAndCalculateMetrics'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'uid': uid,
          'scan_id': widget.scanId,
          'storage_path': widget.storagePath,
          'dataset_name': widget.fileName,
          'use_case': widget.useCase ?? 'General Decision Making',
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to start processing: ${response.body}');
      }

      // 2. Listen to Firestore for status updates
      _statusSubscription = FirebaseFirestore.instance
          .collection('users')
          .document(uid)
          .collection('scans')
          .document(widget.scanId)
          .snapshots()
          .listen((snapshot) {
        if (!snapshot.exists || !mounted) return;

        final data = snapshot.data();
        final status = data?['status'] as String?;
        debugPrint('Scan Status Update: $status');

        if (status == 'error') {
          _handleError(data?['error_message'] ?? 'Unknown processing error');
          return;
        }

        if (status == 'analysis_complete') {
          // Success!
          _statusSubscription?.cancel();
          context.goNamed('results', extra: {'scanId': widget.scanId});
          return;
        }

        // Update UI step based on status
        final step = _statusMap[status] ?? _currentStep;
        if (mounted && step != -1) {
          setState(() {
            _currentStep = math.max(_currentStep, step);
          });
        }

        // Special case: if metrics are done, the backend will trigger CF2 (Gemini)
        // We just keep listening.
      });
    } catch (e) {
      _handleError(e.toString());
    }
  }

  void _handleError(String message) {
    if (!mounted) return;
    _statusSubscription?.cancel();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Processing Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Go Back'),
          ),
        ],
      ),
    ).then((_) {
      if (mounted) context.pop();
    });
  }

  void _simulateProcessing() async {
    for (int i = 0; i < _steps.length; i++) {
      if (!mounted) return;
      setState(() {
        _currentStep = i;
      });
      await Future.delayed(Duration(milliseconds: i == 2 ? 3000 : 1500));
    }
    if (mounted) {
      context.goNamed('results', extra: {'scanId': widget.scanId});
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    _statusSubscription?.cancel();
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
              // Spinning Core with Pulse
              AnimatedBuilder(
                animation: _animController,
                builder: (context, child) {
                  final pulseValue = 1.0 + (math.sin(_animController.value * 2 * math.pi) * 0.1);
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      // Pulse effect circles
                      ...List.generate(3, (i) {
                        final waveValue = (_animController.value + (i * 0.33)) % 1.0;
                        return Container(
                          width: 120 + (100 * waveValue),
                          height: 120 + (100 * waveValue),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.primary.withOpacity((1.0 - waveValue) * 0.3),
                              width: 2,
                            ),
                          ),
                        );
                      }),
                      
                      // Central Rotating Core
                      Transform.rotate(
                        angle: _animController.value * 2 * math.pi,
                        child: Transform.scale(
                          scale: pulseValue,
                          child: Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const SweepGradient(
                                colors: [
                                  AppColors.gradientStart,
                                  AppColors.gradientEnd,
                                  Colors.transparent,
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.4),
                                  blurRadius: 40,
                                  spreadRadius: 4,
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
                                child: const Icon(Icons.auto_awesome, color: AppColors.primary, size: 56),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
