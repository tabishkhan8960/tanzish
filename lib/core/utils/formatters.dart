import 'package:intl/intl.dart';

import '../../shared/models/payment.dart';

final _currencyFormat = NumberFormat.currency(symbol: '₹', decimalDigits: 0);
final _dateFormat = DateFormat('d MMM yyyy');

String formatCurrency(num value) => _currencyFormat.format(value);

String formatDate(DateTime date) => _dateFormat.format(date.toLocal());

String paymentStatusLabel(PaymentStatus status) {
  switch (status) {
    case PaymentStatus.pending:
      return 'Verifying';
    case PaymentStatus.paid:
      return 'Paid';
    case PaymentStatus.failed:
      return 'Failed';
    case PaymentStatus.refunded:
      return 'Refunded';
  }
}
