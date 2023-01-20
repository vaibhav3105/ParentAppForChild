import 'package:firebase_2_apps/Rules/rules.dart';
import 'package:firebase_2_apps/messages_screen.dart';
import 'package:firebase_2_apps/settingsPage.dart';
import 'package:firebase_2_apps/utils/helper.dart';
import 'package:firebase_2_apps/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'auth/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Parent App",
            ),
            InkWell(
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                await Helper.saveUserLoggedInStatus(false);
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (ctx) => LoginScreen(),
                    ),
                    (route) => false);
              },
              child: Image.asset(
                "assets/power.png",
                color: Colors.white,
                height: 29,
                width: 29,
              ),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  nextScreen(context, MessageScreen());
                },
                child: buildButton(
                  "Messages",
                  Image.asset(
                    "assets/chatting.png",
                    height: 35,
                    width: 35,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  nextScreen(context, RulePage());
                },
                child: buildButton(
                  "Rules",
                  Image.asset(
                    "assets/setting-lines.png",
                    height: 35,
                    width: 35,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () async {
                  nextScreen(context, SettingsPage());
                },
                child: buildButton(
                  "Settings",
                  Image.asset(
                    "assets/mechanical-gears-.png",
                    height: 35,
                    width: 35,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  await Helper.saveUserLoggedInStatus(false);
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (ctx) => LoginScreen(),
                      ),
                      (route) => false);
                },
                child: buildButton(
                    "Log Out",
                    Image.asset(
                      "assets/power.png",
                      height: 35,
                      width: 35,
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButton(String text, Widget icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green, width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          icon,
          Text(
            text,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
