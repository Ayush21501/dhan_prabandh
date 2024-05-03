import 'package:dhan_prabandh/common/color_extension.dart';
import 'package:flutter/material.dart';

class IncomeExpenseSettingView extends StatefulWidget {
  final String title; // Add a field for the title

  const IncomeExpenseSettingView({super.key, required this.title});

  @override
  State<IncomeExpenseSettingView> createState() =>
      _IncomeExpenseSettingViewState();
}

class _IncomeExpenseSettingViewState extends State<IncomeExpenseSettingView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.gray,
        title: Text(widget.title),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: TColor.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: TColor.gray,
      body: const Placeholder(),
    );
  }
}
