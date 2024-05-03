// New component for month and year selection
import 'package:dhan_prabandh/common/color_extension.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthYearPicker extends StatefulWidget {
  final DateTime initialDate; // Initial date to be displayed
  final List<int> years; // List of available years
  final Function(DateTime newDate) updateDateCallback;

  const MonthYearPicker({
    Key? key,
    required this.initialDate,
    required this.years,
    required this.updateDateCallback,
  }) : super(key: key);

  @override
  State<MonthYearPicker> createState() => _MonthYearPickerState();
}

class _MonthYearPickerState extends State<MonthYearPicker> {
  late DateTime _selectedDate; // Selected date

  @override
  void initState() {
    super.initState();
    _selectedDate =
        widget.initialDate; // Set initial date from widget parameter
  }

  void _changeYear(bool increment) {
    setState(() {
      int year = _selectedDate.year + (increment ? 1 : -1);
      if (widget.years.contains(year)) {
        _selectedDate = DateTime(year, _selectedDate.month);
      }
    });
  }

  void _selectMonth(int monthIndex) {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year, monthIndex + 1);
      widget.updateDateCallback(_selectedDate);
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.404,
        child: Column(
          children: [
            Container(
              color: TColor.gray80,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'THIS MONTH',
                      style: TextStyle(
                        color: TColor.white,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: TColor.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: TColor.gray80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: TColor.white),
                    onPressed: () => _changeYear(false),
                  ),
                  Text(
                    _selectedDate.year.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: TColor.white),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios, color: TColor.white),
                    onPressed: () => _changeYear(true),
                  ),
                ],
              ),
            ),
            Container(
              color: TColor.gray80,
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 4,
                children: List.generate(
                  12,
                  (index) => GestureDetector(
                    onTap: () => _selectMonth(index),
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(8),
                      child: Text(
                        DateFormat('MMM').format(DateTime(0, index + 1)),
                        style: TextStyle(
                          fontWeight: _selectedDate.month == index + 1
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: _selectedDate.month == index + 1
                              ? Colors.red
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
