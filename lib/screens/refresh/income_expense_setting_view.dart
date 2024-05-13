import 'dart:async';

import 'package:dhan_prabandh/common/color_extension.dart';
import 'package:dhan_prabandh/common_widget/category_list_item.dart';
import 'package:dhan_prabandh/db/database_helper.dart';
import 'package:dhan_prabandh/db/model/category_model.dart';
import 'package:dhan_prabandh/db/model/sign_up_model.dart';
import 'package:dhan_prabandh/screens/refresh/add_category.dart';
import 'package:dhan_prabandh/screens/refresh/sub_category_view.dart';
import 'package:flutter/material.dart';

class IncomeExpenseSettingView extends StatefulWidget {
  final String title;
  final SignUp user; // Add a field for the title

  const IncomeExpenseSettingView(
      {super.key, required this.title, required this.user});

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
          backgroundColor: TColor.white,
          title: Text("Confirm Delete"),
          content: Text("Are you sure you want to delete this category?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel", style: TextStyle(color: TColor.gray80)),
              onPressed: () {
                Navigator.of(context)
                    .pop(false); // Dismisses only the dialog and returns false
              },
            ),
            TextButton(
              child: Text("Delete", style: TextStyle(color: TColor.red)),
              onPressed: () {
                Navigator.of(context)
                    .pop(true); // Dismisses the dialog and returns true
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
        _categoriesFuture =
            _fetchCategories(); // Refresh the list after deletion
      });
    }
  }

  void _editCategory(BuildContext context, Category category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            SubCategoryView(category: category, user: widget.user),
      ),
    ).then((value) {
      if (value == true) {
        // If the edit was successful, refresh the list
        setState(() {
          _categoriesFuture = _fetchCategories();
        });
      }
    });
  }

  Future<List<Category>> _fetchSubCategories(int? parentId) async {
    int userId = widget.user.id ?? 0;
    return DatabaseHelper().getSubCategoriesByType(parentId!, userId);
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
              onPressed: () async {
                final result = await Navigator.push(
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
                      return AddCategory(
                          title: widget.title, user: widget.user);
                    },
                  ),
                );
                if (result == true) {
                  setState(() {
                    _categoriesFuture = _fetchCategories();
                  });
                }
              }),
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
                  return FutureBuilder<List<Category>>(
                    future: _fetchSubCategories(category.id ?? 0),
                    builder: (context, subSnapshot) {
                      if (subSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (subSnapshot.hasError) {
                        return Text('Error loading subcategories');
                      } else {
                        String subCategoriesString = '';
                        if (subSnapshot.data != null &&
                            subSnapshot.data!.isNotEmpty) {
                          subCategoriesString = subSnapshot.data!
                              .map((subCategory) => subCategory.name)
                              .join(', '); // Concatenate subcategory names
                        }
                        return Expanded(
                          child: CategoryListItem(
                            categoryName: category.name,
                            categoryType: subCategoriesString.isNotEmpty
                                ? subCategoriesString
                                : "", // Use subcategories if available, else use type
                            onEditPressed: () =>
                                _editCategory(context, category),
                            onDeletePressed: () =>
                                _deleteCategory(context, category.id ?? 0),
                          ),
                        );
                      }
                    },
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
