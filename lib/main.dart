import "package:flutter/material.dart";
import 'package:form/service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'adout.dart';
import 'alert.dart';
import 'contact.dart';
import 'health.dart';
import 'home.dart';

void main() {
  runApp(MaterialApp(
    title: "MyApp",
    home: MyApp(),
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return Menubottom();
  }
}

Future<void> _launchURL(String url) async {
  final Uri uri = Uri(scheme: "https", host: url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    throw "Cannot launch url";
  }
}

Future<void> _ebooklaunchURL(String url) async {
  final Uri uri = Uri(scheme: "https", host: url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    throw "Cannot launch url";
  }
}

Future<void> _launchSpotify() async {
  const url = 'spotify://';
  const fallbackUrl = 'https://www.spotify.com/';

  if (await canLaunch(url)) {
    await launch(url);
  } else {
    await launch(fallbackUrl);
  }
}

class Menubottom extends State<MyApp> {
  List pages = [
    DementiaStages(),
    MapScreen(),
    reminder(),
    contact(),
  ];
  int currentIndex = 0;
  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text("Dementia Care App"),
      ),
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.black,

        onTap: onTap,
        currentIndex: currentIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.gps_fixed), label: "gps"),
          BottomNavigationBarItem(icon: Icon(Icons.note), label: "Remainder"),
          BottomNavigationBarItem(icon: Icon(Icons.contacts), label: "Contact"),
        ],
        //  currentIndex: 0,
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            Container(
                color: Colors.orange,
                padding: EdgeInsets.all(60.0),
                child: Column(
                  children: <Widget>[
                    Center(
                      child:
                          Center(child:Text("Dementia Care App Created By MITT Students",
                           style: TextStyle(
                           fontStyle: FontStyle.italic,
                           fontSize: 18,
                           fontWeight: FontWeight.bold,
                           color: Colors.black,
  ),)),
                          
                    )
                  ],
                )),
            ListTile(
              leading: Icon(Icons.emergency),
              title: Text("Emergence Alert"),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) =>  EmergencyContactsPage()));
              },
            ),
           
            ListTile(
              leading: Icon(Icons.medical_services_outlined),
              title: Text("To Do..."),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => health()));
              },
            ),
            ListTile(
              leading: Icon(Icons.music_note_rounded),
              title: Text("Music"),
              onTap: () {
               
                _launchSpotify();
              },
            ),
            Container(
                child: Center(
              child: Text("Entertainment"),
            )),
            ListTile(
                title: Text("Mind Games"),
                leading: Icon(Icons.games),
                onTap: (() {
                  _launchURL("www.mindgames.com");
                })),
            ListTile(
              leading: Icon(Icons.book),
              title: Text("Reading"),
              onTap: () {
                _ebooklaunchURL("bookauthority.org");
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: (
            () async {
            final Uri uri = Uri(scheme: 'sms');

            if (await canLaunchUrl(uri)) {
              await launchUrl(uri);
            } else {
              print('show dialog:Cannot launch this url');
            }
          }),
           backgroundColor: Colors.orange,
          child: Icon(Icons.message)),
    );
  }
  
}



