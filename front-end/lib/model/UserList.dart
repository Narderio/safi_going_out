
class UserList {
  final int id;
  final String name;
  final String surname;
  final String role;
  final String image;

  UserList({
    required this.name,
    required this.surname,
    required this.role,
    required this.id,
    required this.image,
  });

  factory UserList.fromJson(Map<String, dynamic> json) {
    return UserList(
      name: json['name'],
      surname: json['surname'],
      role: json['role'],
      id: json['id'],
      image: json['image'],
    );
  }
}
