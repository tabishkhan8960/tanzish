import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/formatters.dart';
import '../../../../../core/widgets/state_views.dart';
import '../../../../../shared/models/payment.dart';
import '../../../../../shared/repositories/transaction_repository.dart';

final adminTransactionsProvider = FutureProvider<List<Payment>>((ref) {
  return ref.watch(transactionRepositoryProvider).fetchAll();
});

Color _paymentStatusColor(PaymentStatus status) {
  switch (status) {
    case PaymentStatus.paid:
      return AppColors.success;
    case PaymentStatus.pending:
      return AppColors.warning;
    case PaymentStatus.failed:
    case PaymentStatus.refunded:
      return AppColors.error;
  }
}

class AdminTransactionsScreen extends ConsumerWidget {
  const AdminTransactionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(adminTransactionsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Transaction')),
      body: transactionsAsync.when(
        data: (payments) => payments.isEmpty
            ? const EmptyView(message: 'No transactions yet', icon: Icons.swap_horiz_outlined)
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Provider')),
                    DataColumn(label: Text('Reference')),
                    DataColumn(label: Text('Amount')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Paid At')),
                  ],
                  rows: [
                    for (final p in payments)
                      DataRow(cells: [
                        DataCell(Text(p.provider)),
                        DataCell(Text(p.transactionRef ?? p.id.substring(0, 8))),
                        DataCell(Text(formatCurrency(p.amount))),
                        DataCell(Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: _paymentStatusColor(p.status).withValues(alpha: 0.12), borderRadius: BorderRadius.circular(20)),
                          child: Text(p.status.name, style: TextStyle(color: _paymentStatusColor(p.status), fontWeight: FontWeight.w600, fontSize: 12)),
                        )),
                        DataCell(Text(p.paidAt != null ? formatDate(p.paidAt!) : '—')),
                      ]),
                  ],
                ),
              ),
        loading: () => const LoadingView(),
        error: (e, _) => const ErrorView(message: 'Could not load transactions'),
      ),
    );
  }
}
