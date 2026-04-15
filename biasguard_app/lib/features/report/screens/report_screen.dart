import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/pdf_service.dart';
import '../../../core/services/auth_service.dart';

class ReportScreen extends StatelessWidget {
  final String scanId;

  const ReportScreen({super.key, required this.scanId});

  @override
  Widget build(BuildContext context) {
    final uid = AuthService().currentUid ?? 'anonymous';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Export Report'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .document(uid)
            .collection('scans')
            .document(scanId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Audit data not found.'));
          }

          final scanData = snapshot.data!.data() as Map<String, dynamic>;
          final analysisData = scanData['analysis'] as Map<String, dynamic>? ?? {};
          final metrics = scanData['metrics'] as Map<String, dynamic>? ?? {};
          final equityScore = (metrics['equity_score'] ?? 0).toInt();

          return Center(
            child: Container(
              width: 800,
              margin: const EdgeInsets.all(48),
              padding: const EdgeInsets.all(64),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 24,
                    spreadRadius: 8,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.balance, size: 48, color: Color(0xFF13121C)),
                      Text('BiasGuard™ Official Audit',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.black)),
                    ],
                  ),
                  const SizedBox(height: 48),
                  const Divider(color: Colors.black12),
                  const SizedBox(height: 48),
                  Text('EXECUTIVE SUMMARY',
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium
                          ?.copyWith(color: Colors.grey[600], letterSpacing: 2)),
                  const SizedBox(height: 16),
                  Text(
                    analysisData['explanation_en'] ?? 'Loading analysis summary...',
                    style: const TextStyle(color: Colors.black87, height: 1.5, fontSize: 16),
                  ),
                  const SizedBox(height: 48),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          color: Colors.grey[100],
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Overall Equity Score', style: TextStyle(color: Colors.black54)),
                              const SizedBox(height: 8),
                              Text('$equityScore / 100',
                                  style: TextStyle(
                                      color: equityScore < 70 ? Colors.red : Colors.green,
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          color: Colors.grey[100],
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('Report Status', style: TextStyle(color: Colors.black54)),
                              const SizedBox(height: 8),
                              Text('Certified',
                                  style: TextStyle(color: Colors.green, fontSize: 32, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          PdfService.generateAuditReport(
                            scanId: scanId,
                            scanData: scanData,
                            analysisData: analysisData,
                          );
                        },
                        icon: const Icon(Icons.download),
                        label: const Text('Download Official PDF'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6366F1),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

