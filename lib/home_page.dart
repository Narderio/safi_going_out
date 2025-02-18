import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Center(child: Text(title)),
      ),
      body: ListView(

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
