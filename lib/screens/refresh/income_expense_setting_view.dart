import 'dart:async';

import 'package:dhan_prabandh/common/color_extension.dart';
import 'package:dhan_prabandh/db/database_helper.dart';
import 'package:dhan_prabandh/db/model/category_model.dart';
import 'package:dhan_prabandh/db/model/sign_up_model.dart';
import 'package:dhan_prabandh/screens/refresh/add_category.dart';
import 'package:flutter/material.dart';

class IncomeExpenseSettingView extends StatefulWidget {
  final String title; 
  final SignUp user;// Add a field for the title

  const IncomeExpenseSettingView({super.key, required this.title, required this.user});

  @override
  State<IncomeExpenseSettingView> createState() =>
      _IncomeExpenseSettingViewState();
}

class _IncomeExpenseSettingViewState extends State<IncomeExpenseSettingView> {
 
 late Future<List<Category>> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = _fetchCategories();
  }

   Future<List<Category>> _fetchCategories() async {
     int userId = widget.user.id ?? 0;
     print("my userid is $userId");
    return DatabaseHelper().getCategoriesByType(widget.title, userId);
  }

  void _deleteCategory(BuildContext context, int categoryId) async {
  // Show the confirmation dialog
  bool delete = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Confirm Delete"),
        content: Text("Are you sure you want to delete this category?"),
        actions: <Widget>[
          TextButton(
            child: Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop(false); // Dismisses only the dialog and returns false
            },
          ),
          TextButton(
            child: Text("Delete"),
            onPressed: () {
              Navigator.of(context).pop(true); // Dismisses the dialog and returns true
            },
          ),
        ],
      );
    },
  );

  // If the user confirmed, delete the category
  if (delete) {
    await DatabaseHelper().deleteCategory(categoryId);
    setState(() {
      _categoriesFuture = _fetchCategories(); // Refresh the list after deletion
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
          widget.title == "income" ? "Income" : "Expense",
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
            onPressed: () {
               Navigator.push(
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
                           return AddCategory(title: widget.title, user: widget.user);
                        },
                      ),
                    );
            }
            
          ),
        ],
      ),
      backgroundColor: TColor.gray,
   
      body: FutureBuilder<List<Category>>(
        future: _categoriesFuture,
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
                'Error loading categories',
                style: TextStyle(color: TColor.white),
              ),
            );
          } else {
            List<Category>? categories = snapshot.data;
            if (categories != null && categories.isNotEmpty) {
              return ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  Category category = categories[index];
                  return  Container(
                    // padding: const EdgeInsets.symmetric(vertical: 0),
                    // margin: const EdgeInsets.all(8.0), 
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: TColor.border.withOpacity(0.1),
                      ),
                      color: TColor.gray60.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      child: Row(
                        children: [
                                               
                          Text(
                            category.name,
                            style: TextStyle(
                                color: TColor.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                           Spacer(), // This will push the icons to the right
                    Icon(Icons.edit_outlined,size: 21, color: TColor.gray20),
                    // const SizedBox(width: 3),
                    // Icon(Icons.delete_outline, color: TColor.red),
                    IconButton(
                          icon: Icon(Icons.delete_outline, color: TColor.gray20),
                          onPressed: () => _deleteCategory(context, category.id ?? 0),
                        ),
                        
                    
                              
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Text(
                  'No categories found',
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
