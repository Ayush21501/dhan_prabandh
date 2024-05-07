import 'package:dhan_prabandh/common/color_extension.dart';
import 'package:dhan_prabandh/common_widget/primary_button.dart';
import 'package:dhan_prabandh/common_widget/round_textfield.dart';
import 'package:dhan_prabandh/common_widget/secondary_boutton.dart';
import 'package:dhan_prabandh/db/database_helper.dart';
import 'package:dhan_prabandh/db/model/sign_up_model.dart';
import 'package:dhan_prabandh/screens/home_screen.dart';
import 'package:dhan_prabandh/screens/login/sign_up_view.dart';
import 'package:flutter/material.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final dbHelper = DatabaseHelper();
  TextEditingController txtPassword = TextEditingController();
  bool isRemember = false;
  String? errorMessage;

  void handleSignIn() async {
    try {
      String password = txtPassword.text;
      SignUp? user = await dbHelper.findUserByPassword(password);

      // database 
      if (user != null) {
        // Navigate to WelcomePage or another page that takes a user object

        print(user.name + " " + user.surname);
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(user: user),
          ),
        );
      } else {
        setState(() {
          errorMessage = 'Please enter a valid password!';
        });
      }
    } catch (e) {
      print(" errror is $e");
    }
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
                title: "Password",
                controller: txtPassword,
                obscureText: true,
                icon: const Icon(Icons.lock_outline),
              ),
              if (errorMessage != null)
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      errorMessage!,
                      style: TextStyle(color: TColor.red, fontSize: 14),
                    )),
              const SizedBox(
                height: 20,
              ),
              PrimaryButton(
                title: "Sign In",
                onPressed: handleSignIn,
              ),
              const Spacer(),
              Text(
                "if you don't have an account yet?",
                textAlign: TextAlign.center,
                style: TextStyle(color: TColor.white, fontSize: 14),
              ),
              const SizedBox(
                height: 20,
              ),
              SecondaryButton(
                title: "Sign up",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUpView(),
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
