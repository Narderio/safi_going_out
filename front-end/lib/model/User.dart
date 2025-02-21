class User {
  final int id;
  final String name;
  final String surname;
  final String email;
  final String password;
  final String role;
  final String image; // Percorso dell'immagine

  User({
    required this.id,
    required this.name,
    required this.surname,
    required this.image,
    required this.email,
    required this.password,
    required this.role,
  });

  // Metodo per convertire JSON in oggetto Person
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      surname: json['surname'],
      image: json['image'],
      email: json['email'],
      password: json['password'],
      role: json['role'],
      id: json['id'],
    );
  }
}