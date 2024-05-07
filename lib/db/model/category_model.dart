class Category {
  int? id;
  String name;
  String type; 
  int? parentId;
  int? userId;

  Category({
    this.id,
    required this.name,
    required this.type,
    this.parentId,
    this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'parentId': parentId,
      'userId': userId,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
      type: map['type'],
      parentId: map['parentId'],
      userId: map['userId'],
    );
  }
}
