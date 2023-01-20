import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_2_apps/Rules/rulesCard.dart';
import 'package:firebase_2_apps/homeScreen.dart';
import 'package:firebase_2_apps/utils/utils.dart';
import 'package:firebase_2_apps/widgets/add_rule_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RulePage extends StatefulWidget {
  const RulePage({Key? key}) : super(key: key);

  @override
  _RulePageState createState() => _RulePageState();
}

class _RulePageState extends State<RulePage> {
  final Stream<DocumentSnapshot> data = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Rules"),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          nextScreen(context, AddRuleScreen());
        },
        child: Icon(Icons.add),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            StreamBuilder(
              stream: data,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done ||
                    snapshot.connectionState == ConnectionState.active) {
                  List rules = snapshot.data['rules'];
                  if (snapshot.hasData && rules.length > 0) {
                    return Expanded(
                        child: ListView.builder(
                            itemCount: rules.length,
                            itemBuilder: (context, index) {
                              List keys = rules[index]['keys'];
                              String body = keys.join(",");
                              return RulesCard(
                                  packageName: rules[index]['appName'],
                                  title: rules[index]['title'],
                                  body: body,
                                  id: index);
                            }));
                  } else {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(10),
                            height: 80,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.blue, width: 2),
                            ),
                            child: Text(
                              "You have not created any rule. Click to add a new rule.",
                              style: TextStyle(
                                  fontSize: 20, color: Colors.grey[800]),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        InkWell(
                          onTap: () {
                            nextScreen(context, AddRuleScreen());
                          },
                          child: Container(
                            height: 50,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.green,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add,
                                  size: 30,
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "Add New Rule",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    );
                  }
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )
          ],
        ),
      )),
    );
  }
}
