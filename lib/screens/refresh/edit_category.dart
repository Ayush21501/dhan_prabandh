import 'package:dhan_prabandh/common/color_extension.dart';
import 'package:dhan_prabandh/common_widget/primary_button.dart';
import 'package:dhan_prabandh/common_widget/round_textfield.dart';
import 'package:dhan_prabandh/db/database_helper.dart';
import 'package:dhan_prabandh/db/model/category_model.dart';
import 'package:dhan_prabandh/db/model/sign_up_model.dart';
import 'package:flutter/material.dart';

class EditCategory extends StatefulWidget {
  final Category category;
  final SignUp user;
  const EditCategory({super.key, required this.user, required this.category});

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  TextEditingController categoryName = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize the TextEditingController with the initial value
    categoryName = TextEditingController(text: widget.category.name);
  }

  @override
  void dispose() {
    // Dispose the TextEditingController to avoid memory leaks
    categoryName.dispose();
    super.dispose();
  }

  void hadleSubmit() async {
    try {
      String categoryTitle = categoryName.text;
      String categoryType = widget.category.type;
      int? userId = widget.user.id;
      int? parentCategoryId = widget.category.parentId;
      int? categoryId = widget.category.id;

      Category category = Category(
        name: categoryTitle,
        type: categoryType,
        parentId: parentCategoryId,
        userId: userId,
        id: categoryId,
      );

      print(categoryTitle);
      print(categoryType);
      print(userId);
      print(parentCategoryId);
      print(categoryId);

      await DatabaseHelper().updateCategory(category);

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
          "Edit Category",
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
                title: "Category Name",
                controller: categoryName,
                obscureText: false,
                icon: Icon(Icons.category_outlined, color: TColor.white),
              ),
              SizedBox(height: 30),
              PrimaryButton(title: "Edit Category", onPressed: hadleSubmit)
            ],
          ),
        ),
      ),
    );
  }
}
