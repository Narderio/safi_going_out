import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:safi_going_out/security/Security.dart';
import 'RegistrationPage.dart';
import 'home_page.dart';
import '../config.dart'; // Importa il file di configurazione

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text;
      String password = _passwordController.text;

      final response = await http.post(
        Uri.parse(ApiConfig.loginEndpoint), // Usa l'endpoint da ApiConfig
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        String token = response.body;
        Security().saveToken(token);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MyHomePage(title: "Safi Going Out"),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Errore: ${response.body}"),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
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

  Future<void> _forgotPassword() async {
    TextEditingController emailController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Reimposta Password"),
          content: TextField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: "Inserisci la tua email",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.email),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Annulla"),
            ),
            TextButton(
              onPressed: () {
                _sendForgotPasswordRequest(emailController.text);
                Navigator.of(context).pop();
              },
              child: Text("Invia"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _sendForgotPasswordRequest(String email) async {
    if (email.isNotEmpty) {
      final response = await http.post(
        Uri.parse(ApiConfig.forgotPasswordEndpoint), // Assicurati di avere l'endpoint corretto
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Email di reimpostazione inviata"),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Errore: ${response.body}"),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Inserisci un'email valida"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Login",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Inserisci la tua email";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Inserisci la tua password";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 12,
                      ),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                    child: Text("Accedi"),
                  ),
                  SizedBox(height: 15),
                  TextButton(
                    onPressed: _forgotPassword,
                    child: Text(
                      "Hai dimenticato la password?",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  SizedBox(height: 15),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => RegistrationPage(),
                        ),
                      );
                    },
                    child: Text(
                      "Non hai un account? Registrati",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}