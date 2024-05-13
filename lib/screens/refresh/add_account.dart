import 'package:dhan_prabandh/common/color_extension.dart';
import 'package:dhan_prabandh/common_widget/primary_button.dart';
import 'package:dhan_prabandh/common_widget/round_textfield.dart';
import 'package:dhan_prabandh/db/database_helper.dart';
import 'package:dhan_prabandh/db/model/account_model.dart';
import 'package:dhan_prabandh/db/model/sign_up_model.dart';
import 'package:flutter/material.dart';

class AddAccount extends StatefulWidget {
  final SignUp user;
  final Account? account; // Account object to edit, null if adding

  const AddAccount({Key? key, required this.user, this.account})
      : super(key: key);

  @override
  State<AddAccount> createState() => _AddAccountState();
}

class _AddAccountState extends State<AddAccount> {
  late TextEditingController accountNameController;
  late bool isEditing;

  @override
  void initState() {
    super.initState();
    isEditing = widget.account != null;
    accountNameController =
        TextEditingController(text: widget.account?.name ?? '');
  }

  void handleSubmit() async {
    try {
      Account account = Account(
        name: accountNameController.text,
        userId: widget.user.id ?? 0,
      );

      if (isEditing) {
        account.id = widget.account!.id; // Set the ID for editing
        await DatabaseHelper().updateAccount(account);
      } else {
        await DatabaseHelper().insertAccount(account);
      }

      accountNameController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: TColor.green,
          content: Text(
            isEditing
                ? "Account updated successfully!"
                : "Account added successfully!",
            style: TextStyle(color: TColor.gray80),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: TColor.red,
          content: Text(
            "An error occurred!",
            style: TextStyle(color: TColor.gray80),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
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
          isEditing ? "Edit Account" : "Add Account",
          style: TextStyle(color: TColor.white, fontSize: 18),
        ),
        leading: IconButton(
          padding: const EdgeInsets.only(left: 20.0),
          icon: Icon(Icons.arrow_back_ios, color: TColor.white),
          onPressed: () => Navigator.pop(context, true),
        ),
      ),
      backgroundColor: TColor.gray,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              RoundTextField(
                title: "Account Name",
                controller: accountNameController,
                obscureText: false,
                icon: Icon(Icons.account_balance_outlined, color: TColor.white),
              ),
              SizedBox(height: 30),
              PrimaryButton(
                  title: isEditing ? "Update Account" : "Add Account",
                  onPressed: handleSubmit)
            ],
          ),
        ),
      ),
    );
  }
}
