class SignUp {
  int? id;
  String name;
  String surname;
  String password;

  SignUp(
      {this.id,
      required this.name,
      required this.surname,
      required this.password});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'surname': surname,
      'password': password,
    };
  }
}
