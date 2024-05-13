class Account {
  int? id;
  String name;
  int? userId;
  bool deleted;
  bool isDefault; // Corrected spelling here

  Account({
    this.id,
    required this.name,
    this.userId,
    this.deleted = false,
    this.isDefault = false, // Corrected spelling here
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'userId': userId,
      'deleted': deleted ? 1 : 0,
      'isDefault': isDefault ? 1 : 0, // Corrected spelling and store as integer
    };
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      id: map['id'],
      name: map['name'],
      userId: map['userId'],
      deleted: map['deleted'] == 1,
      isDefault: map['isDefault'] == 1, // Convert integer back to boolean
    );
  }
}
