enum UserType { PARTICULAR, PROFESSIONAL }

class User {
  User({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.password,
    this.type = UserType.PARTICULAR,
    this.createdAt,
  });

  String? id;
  String? name;
  String? email;
  String? phone;
  String? password;
  UserType type;
  DateTime? createdAt;

  factory User.fromMap(String id, Map<String, dynamic> map) {
    return User(
      id: id,
      email: map['email'] as String,
      name: map['name'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {'email': email, 'name': name};
  }

  @override
  String toString() {
    return 'User{id: $id, name: $name, email: $email, phone: $phone, password: $password, type: $type, createdAt: $createdAt}';
  }
}
