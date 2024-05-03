// ignore_for_file: camel_case_types

import 'package:dhan_prabandh/common/color_extension.dart';
import 'package:flutter/material.dart';

class AccountViewRefresh extends StatefulWidget {
  const AccountViewRefresh({super.key});

  @override
  State<AccountViewRefresh> createState() => _AccountViewRefreshState();
}

class _AccountViewRefreshState extends State<AccountViewRefresh> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.gray,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          "Accounts",
          style: TextStyle(color: TColor.white, fontSize: 18),
        ),
        leading: IconButton(
          padding: const EdgeInsets.only(left: 20.0),
          icon: Icon(Icons.arrow_back_ios, color: TColor.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: TColor.gray,
      // body goes here, if needed
    );
  }
}
