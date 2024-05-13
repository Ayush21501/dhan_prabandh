import 'package:dhan_prabandh/common/color_extension.dart';
import 'package:dhan_prabandh/common_widget/custom_arc_painter.dart';
import 'package:dhan_prabandh/common_widget/month_year_calender.dart';
import 'package:dhan_prabandh/common_widget/segment_button.dart';
import 'package:dhan_prabandh/common_widget/status_button.dart';
import 'package:dhan_prabandh/common_widget/subscription_home_row.dart';
import 'package:dhan_prabandh/common_widget/upcoming_bill_row.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionView extends StatefulWidget {
  const TransactionView({super.key});

  @override
  State<TransactionView> createState() => _TransactionViewState();
}

class _TransactionViewState extends State<TransactionView> {
  List<int> yearArr = [
    for (int year in Iterable<int>.generate(59)) 2022 + year,
  ];

  List expenseArr = [
    {
      "description": "First note example is add",
      "category": "abc defg",
      "price": "154237",
      "type": "Cash",
    },
    {
      "description": "Second example is add",
      "category": "xyzw kmn",
      "price": "12345",
      "type": "Bank",
    }
  ];

  List trasactionArr = [
    {
      "description": "transfter abc",
      "account_sender": "abc",
      "account_reciever": "mno",
      "price": "154237"
    },
    {
      "description": "transfter pqr",
      "account_sender": "abc",
      "account_reciever": "mno",
      "price": "264"
    },
  ];

  String selectedTab = "Income";
  var selectedDate = DateTime.now();
  var monthIs = "may";
  var showDate = "";

  String showMonthsFun(DateTime dates) {
    switch (DateFormat('MM').format(dates)) {
      case "01":
        monthIs = "Jan";
      case "02":
        monthIs = "Feb";
      case "03":
        monthIs = "Mar";
      case "04":
        monthIs = "Apr";
      case "05":
        monthIs = "May";
      case "06":
        monthIs = "Jun";
      case "07":
        monthIs = "Jul";
      case "08":
        monthIs = "Aug";
      case "09":
        monthIs = "Sep";
      case "10":
        monthIs = "Oct";
      case "11":
        monthIs = "Nov";
      case "12":
        monthIs = "Dec";
    }
    showDate = "$monthIs  ${dates.year}";
    return showDate;
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);

    void _updateDate(DateTime newDate) {
      setState(() {
        selectedDate = newDate;
        showDate = showMonthsFun(newDate);
      });
    }

    if (showDate == "") {
      showDate = showMonthsFun(DateTime.now());
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.gray70.withOpacity(0.5),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: TColor.white),
                  onPressed: () {
                    _updateDate(selectedDate =
                        DateTime(selectedDate.year, selectedDate.month - 1));
                  },
                ),
                TextButton(
                  onPressed: () async {
                    final newDate = await showDialog(
                      context: context,
                      builder: (context) => MonthYearPicker(
                        initialDate: selectedDate,
                        years: yearArr,
                        updateDateCallback: _updateDate,
                      ),
                    );
                    if (newDate != null) {
                      _updateDate(newDate);
                    }
                  },
                  child: Text(
                    showDate,
                    style: TextStyle(color: TColor.white, fontSize: 18),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward_ios, color: TColor.white),
                  onPressed: () {
                    _updateDate(selectedDate =
                        DateTime(selectedDate.year, selectedDate.month + 1));
                  },
                ),
              ],
            ),

            // Settings Icon
            IconButton(
              icon: Icon(Icons.account_circle_sharp, color: TColor.white),
              onPressed: () {
                // Navigate to settings page or open settings modal
              },
            ),
          ],
        ),
      ),
      backgroundColor: TColor.gray,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: media.width * 1.1,
              decoration: BoxDecoration(
                  color: TColor.gray70.withOpacity(0.5),
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25))),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset("assets/img/home_bg.png"),
                  Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Container(
                        padding: EdgeInsets.only(bottom: media.width * 0.05),
                        width: media.width * 0.72,
                        height: media.width * 0.72,
                        child: CustomPaint(
                          painter: CustomArcPainter(
                            end: 120,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: media.width * 0.05,
                      ),
                      SizedBox(
                        height: media.width * 0.07,
                      ),
                      Text(
                        "\₹84,323",
                        style: TextStyle(
                            color: TColor.white,
                            fontSize: 40,
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: media.width * 0.055,
                      ),
                      Text(
                        "This month",
                        style: TextStyle(
                          color: TColor.gray40,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: media.width * 0.07,
                      ),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: TColor.border.withOpacity(0.15),
                            ),
                            color: TColor.gray60.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            "See your balance",
                            style: TextStyle(
                                color: TColor.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      children: [
                        const Spacer(),
                        Row(
                          children: [
                            Expanded(
                              child: StatusButton(
                                title: "Income",
                                value: formatPrice('12345'),
                                statusColor: TColor.green,
                                onPressed: () {},
                              ),
                            ),
                            const SizedBox(
                              width: 28,
                            ),
                            Expanded(
                              child: StatusButton(
                                title: "Expense",
                                value: formatPrice(311234),
                                statusColor: TColor.red,
                                onPressed: () {},
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  Expanded(
                    child: SegmentButton(
                      title: "Income",
                      isActive: selectedTab == "Income",
                      onPressed: () => setState(() => selectedTab = "Income"),
                    ),
                  ),
                  Expanded(
                    child: SegmentButton(
                      title: "Expense",
                      isActive: selectedTab == "Expense",
                      onPressed: () => setState(() => selectedTab = "Expense"),
                    ),
                  ),
                  Expanded(
                    child: SegmentButton(
                      title: "Transfer",
                      isActive: selectedTab == "Transfer",
                      onPressed: () => setState(() => selectedTab = "Transfer"),
                    ),
                  )
                ],
              ),
            ),
            if (selectedTab == "Income") _buildIncomeView(),
            if (selectedTab == "Expense") _buildExpenseView(),
            if (selectedTab == "Transfer") _buildTransactionView(),
            const SizedBox(
              height: 110,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIncomeView() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: expenseArr.length,
      itemBuilder: (context, index) {
        var bObj = expenseArr[index];
        return UpcomingBillRow(
          sObj: bObj,
          textColor: TColor.green,
          onPressed: () {},
        );
      },
    );
  }

  Widget _buildExpenseView() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: expenseArr.length,
      itemBuilder: (context, index) {
        var bObj = expenseArr[index];
        return UpcomingBillRow(
          sObj: bObj,
          onPressed: () {},
          textColor: TColor.red,
        );
      },
    );
  }

  Widget _buildTransactionView() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: trasactionArr.length,
      itemBuilder: (context, index) {
        var sObj = trasactionArr[index];
        return SubScriptionHomeRow(
          sObj: sObj,
          onPressed: () {},
          textColor: TColor.white,
        );
      },
    );
  }

  String formatPrice(dynamic price) {
    // Ensure price is an integer
    int validPrice = (price is String) ? int.tryParse(price) ?? 0 : price;
    // Use the custom function to handle Indian number format
    return '₹${_formatInIndianCurrency(validPrice.toString())}';
  }

  String _formatInIndianCurrency(String number) {
    if (number.length <= 3) return number;

    // Length of the initial segment
    int initialLength = 3;
    // Get the initial segment based on calculated length
    String formatted =
        number.substring(number.length - initialLength, number.length);
    // Iterate over the rest of the number in steps of 2
    String inititalNumber = "";
    for (int i = 0; i < number.length - initialLength; i += 2) {
      inititalNumber += number.substring(i, i + 2) + ',';
    }
    return inititalNumber + formatted;
  }
}
