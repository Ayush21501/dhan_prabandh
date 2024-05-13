class Category {
  int? id;
  String name;
  String type;
  int? parentId;
  int? userId;
  bool deleted; // New property to handle soft deletion
  bool isDefault; // New property to indicate default category

  Category({
    this.id,
    required this.name,
    required this.type,
    this.parentId,
    this.userId,
    this.deleted = false, // Default to false indicating not deleted
    this.isDefault = false, // Default to false indicating not default
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'parentId': parentId,
      'userId': userId,
      'deleted': deleted ? 1 : 0, // Store as integer in the database
      'isDefault': isDefault ? 1 : 0, // Store as integer in the database
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
      type: map['type'],
      parentId: map['parentId'],
      userId: map['userId'],
      deleted: map['deleted'] == 1, // Convert integer back to boolean
      isDefault: map['isDefault'] == 1, // Convert integer back to boolean
    );
  }
}
