import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Person.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

  class _MyHomePageState extends State<MyHomePage> {
  final List<Person> persone = [
  Person(nome: "Maria", cognome: "Labanca", imagePath: "assets/profile_images/maria.png", status: "Fuori residenza"),
  Person(nome: "Sofia", cognome: "Miglionico", imagePath: "assets/profile_images/sofia.png", status: "Fuori residenza"),
  Person(nome: "Nicol", cognome: "Goranova", imagePath: "assets/profile_images/nicol.png", status: "Fuori residenza"),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Center(child: Text(widget.title)),
      ),
      body: ListView(
        children: const <Widget>[
          ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage("assets/profile_images/maria.png"),
            ),
            title: Text('Maria Labanca'),
            subtitle: Text('Fuori residenza'),
            trailing: Icon(Icons.remove),
          ),
          Divider(height: 0),
          ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage("assets/profile_images/sofia.png"),
            ),
            title: Text('Sofia Miglionico'),
            subtitle: Text('Fuori residenza'),
            trailing: Icon(Icons.remove),
          ),
          Divider(height: 0),
          ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage("assets/profile_images/nicol.png"),
            ),
            title: Text('Nicol Goranova'),
            subtitle: Text('Fuori residenza'),
            trailing: Icon(Icons.remove),
          ),
        ],
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
