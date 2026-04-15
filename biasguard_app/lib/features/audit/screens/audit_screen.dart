import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/router/app_router.dart';

class AuditScreen extends StatefulWidget {
  const AuditScreen({super.key});

  @override
  State<AuditScreen> createState() => _AuditScreenState();
}

class _AuditScreenState extends State<AuditScreen> {
  bool _isDragging = false;
  PlatformFile? _selectedFile;

  void _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
      allowMultiple: false,
    );

    if (result != null && result.files.isNotEmpty) {
      if (mounted) {
        setState(() {
          _selectedFile = result.files.first;
        });
        _startScan();
      }
    }
  }

  void _useDemoData(String name) {
    if (mounted) {
      context.pushNamed('processing', extra: {
        'fileName': name,
        'scanId': 'demo-scan-123',
      });
    }
  }

  void _startScan() {
    if (_selectedFile != null && mounted) {
      context.pushNamed('processing', extra: {
        'fileName': _selectedFile!.name,
        'scanId': 'new-scan-${DateTime.now().millisecondsSinceEpoch}',
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('New Bias Audit'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.uploadTitle,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              AppStrings.uploadSubtitle,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: 48),

            // Drop zone
            MouseRegion(
              onEnter: (_) => setState(() => _isDragging = true),
              onExit: (_) => setState(() => _isDragging = false),
              child: GestureDetector(
                onTap: _pickFile,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(64),
                  decoration: BoxDecoration(
                    color: _isDragging
                        ? AppColors.surfaceContainerLow
                        : AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: _isDragging
                          ? AppColors.primary
                          : AppColors.outlineVariant,
                      width: _isDragging ? 2 : 1,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerHigh,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.upload_file,
                            size: 48,
                            color: _isDragging
                                ? AppColors.primary
                                : AppColors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          AppStrings.dragDrop,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppStrings.uploadFormat,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: AppColors.onSurfaceVariant),
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton.icon(
                          onPressed: _pickFile,
                          icon: const Icon(Icons.folder_open),
                          label: const Text(AppStrings.browseFiles),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryContainer,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 64),
            Text(
              'Or try a demo dataset:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            
            // Demo dataset cards
            Row(
              children: [
                _DemoCard(
                  title: 'Bihar Scholarship 2026',
                  rows: '10,000',
                  icon: Icons.school,
                  onTap: () => _useDemoData('bihar_scholarship_2026.csv'),
                ),
                const SizedBox(width: 16),
                _DemoCard(
                  title: 'AI Hiring Algorithm',
                  rows: '5,000',
                  icon: Icons.work,
                  onTap: () => _useDemoData('hiring_bias_demo.csv'),
                ),
                const SizedBox(width: 16),
                _DemoCard(
                  title: 'Loan Applications',
                  rows: '2,500',
                  icon: Icons.real_estate_agent,
                  onTap: () => _useDemoData('loan_application_demo.csv'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _DemoCard extends StatelessWidget {
  final String title;
  final String rows;
  final IconData icon;
  final VoidCallback onTap;

  const _DemoCard({
    required this.title,
    required this.rows,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        color: AppColors.surfaceContainerLow,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.surfaceContainerHigh),
        ),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: AppColors.primary),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  '$rows rows · .csv',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: AppColors.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
