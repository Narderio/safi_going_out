import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:safi_going_out/screens/manage_users.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/PersonList.dart';
import 'Profile.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<PersonList> people = [
    PersonList(
      name: "Maria",
      surname: "Labanca",
      imagePath: "assets/profile_images/maria.png",
      status: "Fuori residenza",
    ),
    PersonList(
      name: "Sofia",
      surname: "Miglionico",
      imagePath: "assets/profile_images/sofia.png",
      status: "Fuori residenza",
    ),
    PersonList(
      name: "Nicol",
      surname: "Goranova",
      imagePath: "assets/profile_images/nicol.png",
      status: "Fuori residenza",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Row(
          children: [Expanded(child: Center(child: Text(widget.title)))],
        ),
      ),
      endDrawer: buildDrawer(context),
      body: ListView.builder(
        itemCount: people.length,
        itemBuilder: (context, index) {
          final person = people[index];
          return Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(person.imagePath),
                ),
                title: Text('${person.name} ${person.surname}'),
                subtitle: Text(person.status),
                trailing: Icon(Icons.remove),
              ),
              Divider(height: 0),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAlertDialog(context);
        },
        tooltip: 'aggiungi una persona',
        child: const Icon(Icons.add),
      ), // Rimuovi la parentesi graffa extra qui
    );
  }

  /// Funzione per creare il Drawer
  Widget buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage("assets/profile_images/dario.png"),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profilo'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Profile(title: widget.title),
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Gestione utenti'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ManageUsers(title: widget.title),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void showAlertDialog(BuildContext context) {
    TextEditingController matricolaController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Indica la matricola"),
          content: TextField(
            controller: matricolaController,
            decoration: const InputDecoration(
              labelText: "Matricola",
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Chiudi il dialog
              },
              child: const Text("Annulla"),
            ),
            TextButton(
              onPressed: () async {
                // Rendi la funzione asincrona
                String matricola = matricolaController.text.trim();
                if (matricola.isNotEmpty) {
                  await userOut(
                    context,
                    matricola,
                  ); // Aspetta il completamento di userOut
                  Navigator.of(
                    context,
                  ).pop(); // Chiudi il dialog solo dopo la chiamata
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Inserisci una matricola valida!"),
                    ),
                  );
                }
              },
              child: const Text("Conferma"),
            ),
          ],
        );
      },
    );
  }

  Future<void> userOut(BuildContext context, String matricola) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/userOut'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"id": int.parse(matricola)}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Utente esce correttamente!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Errore! Utente non esce!")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Errore di connessione: $e")));
    }
  }
}
