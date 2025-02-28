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
import '../config.dart';

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
    initializeData();
  }

  Future<void> initializeData() async {
    String? token = await Security().getToken();
    print(token);

    if (token == null) {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
      return;
    }

    final response = await http.post(
      Uri.parse('${ApiConfig.allEndpoint}getUserByToken'),
      // Usa l'endpoint da ApiConfig
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: jsonEncode({'token': token}),
    );

    if (response.statusCode == 200) {
      setState(() {
        user = GetUserProfile.fromJson(jsonDecode(response.body));
        fetchUsers();
      });
    } else {
      print("Errore nella risposta: ${response.statusCode}");
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }

  Future<void> fetchUsers() async {
    String? token = await Security().getToken();

    if (token == null) {
      print("Errore: nessun token disponibile!");
      return;
    }

    final response = await http.get(
      Uri.parse('${ApiConfig.allEndpoint}getOutUsers'),
      // Usa l'endpoint da ApiConfig
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        HttpHeaders.contentTypeHeader: 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List jsonData = jsonDecode(response.body);
      setState(() {
        users = jsonData.map((e) => UserList.fromJson(e)).toList();
      });
    } else {
      print("Errore nella risposta: ${response.statusCode}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Errore nel recupero degli utenti!")),
      );
    }
  }

  /// Funzione per gestire il tasto "indietro"
  Future<bool> _onWillPop() async {
    return await showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: Text("Esci dall'app"),
                content: Text("Sei sicuro di voler uscire?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text("No"),
                  ),
                  TextButton(
                    onPressed: () => exit(0), // Chiude l'app
                    child: Text("Sì"),
                  ),
                ],
              ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop, // Blocca il tasto "indietro" e mostra il dialog
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: Container(),
          backgroundColor: Theme.of(context).primaryColor,
          title: Row(
            children: [Expanded(child: Center(child: Text(widget.title)))],
          ),
        ),
        endDrawer: buildDrawer(context),
        body: RefreshIndicator(
          onRefresh: fetchUsers,
          child: ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final person = users[index];
              return Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          person.image.isEmpty
                              ? AssetImage(
                                "assets/profile_images/default_picture.png",
                              )
                              : MemoryImage(base64Decode(person.image))
                                  as ImageProvider,
                    ),
                    title: Text('${person.name} ${person.surname}'),
                    trailing: IconButton(
                      icon: Icon(Icons.remove, color: Colors.red),
                      onPressed: () => userIn(context, person.id),
                    ),
                  ),
                  Divider(height: 0),
                ],
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => showAlertDialog(context),
          tooltip: 'Aggiungi una persona',
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: CircleAvatar(
              backgroundImage:
                  user.image.isEmpty
                      ? AssetImage("assets/profile_images/default_picture.png")
                      : MemoryImage(base64Decode(user.image)) as ImageProvider,
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profilo'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder:
                      (context) => Profile(title: widget.title, user: user),
                ),
              );
            },
          ),
          // Mostra 'Gestione utenti' solo se il ruolo non è 'USER'
          if (user.role != 'USER')
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Gestione utenti'),
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
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () async {
              await Security().removeToken();
              Navigator.pop(context);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => LoginPage()),
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
            decoration: InputDecoration(
              labelText: user.id.toString(),
              border: const OutlineInputBorder(),
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
    print("Matricola: $matricola");
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.allEndpoint}userOut'),
        // Usa l'endpoint da ApiConfig
        headers: {
          "Content-Type": "application/json",
          HttpHeaders.authorizationHeader:
              'Bearer ${await Security().getToken()}',
        },
        body: jsonEncode({"id": int.parse(matricola)}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Utente esce correttamente!")),
        );
        fetchUsers(); // Ricarica la lista
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
        Uri.parse('${ApiConfig.allEndpoint}userIn'),
        // Usa l'endpoint da ApiConfig
        headers: {
          "Content-Type": "application/json",
          HttpHeaders.authorizationHeader:
              'Bearer ${await Security().getToken()}',
        },
        body: jsonEncode({"id": id}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Utente rientra correttamente!")),
        );
        fetchUsers(); // Ricarica la lista
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
