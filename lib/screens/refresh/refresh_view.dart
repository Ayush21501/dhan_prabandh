import 'package:dhan_prabandh/common/color_extension.dart';
import 'package:dhan_prabandh/db/model/sign_up_model.dart';
import 'package:dhan_prabandh/screens/refresh/accounts_view_refresh.dart';
import 'package:dhan_prabandh/screens/refresh/backup_view.dart';
import 'package:dhan_prabandh/screens/refresh/category_view.dart';
import 'package:flutter/material.dart';

class RefreshView extends StatefulWidget {
  final SignUp user; 
  const RefreshView({super.key, required this.user});

  @override
  State<RefreshView> createState() => _RefreshViewState();
}

class _RefreshViewState extends State<RefreshView> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.gray,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          "Settings",
          style: TextStyle(color: TColor.white, fontSize: 18),
        ),
        leading: IconButton(
          padding: const EdgeInsets.only(left: 20.0),
          icon: Icon(Icons.arrow_back_ios, color: TColor.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: TColor.gray,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: media.height * 0.36),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 200),
                        transitionsBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secondaryAnimation,
                            Widget child) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(1.0, 0.0),
                              end: const Offset(0.0, 0.0),
                            ).animate(animation),
                            child: child,
                          );
                        },
                        pageBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secondaryAnimation) {
                          return CategoryView(user: widget.user);
                        },
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Icon(Icons.category_outlined, color: TColor.white),
                      const SizedBox(height: 8),
                      Text(
                        'Categories',
                        style: TextStyle(
                          color: TColor.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 200),
                        transitionsBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secondaryAnimation,
                            Widget child) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(1.0, 0.0),
                              end: const Offset(0.0, 0.0),
                            ).animate(animation),
                            child: child,
                          );
                        },
                        pageBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secondaryAnimation) {
                          return const AccountViewRefresh();
                        },
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Icon(Icons.account_circle_outlined, color: TColor.white),
                      const SizedBox(height: 8),
                      Text(
                        'Accounts',
                        style: TextStyle(
                          color: TColor.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 200),
                        transitionsBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secondaryAnimation,
                            Widget child) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(1.0, 0.0),
                              end: const Offset(0.0, 0.0),
                            ).animate(animation),
                            child: child,
                          );
                        },
                        pageBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secondaryAnimation) {
                          return const BackupView();
                        },
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Icon(Icons.backup_outlined, color: TColor.white),
                      const SizedBox(height: 8),
                      Text(
                        'Backup',
                        style: TextStyle(
                          color: TColor.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
