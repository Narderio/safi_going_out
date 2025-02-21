import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:safi_going_out/model/GetUserProfile.dart';

class Profile extends StatefulWidget {
  Profile({super.key, required this.title, required this.user});
  final String title;
  final GetUserProfile user;

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late GetUserProfile user; // Dichiarazione di user come variabile di stato

  @override
  void initState() {
    super.initState();
    user = widget.user; // Inizializza user dal widget
  }

  // Funzione per mostrare il dialogo di modifica dell'email
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
                    Uri.parse('http://10.0.2.2:8080/all/updateEmail'),
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
          Stack(
            children: [
              // Immagine profilo
              if (user.image.isEmpty)
                Image.asset("assets/profile_images/default_picture.png")
              else
                Image.memory(
                  base64Decode(user.image),
                  width: 500, // Imposta una dimensione fissa
                  height: 500,
                  fit: BoxFit.cover,
                ),

              // Pulsante in sovraimpressione
              Positioned(
                bottom: 0,
                right: 0,
                child: IconButton(
                  icon: Icon(Icons.edit, color: Colors.white),
                  onPressed: () {
                    updateImage();
                    // Qui puoi aprire il selettore di immagini
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.black54),
                  ),
                ),
              ),
            ],
          ),
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

  Future<void> updateImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      Uint8List imageBytes = await imageFile.readAsBytes(); // Legge i byte dell'immagine
      String base64Image = base64Encode(imageBytes); // Converte in Base64

      final response = await http.patch(
        Uri.parse('http://10.0.2.2:8080/all/updateImage'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'id': user.id,
          'image': base64Image, // Aggiungi l'immagine codificata in base64
        }),
      );
      if (response.statusCode == 200) {
        setState(() {
          user.image = base64Image; // Aggiorna l'immagine dell'utente
        });
      }
    }
  }
}
