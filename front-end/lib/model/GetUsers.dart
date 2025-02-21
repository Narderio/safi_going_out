
class GetUsers {
  final int id;
  final String name;
  final String surname;
  final String role;
  final String image; // Percorso dell'immagine

  GetUsers({
    required this.id,
    required this.name,
    required this.surname,
    required this.image,
    required this.role,
  });

  // Metodo per convertire JSON in oggetto Person
  factory GetUsers.fromJson(Map<String, dynamic> json) {
    return GetUsers(
      name: json['name'],
      surname: json['surname'],
      image: json['image'],
      role: json['role'],
      id: json['id'],
    );
  }
}