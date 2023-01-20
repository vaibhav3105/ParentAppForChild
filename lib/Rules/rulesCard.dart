import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RulesCard extends StatefulWidget {
  final String packageName;
  final String title;
  final String body;
  final int id;
  const RulesCard({
    Key? key,
    required this.packageName,
    required this.title,
    required this.body,
    required this.id,
  }) : super(key: key);

  @override
  _RulesCardState createState() => _RulesCardState();
}

class _RulesCardState extends State<RulesCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[200],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "App",
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.packageName
                      .toString()
                      .substring(
                          widget.packageName.toString().lastIndexOf(".") + 1,
                          widget.packageName.toString().length)
                      .toUpperCase(),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (widget.title.isNotEmpty)
              Column(
                children: [
                  Divider(
                    thickness: 1.8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "From",
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.title,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            if (widget.body.isNotEmpty)
              Column(
                children: [
                  Divider(
                    thickness: 1.8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "Body",
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          widget.body,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    DocumentSnapshot doc = await FirebaseFirestore.instance
                        .collection("users")
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .get();
                    List rules = doc.get("rules");
                    rules.removeAt(widget.id);
                    await FirebaseFirestore.instance
                        .collection("users")
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .update({"rules": rules});
                  },
                  child: Text("Delete"),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
