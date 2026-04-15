import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/auth_service.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = AuthService().currentUid ?? 'anonymous';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Audit History'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .document(uid)
            .collection('scans')
            .orderBy('created_at', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return _buildEmptyState(context);
          }

          final docs = snapshot.data!.docs;

          return ListView(
            padding: const EdgeInsets.all(32.0),
            children: [
              Text(
                'Personal Audit Record',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'A unified log of all Bias Audits performed using your identity.',
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
                  children: List.generate(docs.length, (index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    final isLast = index == docs.length - 1;
                    
                    return Column(
                      children: [
                        _buildHistoryRow(context, docs[index].id, data),
                        if (!isLast) const Divider(height: 1),
                      ],
                    );
                  }),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history_toggle_off, size: 64, color: AppColors.onSurfaceVariant.withOpacity(0.5)),
          const SizedBox(height: 16),
          Text(
            'No audits yet',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: 8),
          const Text('Run your first CSV scan to see it here.'),
        ],
      ),
    );
  }

  Widget _buildHistoryRow(BuildContext context, String scanId, Map<String, dynamic> data) {
    final title = data['dataset_name'] ?? 'Untitled Scan';
    final status = data['status'] == 'analysis_complete' ? 'Complete' : (data['status']?.toString().toUpperCase() ?? 'Processing');
    final severity = (data['severity'] as String?)?.toUpperCase() ?? 'PENDING';
    
    Color statusColor = AppColors.onSurfaceVariant;
    if (severity == 'HIGH') statusColor = AppColors.error;
    if (severity == 'MEDIUM') statusColor = AppColors.moderateAmber;
    if (severity == 'LOW') statusColor = AppColors.tertiary;

    final timestamp = data['created_at'] != null 
        ? (data['created_at'] as Timestamp).toDate() 
        : DateTime.now();
    final dateStr = DateFormat('dd MMM yyyy').format(timestamp);

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
                Text(title, style: Theme.of(context).textTheme.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text('Usecase: ${data['use_case'] ?? 'General'}', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant)),
              ],
            ),
          ),
          Expanded(
            child: Text(dateStr, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.onSurfaceVariant)),
          ),
          Container(
            width: 120,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status == 'Complete' ? severity : status,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const SizedBox(width: 24),
          IconButton(
            onPressed: () {
              // Navigation to Results with this scanId
            },
            icon: const Icon(Icons.arrow_forward_ios, size: 16),
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

