import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/GetUsers.dart';

class ManageUsers extends StatefulWidget {
  const ManageUsers({super.key, required this.title});

  final String title;

  @override
  State<ManageUsers> createState() => _ManageUsersState();
}

class _ManageUsersState extends State<ManageUsers> {
  List<GetUsers> users = [];
  Set<String> selectedRole = {'User'}; // Ruolo predefinito in un Set

  @override
  void initState() {
    super.initState();
    fetchUsers(); // Chiama l'API all'avvio
  }

  // Funzione per chiamare l'API e popolare la lista
  Future<void> fetchUsers() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8080/getUsers'));

    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      setState(() {
        users = jsonData.map((e) => GetUsers.fromJson(e)).toList();
      });
    } else {
      print("Errore nel caricamento dei dati: ${response.statusCode}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Errore nel caricamento dei dati")),
      );
    }
  }

  Future<void> addUser(
    String name,
    String surname,
    String email,
    String id,
    String role,
  ) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/addUserByAdmin'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'name': name,
        'surname': surname,
        'email': email,
        'id': int.parse(id), // Se necessario, converti in int
        'role': role.toUpperCase(),
      }),
    );
    if (response.statusCode == 200) {
      fetchUsers(); // Aggiorna la lista
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Errore nell'aggiunta dell'utente")),
      );
    }
  }

  Future<void> _removeUser(int id) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/deleteUser'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"id": id}),
    );
    if (response.statusCode == 200) {
      fetchUsers(); // Aggiorna la lista
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Errore nella rimozione dell'utente")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Row(
          children: [Expanded(child: Center(child: Text("Gestione Utenti")))],
        ),
        leading: Container(), // Rimuovi la freccia di default
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(
                context,
              ).pop(); // Torna indietro alla schermata precedente
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final person = users[index];
          return Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  // Se l'immagine dell'utente è vuota, usa l'immagine di default, altrimenti decodifica l'immagine base64
                  backgroundImage:
                      person.image.isEmpty
                          ? AssetImage(
                            "assets/profile_images/default_picture.png",
                          )
                          : MemoryImage(base64Decode(person.image))
                              as ImageProvider, // Usa MemoryImage per le immagini base64
                ),
                title: Text('${person.name} ${person.surname} (${person.id})'),
                subtitle: Text(person.role),
                trailing: IconButton(
                  icon: const Icon(Icons.remove, color: Colors.red),
                  onPressed: () {
                    _removeUser(person.id); // Chiamata alla funzione con ID
                  },
                ),
              ),

              Divider(height: 0),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showBottomSheet(context);
        },
        tooltip: 'Registra una persona',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController surnameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController idController = TextEditingController();
    Set<String> selectedRole = {'User'};

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
            double screenHeight = MediaQuery.of(context).size.height;

            // Altezza dinamica: parte da 50% e diventa 90% appena si apre la tastiera
            double bottomSheetHeight =
                keyboardHeight > 0 ? screenHeight * 0.9 : screenHeight * 0.5;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: bottomSheetHeight,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      margin: const EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Inserisci i dati",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              labelText: "Nome",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: surnameController,
                            decoration: const InputDecoration(
                              labelText: "Cognome",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: emailController,
                            decoration: const InputDecoration(
                              labelText: "Email",
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: idController,
                            decoration: const InputDecoration(
                              labelText: "ID",
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 10),
                          SegmentedButton<String>(
                            segments: const <ButtonSegment<String>>[
                              ButtonSegment<String>(
                                value: 'User',
                                label: Text('User'),
                              ),
                              ButtonSegment<String>(
                                value: 'Admin',
                                label: Text('Admin'),
                              ),
                            ],
                            selected: selectedRole,
                            onSelectionChanged: (Set<String> newSelection) {
                              setState(() {
                                selectedRole = newSelection;
                              });
                            },
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                String name = nameController.text.trim();
                                String surname = surnameController.text.trim();
                                String email = emailController.text.trim();
                                String id = idController.text.trim();
                                String role = selectedRole.first;

                                if (name.isEmpty ||
                                    surname.isEmpty ||
                                    email.isEmpty ||
                                    id.isEmpty ||
                                    role.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Compila tutti i campi!"),
                                    ),
                                  );
                                  return;
                                }
                                addUser(name, surname, email, id, role);
                                Navigator.pop(context);
                              },
                              child: const Text("Conferma"),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
