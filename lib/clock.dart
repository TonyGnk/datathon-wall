import 'package:flutter/material.dart';
import 'dart:async';

class DigitalClock extends StatefulWidget {
  final double fontSize;
  final Color? textColor;
  final bool showSeconds;

  const DigitalClock({
    super.key,
    this.fontSize = 26,
    this.textColor,
    this.showSeconds = false,
  });

  @override
  State<DigitalClock> createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  late Timer _timer;
  late String _timeString;

  @override
  void initState() {
    super.initState();
    _timeString = _formatDateTime(DateTime.now());
    _timer =
        Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    setState(() {
      _timeString = formattedDateTime;
    });
  }

  String _formatDateTime(DateTime dateTime) {
    String hours = dateTime.hour.toString().padLeft(2, '0');
    String minutes = dateTime.minute.toString().padLeft(2, '0');
    String seconds = dateTime.second.toString().padLeft(2, '0');

    return widget.showSeconds ? "$hours:$minutes:$seconds" : "$hours:$minutes";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _timeString,
          style: TextStyle(
            fontSize: widget.fontSize,
            fontWeight: FontWeight.normal,
            color: widget.textColor,
          ),
        ),
      ],
    );
  }
}
