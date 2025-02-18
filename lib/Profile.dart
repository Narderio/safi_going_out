import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key, required this.title});

  final String title;

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String name = 'Dario'; // Nome iniziale

  // Funzione per mostrare il dialogo di modifica del nome
  void _editName() {
    TextEditingController controller = TextEditingController(text: name);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Modifica nome'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: "Inserisci il nuovo nome"),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Chiudi il dialogo
              },
              child: const Text('Annulla'),
            ),
            TextButton(
              onPressed: () {
                String newName = controller.text.trim(); // Rimuovi gli spazi bianchi

                if (newName.isEmpty) {
                  Navigator.of(context).pop();
                  // Se il nome è vuoto, mostra un errore
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Il nome deve essere almeno di un carattere')),
                  );
                } else {
                  setState(() {
                    name = newName; // Aggiorna il nome
                  });
                  Navigator.of(context).pop(); // Chiudi il dialogo
                }
              },
              child: const Text('Conferma'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Row(
          children: [
            Expanded(child: Center(child: Text(widget.title))),
          ],
        ),
        leading: Container(), // Rimuovi la freccia di default
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop(); // Torna indietro alla schermata precedente
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Immagine in cima
          Image.asset("assets/profile_images/dario.png"),

          // ListTile con il nome e l'icona per modificarlo
          ListTile(
            title: Text(
              name,
              style: TextStyle(fontSize: 20),
            ),
            subtitle: Text("Nome"),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: _editName, // Mostra il dialogo per modificare il nome
            ),
          ),
        ],
      ),
    );
  }
}
