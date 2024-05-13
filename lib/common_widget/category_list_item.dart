import 'package:dhan_prabandh/common/color_extension.dart';
import 'package:flutter/material.dart';

class CategoryListItem extends StatelessWidget {
  final String categoryName;
  final String categoryType;
  final VoidCallback onEditPressed;
  final VoidCallback onDeletePressed;

  const CategoryListItem({
    required this.categoryName,
    required this.categoryType,
    required this.onEditPressed,
    required this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    bool hasSubCategory = categoryType.isNotEmpty;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(
          color: TColor.border.withOpacity(0.1),
        ),
        color: TColor.gray60.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: hasSubCategory
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.center,
                children: [
                  if (!hasSubCategory) SizedBox(height: 7),
                  Text(
                    categoryName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: TColor.white,
                      fontSize: 14,
                    ),
                  ),
                  if (!hasSubCategory) SizedBox(height: 7),
                  if (hasSubCategory) SizedBox(height: 4),
                  if (hasSubCategory)
                    Text(
                      categoryType,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: TColor.gray40,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: onEditPressed,
                  child: Icon(
                    Icons.edit_outlined,
                    size: 16,
                    color: TColor.gray20,
                  ),
                ),
                SizedBox(width: 12),
                InkWell(
                  onTap: onDeletePressed,
                  child: Icon(
                    Icons.delete_outline,
                    size: 16,
                    color: TColor.gray20,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
