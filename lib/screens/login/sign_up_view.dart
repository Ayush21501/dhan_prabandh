import 'package:dhan_prabandh/common/color_extension.dart';
import 'package:dhan_prabandh/common_widget/primary_button.dart';
import 'package:dhan_prabandh/common_widget/round_textfield.dart';
import 'package:dhan_prabandh/common_widget/secondary_boutton.dart';
import 'package:dhan_prabandh/db/database_helper.dart';

import 'package:dhan_prabandh/db/model/sign_up_model.dart';
import 'package:dhan_prabandh/screens/login/sign_in_view.dart';
import 'package:dhan_prabandh/screens/splash_screen.dart';
import 'package:flutter/material.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final dbHelper = DatabaseHelper();
  final _formKey = GlobalKey<FormState>();

  TextEditingController txtName = TextEditingController();
  TextEditingController txtSurname = TextEditingController();
  TextEditingController txtPassword = TextEditingController();

  bool? _passwordError = false;
  // Future<bool> validatePassword(String password) async {
  //   bool isUnique = await dbHelper.isPasswordUnique(password);

  //   print(isUnique ? "true" : "false");
  //   return isUnique ? true : false;
  // }

  void signUp() async {
    String name = txtName.text;
    String surname = txtSurname.text;
    String password = txtPassword.text;

    // ignore: unnecessary_null_comparison
    if (name != null &&
        name != '' &&
        // ignore: unnecessary_null_comparison
        surname != null &&
        surname != '' &&
        // ignore: unnecessary_null_comparison
        password != null &&
        password != '') {
      // check if password is unique or not
      bool isUnique = await dbHelper.isPasswordUnique(password);
      if (!isUnique) {
        // print('Password is not unique. Please choose a different password.');

        setState(() {
          _passwordError = true;
        });
        return;
      }

      SignUp signUpData = SignUp(
        name: name,
        surname: surname,
        password: password,
      );
      int id = await dbHelper.insertSignUp(signUpData);
      print('Sign-up data inserted with id: $id');
      printAllSignUpData();
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        ),
      );
    }
  }

  // void signUp() async {
  //   if (_formKey.currentState!.validate()) {
  //     String name = txtName.text;
  //     String surname = txtSurname.text;
  //     String password = txtPassword.text;

  //     SignUp signUpData = SignUp(
  //       name: name,
  //       surname: surname,
  //       password: password,
  //     );
  //     int id = await dbHelper.insertSignUp(signUpData);
  //     print('Sign-up data inserted with id: $id');
  //     printAllSignUpData();

  //     // Clear form after successful sign-up
  //     txtName.clear();
  //     txtSurname.clear();
  //     txtPassword.clear();
  //     _passwordError = null; // Reset error message
  //   }
  // }

  void printAllSignUpData() async {
    List<SignUp> allSignUps = await dbHelper.getAllSignUps();
    print('--------------- All Sign-up Data: -----------------');
    allSignUps.forEach((signUp) {
      print(
          'ID: ${signUp.id}, Name: ${signUp.name}, Surname: ${signUp.surname}, Password: ${signUp.password}');
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: TColor.gray,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Dhan Prabandh",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: TColor.white, fontSize: 20),
                    ),
                  )
                ],
              ),
              const Spacer(),
              RoundTextField(
                title: "Name",
                controller: txtName,
                keyboardType: TextInputType.text,
                icon: const Icon(Icons.account_circle_outlined),
              ),
              const SizedBox(
                height: 15,
              ),
              RoundTextField(
                title: "Surname",
                controller: txtSurname,
                keyboardType: TextInputType.text,
                icon: const Icon(Icons.account_circle_outlined),
              ),
              const SizedBox(
                height: 15,
              ),
              RoundTextField(
                title: "Password",
                controller: txtPassword,
                obscureText: true,
                icon: const Icon(Icons.lock_outline),
                //  errorText: _passwordError
                //     ? 'This password is already taken. Please choose another one.'
                //     : null,
              ),
              const SizedBox(
                height: 24,
              ),
              if (_passwordError == true)
                Text(
                  "This password is already taken. Please choose another one.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: TColor.red, fontSize: 14),
                ),
              if (_passwordError == true)
                const SizedBox(
                  height: 24,
                ),
              PrimaryButton(
                title: "Sign Up",
                onPressed: signUp,
              ),
              const Spacer(),
              Text(
                "Do you have already an account?",
                textAlign: TextAlign.center,
                style: TextStyle(color: TColor.white, fontSize: 14),
              ),
              const SizedBox(
                height: 20,
              ),
              SecondaryButton(
                title: "Sign in",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignInView(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
