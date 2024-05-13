import 'package:dhan_prabandh/common/color_extension.dart';
import 'package:dhan_prabandh/common_widget/primary_button.dart';
import 'package:dhan_prabandh/common_widget/round_textfield.dart';
import 'package:dhan_prabandh/db/database_helper.dart';
import 'package:dhan_prabandh/db/model/category_model.dart';
import 'package:dhan_prabandh/db/model/sign_up_model.dart';
import 'package:flutter/material.dart';

class EditSubCategory extends StatefulWidget {
  final Category category;
  final Category subCategory;
  final SignUp user;

  const EditSubCategory(
      {super.key,
      required this.user,
      required this.subCategory,
      required this.category});

  @override
  State<EditSubCategory> createState() => _EditSubCategoryState();
}

class _EditSubCategoryState extends State<EditSubCategory> {
  late TextEditingController subCategoryName;

  @override
  void initState() {
    super.initState();
    // Initialize the TextEditingController with the initial value
    subCategoryName = TextEditingController(text: widget.subCategory.name);
  }

  @override
  void dispose() {
    // Dispose the TextEditingController to avoid memory leaks
    subCategoryName.dispose();
    super.dispose();
  }

  void hadleSubmit() async {
    try {
      String categoryTitle = subCategoryName.text;
      String categoryType = widget.subCategory.type;
      int? userId = widget.user.id;
      int? parentCategoryId = widget.subCategory.parentId;
      int? subCategoryId = widget.subCategory.id;

      Category category = Category(
        name: categoryTitle,
        type: categoryType,
        parentId: parentCategoryId,
        userId: userId,
        id: subCategoryId,
      );

      await DatabaseHelper().updateCategory(category);

      subCategoryName.clear();

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: TColor.green,
          content: Text(" Sub Category Updated successfully!",
              style: TextStyle(color: TColor.gray80)),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      SnackBar(
        backgroundColor: TColor.red,
        content:
            Text("Something is wrong!", style: TextStyle(color: TColor.gray80)),
        duration: const Duration(seconds: 2),
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
          "Edit Sub Category",
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Category",
                style: TextStyle(
                  color: TColor.white,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: TColor.gray60.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: TColor.white),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.category_outlined, color: TColor.white),
                        const SizedBox(
                            width: 10), // Space between icon and text
                        Expanded(
                          child: Text(
                            widget.category.name,
                            style: TextStyle(
                              color: TColor.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              RoundTextField(
                title: "Sub Category",
                controller: subCategoryName,
                obscureText: false,
                icon: Icon(Icons.category_outlined, color: TColor.white),
              ),
              const SizedBox(height: 20),
              PrimaryButton(title: "Edit Sub Category", onPressed: hadleSubmit)
            ],
          ),
        ),
      ),
    );
  }
}
