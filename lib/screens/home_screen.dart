import 'package:dhan_prabandh/add_expense/add_expense.dart';
import 'package:dhan_prabandh/common/color_extension.dart';
import 'package:dhan_prabandh/db/model/sign_up_model.dart';
import 'package:dhan_prabandh/screens/home/transaction_view.dart';
import 'package:dhan_prabandh/screens/refresh/refresh_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  final SignUp user; // Add this line to accept the user parameter

  const HomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectTab = 0;
  PageStorageBucket pageStorageBucket = PageStorageBucket();
  Widget currentTabView = const TransactionView(); // navigation

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.gray,
      body: Stack(children: [
        PageStorage(bucket: pageStorageBucket, child: currentTabView),
        SafeArea(
          child: Column(
            children: [
              const Spacer(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset("assets/img/bottom_bar_bg.png"),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  selectTab = 0;
                                  currentTabView = const TransactionView();
                                });
                              },
                              icon: Image.asset(
                                "assets/img/home.png",
                                width: 20,
                                height: 20,
                                color: selectTab == 0
                                    ? TColor.white
                                    : TColor.gray30,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  selectTab = 1;
                                  // currentTabView = const SpendingBudgetsView();
                                });
                              },
                              icon: Image.asset(
                                "assets/img/barchart.png",
                                width: 20,
                                height: 20,
                                color: selectTab == 1
                                    ? TColor.white
                                    : TColor.gray30,
                              ),
                            ),
                            const SizedBox(
                              width: 50,
                              height: 50,
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  selectTab = 2;
                                  // currentTabView = CalenderView();
                                });
                              },
                              icon: Icon(
                                Icons.account_balance_outlined,
                                color: selectTab == 2
                                    ? TColor.white
                                    : TColor.gray30,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  selectTab = 3;
                                  currentTabView =  RefreshView(user:widget.user) ;
                                });
                              },
                              icon: Image.asset(
                                "assets/img/cog.png",
                                width: 20,
                                height: 20,
                                color: selectTab == 3
                                    ? TColor.white
                                    : TColor.gray30,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const AddSubScriptionView(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              return FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0, 1),
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: child,
                                ),
                              );
                            },
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: TColor.secondary.withOpacity(0),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ],
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Image.asset(
                          "assets/img/center_btn.png",
                          width: 55,
                          height: 55,
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ]),
    );
  }
}
