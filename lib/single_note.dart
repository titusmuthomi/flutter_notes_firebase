import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:tito_notes_firebase/note_model.dart';

import 'poll_model.dart';

class GetSingleDoc extends StatefulWidget {
  const GetSingleDoc({super.key});

  @override
  State<GetSingleDoc> createState() => _GetSingleDocState();
}

class _GetSingleDocState extends State<GetSingleDoc> {
  String dropdownvalue1 = 'default';
  String dropdownvalue2 = 'congress';

  // List of items in our dropdown menu
  var items1 = [
    'default',
    'itvet',
    'DCIT',
  ];

  var items2 = [
    'congress',
    'female',
    'Female Delegate',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          dropdown1(),
          dropdown2(),
        ],
      ),
      body: FutureBuilder(
          future: readPoll(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went Wrong${snapshot.error}');
            } else if (snapshot.hasData) {
              final poll = snapshot.data!;

              return poll == null
                  ? Center(child: Text('No Note'))
                  : buildPoll(poll);
            } else {
              return const Center(
                  child: CircularProgressIndicator(color: Colors.red));
            }
          }),
    );
  }

  Future<Poll?> readPoll() async {
    final docPoll = FirebaseFirestore.instance
        .collection('Notes')
        .doc(dropdownvalue1)
        .collection(dropdownvalue2)
        .doc('contestant');
    final snapshot = await docPoll.get();

    if (snapshot.exists) {
      return Poll.fromJson(snapshot.data()!);
    }

    //FirebaseFirestore.instance.collection('Notes').snapshots().map((snapshot) =>
    // snapshot.docs.map((doc) => Note.fromJson(doc.data())).toList());
  }

  Widget buildPoll(Poll poll) => ListTile(
        leading: const CircleAvatar(child: Icon(Icons.book)),
        title: Text(poll.contestant1),
        subtitle: Text(poll.contestant2),
      );

  Widget dropdown1() {
    return DropdownButton(
      // Initial Value
      value: dropdownvalue1,

      // Down Arrow Icon
      icon: const Icon(Icons.keyboard_arrow_down),

      // Array list of items
      items: items1.map((String items1) {
        return DropdownMenuItem(
          value: items1,
          child: Text(items1),
        );
      }).toList(),
      // After selecting the desired option,it will
      // change button value to selected value
      onChanged: (String? newValue) {
        setState(() {
          dropdownvalue1 = newValue!;
        });
      },
    );
  }

  Widget dropdown2() {
    return DropdownButton(
      // Initial Value
      value: dropdownvalue2,

      // Down Arrow Icon
      icon: const Icon(Icons.keyboard_arrow_down),

      // Array list of items
      items: items2.map((String items2) {
        return DropdownMenuItem(
          value: items2,
          child: Text(items2),
        );
      }).toList(),
      // After selecting the desired option,it will
      // change button value to selected value
      onChanged: (String? newValue) {
        setState(() {
          dropdownvalue2 = newValue!;
        });
      },
    );
  }

  Future<Note?> readNotes() async {
    final docNote = FirebaseFirestore.instance
        .collection('Notes')
        .doc('note1')
        .collection('daf')
        .doc('femaledelegate');
    final snapshot = await docNote.get();

    if (snapshot.exists) {
      return Note.fromJson(snapshot.data()!);
    }

    //FirebaseFirestore.instance.collection('Notes').snapshots().map((snapshot) =>
    // snapshot.docs.map((doc) => Note.fromJson(doc.data())).toList());
  }

  Widget buildNote(Note note) => ListTile(
        leading: const CircleAvatar(child: Icon(Icons.book)),
        title: Text(note.title),
        subtitle: Text(note.notes),
      );
}
