import 'dart:typed_data';
import "package:flutter/material.dart";
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:url_launcher/url_launcher.dart';

class contact extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return contactState();
  }
}

class contactState extends State<contact> {
  List<Contact>? contacts;
  @override
  void initState() {
    super.initState();
    getPhoneData();
  }

  void getPhoneData() async {
    if (await FlutterContacts.requestPermission()) {
      contacts = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: true);

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: (contacts == null)
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: contacts!.length,
                itemBuilder: (BuildContext context, int index) {
                  Uint8List? image = contacts![index].photo;
                  String? number = (contacts![index].phones.isNotEmpty)
                      ? contacts![index].phones.first.number
                      : "----";
                  return ListTile(
                    leading: (image == null)
                        ? CircleAvatar(
                            child: Icon(Icons.person),
                          )
                        : CircleAvatar(
                            backgroundImage: MemoryImage(image),
                          ),
                    title: Text(contacts![index].name.first),
                    subtitle: Text(number),
                    onTap: (() {
                      launch('tel:${number}');
                    }),
                  );
                }));
  }
}
