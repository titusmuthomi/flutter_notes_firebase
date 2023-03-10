import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:tito_notes_firebase/add_note.dart';
import 'package:tito_notes_firebase/note_model.dart';
import 'package:tito_notes_firebase/single_note.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Notes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(title: 'Tito Notes'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          TextButton(
              onPressed: () => Get.to(() => const GetSingleDoc()),
              child: Text('Search'))
        ],
      ),
      body: StreamBuilder(
          stream: readNotes(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went Wrong${snapshot.error}');
            } else if (snapshot.hasData) {
              final notes = snapshot.data!;

              return ListView(
                children: notes.map(buildNote).toList(),
              );
            } else {
              return const Center(
                  child: CircularProgressIndicator(color: Colors.red));
            }
          }),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Get.to(() => const AddNote()),
          tooltip: 'Add Note',
          label: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [Icon(Icons.add), Text('Add Note')],
          )),
    );
  }

  Stream<List<Note>> readExpNotes() => FirebaseFirestore.instance
      .collection('Notes') //reference collection
      .snapshots() // get all docs
      .map(
          (snapshot) => // gives some data back and we want to convert them to json
              snapshot.docs
                  .map((doc) // going over all
                      =>
                      Note.fromJson(doc
                          .data())) // and for each we are converting to our user object based on the json
                  .toList());

  Stream<List<Note>> readNotes() => FirebaseFirestore.instance
      .collection('Notes')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Note.fromJson(doc.data())).toList());

  Widget buildNote(Note note) => ListTile(
        leading: const CircleAvatar(child: Icon(Icons.book)),
        title: Text(note.title),
        subtitle: Text(note.notes),
      );

  // A strean returns Realtime Data Incase we dont wat that
  // we return a Future builder
  // (stream) == Future readNote().first -- first snapshot

  // update date
  void deletedata() {
    final docNote = FirebaseFirestore.instance.collection('Notes').doc('note1');
    // update specific fields
    docNote.update({
      'detail': FieldValue.delete(), //deleting fields
      'title': 'ema'
    });

    // replace fields
    docNote.set({});
  }

  //delete data

  void deletedocs() {
    final docNote = FirebaseFirestore.instance.collection('Notes').doc('note1');
// deletes referenced document
    docNote.delete();
  }

  //insights Hey Flutter.com : https://www.youtube.com/watch?v=ErP_xomHKTw
}
