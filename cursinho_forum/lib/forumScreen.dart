import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cursinho_forum/addTopicForum.dart';
import 'package:cursinho_forum/forumMessagesScreen.dart';
import 'package:flutter/material.dart';

class ForumScreen extends StatefulWidget {
  @override
  _ForumScreenState createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  // ContactHelper helper = ContactHelper();

  // List<Contact> contacts = List();
  CollectionReference forum = FirebaseFirestore.instance.collection('forum');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forum"),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddForum()));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('forum').snapshots(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(),
                    );

                  default:
                    List<QueryDocumentSnapshot> documents = snapshot.data.docs;
                    print(documents.length);
                    return ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        return FlatButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MessagesScreen(
                                    documents[index].data()['topico']),
                              ),
                            );
                          },
                          child: Text(documents[index].data()['topico']),
                        );
                      },
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
