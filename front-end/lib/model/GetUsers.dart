
class GetUsers {
  final int id;
  final String name;
  final String surname;
  final String role;
  final String imagePath; // Percorso dell'immagine

  GetUsers({
    required this.id,
    required this.name,
    required this.surname,
    required this.imagePath,
    required this.role,
  });

  // Metodo per convertire JSON in oggetto Person
  factory GetUsers.fromJson(Map<String, dynamic> json) {
    return GetUsers(
      name: json['name'],
      surname: json['surname'],
      imagePath: "assets/profile_images/dario.png",
      role: json['role'],
      id: json['id'],
    );
  }
}