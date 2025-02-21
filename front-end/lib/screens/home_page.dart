import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:safi_going_out/screens/manage_users.dart';
import '../model/UserList.dart';
import 'Profile.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<UserList> users = [];

  @override
  void initState() {
    super.initState();
    fetchUsers(); // Chiama l'API all'avvio
  }


  // Funzione per chiamare l'API e popolare la lista
  Future<void> fetchUsers() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8080/getOutUsers'));

    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      setState(() {
        users = jsonData.map((e) => UserList.fromJson(e)).toList();
      });
    } else {
      print("Errore nel caricamento dei dati: ${response.statusCode}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Errore nel caricamento dei dati")),
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
          children: [Expanded(child: Center(child: Text(widget.title)))],
        ),
      ),
      endDrawer: buildDrawer(context),
      body: RefreshIndicator(
        onRefresh: fetchUsers, // Funzione che ricarica la lista
        child: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final person = users[index];
            return Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage("assets/profile_images/dario.png"),
                  ),
                  title: Text('${person.name} ${person.surname}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove, color: Colors.red),
                    onPressed: () {
                      //_removeUser(person.id); // Chiamata alla funzione con ID
                    },
                  ),
                ),
                Divider(height: 0),
              ],
            );
          },
        ),
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
        fetchUsers(); // Ricarica la
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
