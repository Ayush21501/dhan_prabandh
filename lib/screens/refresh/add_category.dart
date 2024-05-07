import 'package:dhan_prabandh/common/color_extension.dart';
import 'package:dhan_prabandh/common_widget/primary_button.dart';
import 'package:dhan_prabandh/common_widget/round_textfield.dart';
import 'package:dhan_prabandh/db/database_helper.dart';
import 'package:dhan_prabandh/db/model/category_model.dart';
import 'package:dhan_prabandh/db/model/sign_up_model.dart';
import 'package:flutter/material.dart';

class AddCategory extends StatefulWidget {
  final String title;
  final SignUp user;
  // const AddCategory({super.key, required this.title});
   const AddCategory({super.key, required this.title, required this.user});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {

// final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
TextEditingController categoryName = TextEditingController();

  void hadleSubmit() async {
    try{
      String categoryTitle = categoryName.text;
    String categoryType = widget.title; // Assuming title is 'income' or 'expense'
    int? userId = widget.user.id;

    Category category = Category(
      name: categoryTitle,
      type: categoryType,
      userId: userId,
    );
     print("Category Name: $categoryTitle");
    print("Category Type: $categoryType");
    print("User ID: $userId");
    int categoryId = await DatabaseHelper().insertCategory(category);
    print("Category added with ID: $categoryId");
   
    categoryName.clear();

      ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Category added successfully!"),
        duration: Duration(seconds: 2),
      ),
    ); 

    }
    catch(e){
      print(e);
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
           "Add Category",
          style: TextStyle(color: TColor.white, fontSize: 18),
        ),
        leading: IconButton(
          padding: const EdgeInsets.only(left: 20.0),
          icon: Icon(Icons.arrow_back_ios, color: TColor.white),
          onPressed: () => Navigator.pop(context),
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
              PrimaryButton(title: "Add Category", onPressed: hadleSubmit)
              
            ],
          ),
        ),
      ),
    );
  }
}