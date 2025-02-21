import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:safi_going_out/model/GetUserProfile.dart';
import 'package:safi_going_out/screens/LoginPage.dart';
import 'package:safi_going_out/screens/manage_users.dart';
import '../model/UserList.dart';
import '../security/Security.dart';
import 'Profile.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<UserList> users = [];
  GetUserProfile user = GetUserProfile(
    id: 0,
    name: '',
    surname: '',
    email: '',
    role: '',
    image: '',
  );

  @override
  void initState() {
    super.initState();
    // Chiama la funzione asincrona per inizializzare i dati
    initializeData();
  }

  Future<void> initializeData() async {
    // Ottieni il token
    String? token = await Security().getToken();

    if (token==null){
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    }

    // Verifica se il token è presente
    if (token != null) {
      // Fai la chiamata HTTP asincrona per ottenere il profilo utente
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/all/getUserByToken'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(<String, String>{'token': token}),
      );

      // Controlla lo status code della risposta
      if (response.statusCode == 200) {
        user = GetUserProfile.fromJson(jsonDecode(response.body));
      } else {
        print("Errore nella risposta: ${response.statusCode}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Errore nel recupero del profilo!")),
        );
      }
    }

    // Chiama la funzione per caricare gli utenti
    fetchUsers();
  }

  // Funzione per chiamare l'API e popolare la lista
  Future<void> fetchUsers() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8080/all/getOutUsers'),
    );

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
        leading: Container(), // Rimuovi la freccia di default
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
                    // Se l'immagine dell'utente è vuota, usa l'immagine di default, altrimenti decodifica l'immagine base64
                    backgroundImage:
                        person.image.isEmpty
                            ? AssetImage(
                              "assets/profile_images/default_picture.png",
                            )
                            : MemoryImage(base64Decode(person.image))
                                as ImageProvider, // Usa MemoryImage per le immagini base64
                  ),
                  title: Text('${person.name} ${person.surname}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove, color: Colors.red),
                    onPressed: () {
                      userIn(
                        context,
                        person.id,
                      ); // Chiamata alla funzione con ID
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
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.blue),
            child: CircleAvatar(
              // Se l'immagine dell'utente è vuota, usa l'immagine di default, altrimenti decodifica l'immagine base64
              backgroundImage:
                  user.image.isEmpty
                      ? AssetImage("assets/profile_images/default_picture.png")
                      : MemoryImage(base64Decode(user.image))
                          as ImageProvider, // Usa MemoryImage per le immagini base64
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
                  builder: (context) => Profile(title: widget.title, user: user,),
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
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              await Security().removeToken();
              Navigator.pop(context);
              Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );},
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
        Uri.parse('http://10.0.2.2:8080/all/userOut'),
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

  Future<void> userIn(BuildContext context, int id) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/all/userIn'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"id": id}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Utente rientra correttamente!")),
        );
        fetchUsers(); // Ricarica la
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Errore! Utente non rientra!")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Errore di connessione: $e")));
    }
  }
}
