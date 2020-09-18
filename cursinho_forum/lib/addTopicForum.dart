import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AddForum extends StatefulWidget {
  @override
  _AddForumState createState() => _AddForumState();
}

class _AddForumState extends State<AddForum> {
  bool _isLoading = false;
  FirebaseUser _currentUser;

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.onAuthStateChanged.listen((user) {
      setState(() {
        _currentUser = user;
      });
    });
  }

  void _sendMessage({String assunto, String duvida}) async {
    final FirebaseUser user = _currentUser;

    Map<String, dynamic> data = {
      "uid": user.uid,
      "senderName": user.displayName,
      "senderPhotoUrl": user.photoUrl,
      "time": Timestamp.now(),
      "discussao": duvida
    };

    setState(() {
      _isLoading = false;
    });

    Firestore.instance
        .collection('forum')
        .document()
        .collection('$assunto')
        .add(data);
    Navigator.pop(context);
  }

  bool _edited = false;

  final _assuntoController = TextEditingController();
  final _duvidaController = TextEditingController();
  final _assuntoFocus = FocusNode();
  final _duvidaFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,
            title: Text("Novo Topico"),
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (_assuntoController.text != null &&
                  _duvidaController.text != null) {
                _sendMessage(
                    assunto: _assuntoController.text,
                    duvida: _duvidaController.text);
              } else if (_assuntoController.text == null) {
                FocusScope.of(context).requestFocus(_assuntoFocus);
              } else {
                FocusScope.of(context).requestFocus(_duvidaFocus);
              }
            },
            child: Icon(Icons.save),
            backgroundColor: Colors.red,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: [
                TextField(
                  controller: _assuntoController,
                  focusNode: _assuntoFocus,
                  decoration: InputDecoration(
                    labelText: "Título do tópico",
                  ),
                  onChanged: (text) {
                    _edited = true;
                  },
                ),
                TextField(
                  controller: _duvidaController,
                  decoration: InputDecoration(
                    labelText: "Insira sua dúvida",
                  ),
                  onChanged: (text) {
                    _edited = true;
                  },
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                ),
                _isLoading ? CircularProgressIndicator() : Container(),
              ],
            ),
          ),
        ),
        onWillPop: _requestPop);
  }

  Future<bool> _requestPop() {
    if (_edited) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Descartar Alterações?"),
              content:
                  Text("Caso prossiga em sair, as alterações serão perdidas."),
              actions: [
                FlatButton(
                  child: Text("Cancelar"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Text("Sair"))
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
