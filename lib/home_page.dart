import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Person.dart';
import 'Profile.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Person> people = [
    Person(
      nome: "Maria",
      cognome: "Labanca",
      imagePath: "assets/profile_images/maria.png",
      status: "Fuori residenza",
    ),
    Person(
      nome: "Sofia",
      cognome: "Miglionico",
      imagePath: "assets/profile_images/sofia.png",
      status: "Fuori residenza",
    ),
    Person(
      nome: "Nicol",
      cognome: "Goranova",
      imagePath: "assets/profile_images/nicol.png",
      status: "Fuori residenza",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Row(
          children: [
            Expanded(child: Center(child: Text(widget.title))),
          ],
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
                title: Text('${person.nome} ${person.cognome}'),
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
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => Profile(title: widget.title,)))
              ;
            },
          ),

          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Impostazioni'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Indica la matricola"),
          content: const Text("data"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Annulla"),
            ),
            TextButton(
              onPressed: () {
                addPeople(1.toString()); // Esegui l'azione
                Navigator.of(context).pop(); // Chiudi il dialog
              },
              child: const Text("Conferma"),
            ),
          ],
        );
      },
    );
  }

  Future<void> saveNames(List<String> matricole) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('names', matricole);
  }

  Future<List<String>> loadNames() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('names') ?? [];
  }

  Future<void> addPeople(String name) async {
    List<String> currentNames = await loadNames();
    print(currentNames);
    currentNames.add(name);
    await saveNames(currentNames);
  }
}
