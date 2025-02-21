
class UserList {
  final int id;
  final String name;
  final String surname;
  final String role;

  UserList({
    required this.name,
    required this.surname,
    required this.role,
    required this.id,
  });

  factory UserList.fromJson(Map<String, dynamic> json) {
    return UserList(
      name: json['name'],
      surname: json['surname'],
      role: json['role'],
      id: json['id'],
    );
  }
}
