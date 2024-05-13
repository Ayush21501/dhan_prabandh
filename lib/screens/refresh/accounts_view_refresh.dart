// ignore_for_file: camel_case_types

import 'package:dhan_prabandh/common/color_extension.dart';
import 'package:dhan_prabandh/common_widget/category_list_item.dart';
import 'package:dhan_prabandh/db/database_helper.dart';
import 'package:dhan_prabandh/db/model/account_model.dart';
import 'package:dhan_prabandh/db/model/sign_up_model.dart';
import 'package:dhan_prabandh/screens/refresh/add_account.dart';
import 'package:flutter/material.dart';

class AccountViewRefresh extends StatefulWidget {
  final SignUp user;

  const AccountViewRefresh({super.key, required this.user});

  @override
  State<AccountViewRefresh> createState() => _AccountViewRefreshState();
}

class _AccountViewRefreshState extends State<AccountViewRefresh> {
  late Future<List<Account>> _accountFuture;
  bool _shouldRefresh = false;

  @override
  void initState() {
    super.initState();
    _accountFuture = _fetchAccount();
  }

  Future<List<Account>> _fetchAccount() async {
    int userId = widget.user.id ?? 0;
    print("my userid is $userId");
    return DatabaseHelper().getAccounts(userId);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_shouldRefresh) {
      setState(() {
        _accountFuture = _fetchAccount();
        _shouldRefresh = false;
      });
    }
  }

  void _deleteAccount(BuildContext context, int accountId) async {
    // Show the confirmation dialog
    bool delete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: TColor.white,
          title: Text("Confirm Delete"),
          content: Text("Are you sure you want to delete this Account?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancle", style: TextStyle(color: TColor.gray80)),
              onPressed: () {
                Navigator.of(context)
                    .pop(false); // Dismisses only the dialog and returns false
              },
            ),
            TextButton(
              child: Text("Delete", style: TextStyle(color: TColor.red)),
              onPressed: () {
                Navigator.of(context)
                    .pop(true); // Dismisses the dialog and returns true
              },
            ),
          ],
        );
      },
    );

    // If the user confirmed, delete the account
    if (delete) {
      await DatabaseHelper().deleteAccount(accountId);
      setState(() {
        _accountFuture = _fetchAccount();
      });
    }
  }

  void _editAccount(BuildContext context, Account account) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddAccount(account: account, user: widget.user),
      ),
    );
    if (result == true) {
      setState(() {
        _accountFuture = _fetchAccount();
      });
    }
  }

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
        actions: <Widget>[
          IconButton(
              padding: const EdgeInsets.only(right: 20.0),
              icon: Icon(Icons.add, color: TColor.white),
              onPressed: () async {
                final result2 = await Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 200),
                    transitionsBuilder: (BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation,
                        Widget child) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.0, 1.0),
                          end: const Offset(0.0, 0.0),
                        ).animate(animation),
                        child: child,
                      );
                    },
                    pageBuilder: (BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation) {
                      return AddAccount(
                        user: widget.user,
                      );
                    },
                  ),
                );

                if (result2 == true) {
                  setState(() {
                    _accountFuture = _fetchAccount();
                  });
                }
              }),
        ],
      ),
      backgroundColor: TColor.gray,
      body: FutureBuilder<List<Account>>(
        future: _accountFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: TColor.white,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading Account',
                style: TextStyle(color: TColor.white),
              ),
            );
          } else {
            List<Account>? categories = snapshot.data;
            if (categories != null && categories.isNotEmpty) {
              return ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  Account account = categories[index];
                  return CategoryListItem(
                    categoryName: account.name,
                    categoryType: "",
                    onEditPressed: () => _editAccount(context, account),
                    onDeletePressed: () =>
                        _deleteAccount(context, account.id ?? 0),
                  );
                },
              );
            } else {
              return Center(
                child: Text(
                  'No Account found',
                  style: TextStyle(color: TColor.white),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
