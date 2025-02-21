import 'dart:convert';
import 'dart:convert' as Uint8List;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:safi_going_out/model/GetUserProfile.dart';

class Profile extends StatefulWidget {
  const Profile({super.key, required this.title});

  final String title;

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    super.initState();
    getUser(); // Carica il profilo all'apertura della schermata
  }

  GetUserProfile user = GetUserProfile(
    id: 0,
    name: '',
    surname: '',
    email: '',
    role: '',
    image: '',
  );

  // Funzione per mostrare il dialogo di modifica del nome
  void _editEmail() {
    TextEditingController controller = TextEditingController(text: user.email);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Modifica email'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: "Inserisci la nuova email",
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Chiudi il dialogo
              },
              child: const Text('Annulla'),
            ),
            TextButton(
              onPressed: () async {
                String newEmail =
                    controller.text.trim(); // Rimuove gli spazi bianchi

                if (newEmail.isEmpty) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('L\'email non può essere vuota')),
                  );
                  return;
                }

                try {
                  final response = await http.patch(
                    Uri.parse('http://10.0.2.2:8080/updateEmail'),
                    // URL corretto
                    headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                    },
                    body: jsonEncode(<String, String>{
                      'id': user.id.toString(), // Converto l'ID in stringa
                      'email': newEmail, // Invio la nuova email
                    }),
                  );
                  Navigator.of(context).pop(); // Chiudi il dialogo

                  if (response.statusCode == 200) {
                    setState(() {
                      user = GetUserProfile(
                        id: user.id,
                        name: user.name,
                        surname: user.surname,
                        email: newEmail,
                        // ✅ Aggiorno l'email dopo la risposta OK
                        role: user.role,
                        image: user.image,
                      );
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Email aggiornata con successo!')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Errore: ${response.body}')),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Errore nella richiesta: $e')),
                  );
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
          children: [Expanded(child: Center(child: Text(widget.title)))],
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
      body: Column(
          children: [
            if (user.image == "")
              Image.asset("assets/profile_images/default_picture.png")
            else
              Image.memory(Uint8List.base64Decode(user.image)),
            ListTile(
            title: Text(user.name, style: TextStyle(fontSize: 20)),
            subtitle: Text("Nome"),
          ),
          Divider(height: 0),
          ListTile(
            title: Text(user.surname, style: TextStyle(fontSize: 20)),
            subtitle: Text("Cognome"),
          ),
          Divider(height: 0),
          ListTile(
            title: Text(user.email, style: TextStyle(fontSize: 20)),
            subtitle: Text("Email"),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: _editEmail, // Mostra il dialogo per modificare il nome
            ),
          ),
          Divider(height: 0),
          ListTile(
            title: Text(user.role, style: TextStyle(fontSize: 20)),
            subtitle: Text("Ruolo"),
          ),
          Divider(height: 0),
          ListTile(
            title: Text(user.id.toString(), style: TextStyle(fontSize: 20)),
            subtitle: Text("Matricola"),
          ),
        ],
      ),
    );
  }

  Future<void> getUser() async {
    int userId = 3; // ID dell'utente corrente
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/getUserById'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, int>{'id': userId}),
    );

    if (response.statusCode == 200) {
      setState(() {
        user = GetUserProfile.fromJson(jsonDecode(response.body));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Errore nel caricamento dell'utente: ${response.statusCode}",
          ),
        ),
      );
    }
  }
}
