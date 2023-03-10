import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tito_notes_firebase/main.dart';
import 'package:tito_notes_firebase/note_model.dart';

class AddNote extends StatefulWidget {
  const AddNote({super.key});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  TextEditingController titleController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Add Note')),
        body: SingleChildScrollView(
          child: Form(
              child: Padding(
            padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
            child: Column(
              children: [
                TextFormField(
                  controller: titleController,
                  minLines: 2,
                  maxLines: 3,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    label: Text('My Title'),
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        borderSide: BorderSide(color: Colors.black)),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: detailsController,
                  minLines: 5,
                  maxLines: 8,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    label: Text('My Note'),
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        borderSide: BorderSide(color: Colors.black)),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: dateController,
                  textInputAction: TextInputAction.none,
                  decoration: const InputDecoration(
                    label: Text('Date'),
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        borderSide: BorderSide(color: Colors.black)),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton.icon(
                    style: const ButtonStyle(),
                    onPressed: () {
                      final title = titleController.text;
                      final details = detailsController.text;
                      final date = dateController.text;
                      //_createnote(title: title, details: details, date: date);

                      _createnotewithmodel();
                    },
                    icon: Icon(Icons.add),
                    label: Text('Add'))
              ],
            ),
          )),
        ));
  }

  Future _createnote({required String title, details, date}) async {
    DateTime timestamp = DateTime.now();
    String datetime =
        "${timestamp.millisecond}--${timestamp.hour}:${timestamp.minute}-${timestamp.day}-${timestamp.month}-${timestamp.year}";
// instantiate
    final docnote =
        FirebaseFirestore.instance.collection('Notes').doc(datetime);

    final json = {
      'id': docnote.id,
      'title': title,
      'details': details,
      'date': date
    };

    // create document and wrrite data to database
    await docnote.set(json);
    Navigator.pop(context);
  }

  Future _createnotewithmodel() async {
    DateTime timestamp = DateTime.now();
    String datetime =
        "${timestamp.millisecond}--${timestamp.hour}:${timestamp.minute}-${timestamp.day}-${timestamp.month}-${timestamp.year}";
// instantiate
    final docnote =
        FirebaseFirestore.instance.collection('Notes').doc(datetime);

    final note = Note(
        noteid: datetime,
        title: titleController.text,
        notes: detailsController.text,
        date: dateController.text);
// convert to json in class model
    final json = note.toJson();

    // create document and wrrite data to database
    await docnote.set(json);
    Navigator.pop(context);
  }
}
