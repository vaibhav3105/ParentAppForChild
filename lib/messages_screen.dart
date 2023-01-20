import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_2_apps/homeScreen.dart';

import 'package:firebase_2_apps/utils/utils.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  Map<String, dynamic> map = {};
  @override
  int totalChildren = 0;
  String pickeddate = "";
  bool isLoading = false;
  List<String> childrenNames = [];
  List<String> deviceIds = [];
  String dropdownValue = "";
  List<DocumentSnapshot> documents = [];
  String searchText = '';
  final searchController = TextEditingController();
  final dateController = TextEditingController();
  @override
  String decode(String message) {
    String decoded = utf8.decode(base64Decode(message));
    return decoded;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      isLoading = true;
    });

    getTotalChildren();
    getMapAndListFromFirebase();

    dateController.text = DateTime.now().toString().substring(0, 10);
    pickeddate = DateTime.now().toString().substring(0, 10);
  }

  getMapAndListFromFirebase() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection("packageNames")
        .doc("vcUGYmkZsKAOY8DnZi7f")
        .get();

    Map<String, dynamic> mapOfApps = await documentSnapshot.get("packages");

    setState(() {
      map = mapOfApps;
    });
  }

  getTotalChildren() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    List<dynamic> children = doc.get("children");

    List<String> childNames = [];
    for (var i = 0; i < children.length; i++) {
      childNames.add(children[i]["childName"]!);
    }
    List<String> deviceids = [];
    for (var i = 0; i < children.length; i++) {
      deviceids.add(children[i]["deviceId"]!);
    }
    setState(() {
      totalChildren = children.length;
      childrenNames = childNames;
      dropdownValue = childrenNames.first;
      deviceIds = deviceids;
      isLoading = false;
    });
  }

  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    int index = childrenNames.indexOf(dropdownValue);
    final Stream<QuerySnapshot> data = FirebaseFirestore.instance
        .collection("data")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("messages")
        .where("child", isEqualTo: deviceIds[index])
        .orderBy("time", descending: true)
        .snapshots();
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Messages"),
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Child Name",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "Date",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container()
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    DropdownButton(
                      dropdownColor: Colors.grey[300],
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 40,
                      itemHeight: 50,
                      value: dropdownValue,
                      items: childrenNames
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w400),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          dropdownValue = value!;
                        });
                      },
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: dateController,
                        decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.all(8),
                            icon: Icon(Icons.calendar_today),
                            labelText: "Enter Date",
                            border: OutlineInputBorder()),
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2040));
                          if (pickedDate != null) {
                            String formattedDate =
                                DateFormat('yyyy-MM-dd').format(pickedDate);

                            setState(() {
                              dateController.text = formattedDate;
                              pickeddate = formattedDate;
                              print(dateController.text);
                              print(searchText);
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    setState(() {
                      searchText = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search by Message or App Name',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              StreamBuilder<QuerySnapshot>(
                stream: data,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.active ||
                      snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      documents = snapshot.data.docs;
                      if (searchText.length > 0 && pickeddate.isNotEmpty) {
                        List<DocumentSnapshot> z = documents.where((element) {
                          return element
                              .get('time')
                              .toString()
                              .toLowerCase()
                              .contains(pickeddate.trim().toLowerCase());
                        }).toList();
                        List<DocumentSnapshot> x = documents.where((element) {
                          return decode(element.get('content').toString())
                              .toLowerCase()
                              .contains(searchText.trim().toLowerCase());
                        }).toList();
                        // List<DocumentSnapshot> y = documents.where((element) {
                        //   return element
                        //       .get('package')
                        //       .toString()
                        //       .toLowerCase()
                        //       .contains(searchText.trim().toLowerCase());
                        // }).toList();

                        // documents = (x + y + z).toSet().toList();
                        z.removeWhere((item) => !x.contains(item));
                        // z.removeWhere((item) => !y.contains(item));
                        documents = z;
                      } else if (searchText.trim().isEmpty &&
                          pickeddate.isNotEmpty) {
                        List<DocumentSnapshot> z = documents.where((element) {
                          return element
                              .get('time')
                              .toString()
                              .toLowerCase()
                              .contains(pickeddate.trim().toLowerCase());
                        }).toList();
                        documents = z.toSet().toList();
                      }
                      return Expanded(
                        child: ListView.builder(
                          itemCount: documents.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 12),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey, width: 1.5),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      documents[index]['title'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
                                    ),
                                    Divider(
                                      thickness: 0.5,
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Text(decode(documents[index]['content'])),
                                    Divider(
                                      thickness: 0.5,
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          map[documents[index]['package']],
                                          style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 10),
                                        ),
                                        Text(
                                          documents[index]['time']
                                              .toString()
                                              .substring(0, 19),
                                          style: TextStyle(
                                            fontSize: 10,
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return Text("No Data");
                    }
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
