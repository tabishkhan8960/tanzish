import 'dart:async';

import 'package:flutter/material.dart';

/// Ticks down to [target] once a second and renders "Xh Ym Zs remaining"
/// (or [expiredLabel] once it's passed). Used by the home page's "Deal of
/// the Day" section.
class CountdownTimer extends StatefulWidget {
  const CountdownTimer({super.key, required this.target, this.style, this.expiredLabel = 'Deal ended'});

  final DateTime target;
  final TextStyle? style;
  final String expiredLabel;

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Timer _timer;
  late Duration _remaining;

  @override
  void initState() {
    super.initState();
    _remaining = widget.target.difference(DateTime.now());
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _remaining = widget.target.difference(DateTime.now()));
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_remaining.isNegative) {
      return Text(widget.expiredLabel, style: widget.style);
    }
    final h = _remaining.inHours;
    final m = _remaining.inMinutes % 60;
    final s = _remaining.inSeconds % 60;
    return Text('${h}h ${m}m ${s}s remaining', style: widget.style);
  }
}
