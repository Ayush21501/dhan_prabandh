import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../common/color_extension.dart';

class UpcomingBillRow extends StatelessWidget {
  final Map sObj;
  final VoidCallback onPressed;
  final Color textColor;

  const UpcomingBillRow({
    super.key,
    required this.sObj,
    required this.onPressed,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onPressed,
        child: Container(
          height: 80,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(
              color: TColor.border.withOpacity(0.15),
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.center,
          child: Row(
            children: [
              Container(
                height: 54,
                width: 54,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: TColor.gray70.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Text(
                      "Jun",
                      style: TextStyle(
                          color: TColor.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "25",
                      style: TextStyle(
                          color: TColor.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "2024",
                      style: TextStyle(
                          color: TColor.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        sObj["description"], // description
                        style: TextStyle(
                            color: TColor.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        sObj["category"], // category
                        style: TextStyle(
                            color: TColor.gray30,
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        sObj["type"], // acount cash/bank
                        style: TextStyle(
                            color: TColor.gray30,
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                formatPrice(sObj["price"]),
                style: TextStyle(
                    color: textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              )
            ],
          ),
        ),
      ),
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
    // for (int i = number.length - initialLength; i >= 0; i--) {
    //   int y = i - 2 < 0 ? 0 : i - 2;
    //   print(y);
    //   String subStr = number.substring(y, i);
    //   print(subStr);
    //   inititalNumber = subStr.length != 2
    //       ? subStr + inititalNumber
    //       : ',' + subStr + inititalNumber;
    // }
    return inititalNumber + formatted;
  }
}
