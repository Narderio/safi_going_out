class GetUserProfile {
  int id;
  final String name;
  final String surname;
  final String role;
  late final String email;
  String image;

  GetUserProfile({
    required this.id,
    required this.name,
    required this.surname,
    required this.email,
    required this.role,
    required this.image,
  });

  factory GetUserProfile.fromJson(Map<String, dynamic> json) {
    return GetUserProfile(
      name: json['name'],
      surname: json['surname'],
      email: json['email'],
      role: json['role'],
      id: json['id'],
      image: json['image'],
    );
  }

}