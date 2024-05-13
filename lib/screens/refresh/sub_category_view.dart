import 'package:dhan_prabandh/common_widget/category_list_item.dart';
import 'package:dhan_prabandh/db/database_helper.dart';
import 'package:dhan_prabandh/db/model/sign_up_model.dart';
import 'package:dhan_prabandh/screens/refresh/add_sub_category.dart';
import 'package:dhan_prabandh/screens/refresh/edit_category.dart';
import 'package:dhan_prabandh/screens/refresh/edit_sub_category.dart';
import 'package:flutter/material.dart';
import 'package:dhan_prabandh/common/color_extension.dart';
import 'package:dhan_prabandh/db/model/category_model.dart'; // Import the Category model

class SubCategoryView extends StatefulWidget {
  final Category category;
  final SignUp user; // Add a Category object

  const SubCategoryView(
      {super.key, required this.category, required this.user});

  @override
  State<SubCategoryView> createState() => _SubCategoryViewState();
}

class _SubCategoryViewState extends State<SubCategoryView> {
  late Future<List<Category>> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = _fetchSubCategories();
  }

  Future<List<Category>> _fetchSubCategories() async {
    int userId = widget.user.id ?? 0;
    int parentId = widget.category.id ?? 0;
    print("my category id in subcategory: $parentId");
    return DatabaseHelper().getSubCategoriesByType(parentId, userId);
  }

  void _deleteSubCategory(BuildContext context, int subCategoryId) async {
    // Show the confirmation dialog
    bool delete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: TColor.white,
          title: Text("Confirm Delete"),
          content: Text("Are you sure you want to delete this sub category?"),
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
      await DatabaseHelper().deleteCategory(subCategoryId);
      setState(() {
        _categoriesFuture =
            _fetchSubCategories(); // Refresh the list after deletion
      });
    }
  }

  void _editCategory(BuildContext context, Category subCategory) {
    print("edit form");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditSubCategory(
          user: widget.user,
          category: widget.category,
          subCategory: subCategory,
        ),
      ),
    ).then((value) {
      if (value == true) {
        // If the edit was successful, refresh the list
        setState(() {
          _categoriesFuture = _fetchSubCategories();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print("come sub category ${widget.category.type}");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.gray,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          widget.category.name,
          style: TextStyle(color: TColor.white, fontSize: 18),
        ),
        leading: IconButton(
          padding: const EdgeInsets.only(left: 20.0),
          icon: Icon(Icons.arrow_back_ios, color: TColor.white),
          onPressed: () => Navigator.pop(context, true),
        ),
        actions: <Widget>[
          IconButton(
            // padding: const EdgeInsets.only(right: 20.0),
            icon: Icon(
              Icons.edit_outlined,
              color: TColor.white,
              size: 20,
            ),
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
                    return EditCategory(
                        category: widget.category, user: widget.user);
                  },
                ),
              );
              if (result == true) {
                setState(() {
                  _categoriesFuture = _fetchSubCategories();
                });
              }
            },
          ),
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
                    return AddSubCategory(
                        category: widget.category, user: widget.user);
                  },
                ),
              );
              if (result == true) {
                setState(() {
                  _categoriesFuture = _fetchSubCategories();
                });
              }
            },
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
                  return CategoryListItem(
                    categoryName: category.name,
                    categoryType: "",
                    onEditPressed: () => _editCategory(context, category),
                    onDeletePressed: () =>
                        _deleteSubCategory(context, category.id ?? 0),
                  );
                },
              );
            } else {
              return Center(
                child: Text(
                  'No Sub categories found!',
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
