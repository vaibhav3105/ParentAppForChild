import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_2_apps/Rules/rules.dart';
import 'package:firebase_2_apps/utils/styling.dart';
import 'package:firebase_2_apps/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddRuleScreen extends StatefulWidget {
  const AddRuleScreen({Key? key}) : super(key: key);

  @override
  _AddRuleScreenState createState() => _AddRuleScreenState();
}

class _AddRuleScreenState extends State<AddRuleScreen> {
  String dropDownValue = "Google Messenger";
  String mapOfDropDownValue = "Google Messenger";
  List<String> packageNameList = [
    // 'com.google.android.apps.messaging',
    // 'com.truecaller',
    // 'com.microsoft.android.smsorganizer',
  ];
  Map<String, dynamic> map = {
    // "com.google.android.apps.messaging": "Google Messenger",
    // "com.truecaller": "TrueCaller",
    // 'com.microsoft.android.smsorganizer': "Sms Organizer"
  };
  final titleController = TextEditingController();
  final bodyController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    titleController.dispose();
    bodyController.dispose();
  }

  List<String> Split(String text, String splitBy) {
    List<String> list = [];

    if (text.isEmpty) return list;

    List<String> items = text.split(splitBy);

    items.forEach(
      (element) {
        String temp = element.trim();
        if (temp.isNotEmpty) {
          list.add(temp);
        }
      },
    );

    return list;
  }

  getMapAndListFromFirebase() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection("packageNames")
        .doc("vcUGYmkZsKAOY8DnZi7f")
        .get();
    List<String> appnameslist = [];

    // List<dynamic> appNamesList = await documentSnapshot.get("Appnames");

    Map<String, dynamic> mapOfApps = await documentSnapshot.get("packages");

    mapOfApps.forEach((key, value) {
      appnameslist.add(value);
    });

    // for (var i = 0; i < appNamesList.length; i++) {
    //   appnameslist.add(appNamesList[i]);
    // }
    setState(() {
      packageNameList = appnameslist;
      map = reverseMap(mapOfApps);
    });
  }

  Map<String, dynamic> reverseMap(Map map) =>
      {for (var e in map.entries) e.value: e.key};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMapAndListFromFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Add Rule"),
          InkWell(
            onTap: () {
              nextScreen(context, RulePage());
            },
            child: Icon(
              Icons.cancel_outlined,
              color: Colors.red,
              size: 30,
            ),
          )
        ],
      )),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "App Name",
                      style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Icons.star,
                      color: Colors.red,
                      size: 16,
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                DropdownButton(
                    isExpanded: true,
                    value: dropDownValue,
                    items: packageNameList.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropDownValue = newValue!;
                        mapOfDropDownValue = map[dropDownValue]!;
                        print(mapOfDropDownValue);
                      });
                    }),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Message From",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: titleController,
                  decoration:
                      textInputDecoration.copyWith(labelText: "Message From"),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Body Contains",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: bodyController,
                  maxLines: 5,
                  scrollPadding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom + 20),
                  decoration: textInputDecoration.copyWith(
                      labelText: "Specify the words seperated by comma."),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  height: 40,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      nextScreen(context, RulePage());
                      List<String> keys =
                          Split(bodyController.text.trim(), ",");

                      DocumentSnapshot doc = await FirebaseFirestore.instance
                          .collection("users")
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .get();
                      List existingRules = doc.get("rules");

                      List newRule = [];
                      if (keys.length != 0) {
                        newRule.add({
                          "packageName": map[dropDownValue],
                          "appName": dropDownValue,
                          "title": titleController.text.trim(),
                          "keys": keys,
                          "time": DateTime.now().toString()
                        });
                      } else {
                        newRule.add({
                          "packageName": map[dropDownValue],
                          "appName": dropDownValue,
                          "title": titleController.text.trim(),
                          "keys": [],
                          "time": DateTime.now().toString()
                        });
                      }

                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .update({"rules": existingRules + newRule});
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.save),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "Save",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
