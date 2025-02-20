
class Person {
  final int id;
  final String name;
  final String surname;
  final String email;
  final String password;
  final String role;
  final String imagePath; // Percorso dell'immagine

  Person({
    required this.id,
    required this.name,
    required this.surname,
    required this.imagePath,
    required this.email,
    required this.password,
    required this.role,
  });

  // Metodo per convertire JSON in oggetto Person
  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      name: json['name'],
      surname: json['surname'],
      imagePath: "assets/profile_images/dario.png",
      email: json['email'],
      password: json['password'],
      role: json['role'],
      id: json['id'],
    );
  }
}