import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_2_apps/utils/styling.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'homeScreen.dart';
import 'utils/utils.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final daysController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Settings"),
            InkWell(
              onTap: () {
                nextScreen(context, HomeScreen());
              },
              child: FaIcon(
                FontAwesomeIcons.home,
                color: Colors.grey[200],
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              "Backup Duration (in days)",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 30,
            ),
            TextField(
              controller: daysController,
              keyboardType: TextInputType.number,
              decoration: textInputDecoration.copyWith(
                labelText: "Enter No. of Days",
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Note: Default 30 days, if left empty.",
              style: TextStyle(
                height: 1.3,
                fontSize: 14,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (daysController.text.trim().isEmpty ||
                        int.parse(daysController.text.trim()) > 365) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Please enter days between 1 and 365",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    } else {
                      nextScreen(context, HomeScreen());
                      FirebaseFirestore.instance
                          .collection("users")
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .update({
                        "daysBackup": int.parse(daysController.text.trim())
                      });
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      children: [
                        Icon(Icons.save),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          "Save",
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.delete,
                      ),
                      Text(
                        "Delete Manually",
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            InkWell(
              onTap: () {
                FirebaseFirestore.instance
                    .collection('data')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection('messages')
                    .get()
                    .then(
                  (snapshot) {
                    for (DocumentSnapshot ds in snapshot.docs) {
                      ds.reference.delete();
                    }
                  },
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Deleted all Messages",
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(7),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                height: 35,
                child: Text(
                  "Delete All",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
