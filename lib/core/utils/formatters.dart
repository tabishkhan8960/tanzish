import 'package:intl/intl.dart';

final _currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
final _dateFormat = DateFormat('d MMM yyyy');

String formatCurrency(num value) => _currencyFormat.format(value);

String formatDate(DateTime date) => _dateFormat.format(date.toLocal());
