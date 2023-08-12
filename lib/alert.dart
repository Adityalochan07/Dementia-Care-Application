// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';

// class EmergencyContactPage extends StatefulWidget {
//   @override
//   _EmergencyContactPageState createState() => _EmergencyContactPageState();
// }

// class _EmergencyContactPageState extends State<EmergencyContactPage> {
//   final List<Map<String, dynamic>> _contacts = [
//     {
//       'name': 'John Doe',
//       'phone': '123-456-7890',
//     },
//     {
//       'name': 'Jane Smith',
//       'phone': '555-555-5555',
//     },
//     {
//       'name': 'Bob Johnson',
//       'phone': '999-999-9999',
//     },
//   ];
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _phoneController = TextEditingController();

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _phoneController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Emergency Contacts'),
//       ),
//       body: ListView.builder(
//         itemCount: _contacts.length,
//         itemBuilder: (BuildContext context, int index) {
//           return Dismissible(
//             key: ValueKey(_contacts[index]),
//             direction: DismissDirection.endToStart,
//             background: Container(
//               color: Colors.red,
//               alignment: Alignment.centerRight,
//               padding: EdgeInsets.only(right: 16.0),
//               child: Icon(
//                 Icons.delete,
//                 color: Colors.white,
//               ),
//             ),
//             onDismissed: (direction) {
//               setState(() {
//                 _contacts.removeAt(index);
//               });
//             },
//             child: ListTile(
//               title: Text(_contacts[index]['name']),
//               subtitle: Text(_contacts[index]['phone']),
//               onTap: () {
//                 launch('tel:${_contacts[index]['phone']}');
//               },
//             ),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           showModalBottomSheet(
//             context: context,
//             builder: (BuildContext context) {
//               return Form(
//                 key: _formKey,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     TextFormField(
//                       controller: _nameController,
//                       decoration: InputDecoration(
//                         labelText: 'Name',
//                       ),
//                       validator: (value) {
//                         if (value!.isEmpty) {
//                           return 'Please enter a name';
//                         }
//                         return null;
//                       },
//                     ),
//                     TextFormField(
//                       controller: _phoneController,
//                       keyboardType: TextInputType.phone,
//                       decoration: InputDecoration(
//                         labelText: 'Phone',
//                       ),
//                       validator: (value) {
//                         if (value!.isEmpty) {
//                           return 'Please enter a phone number';
//                         }
//                         return null;
//                       },
//                     ),
//                     ElevatedButton(
//                       onPressed: () {
//                         if (_formKey.currentState!.validate()) {
//                           setState(() {
//                             _contacts.add({
//                               'name': _nameController.text,
//                               'phone': _phoneController.text,
//                             });
//                           });
//                           _nameController.clear();
//                           _phoneController.clear();
//                           Navigator.pop(context);
//                         }
//                       },
//                       child: Text('Add Contact'),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyContact {
  final String name;
  final String phone;

  EmergencyContact({required this.name, required this.phone});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
    };
  }

  static EmergencyContact fromMap(Map<String, dynamic> map) {
    return EmergencyContact(name: map['name'], phone: map['phone']);
  }
}

class EmergencyContactsPage extends StatefulWidget {
  @override
  _EmergencyContactsPageState createState() => _EmergencyContactsPageState();
}

class _EmergencyContactsPageState extends State<EmergencyContactsPage> {
  List<EmergencyContact> _contacts = [];
  final _maxContacts = 10;

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final contactsJson = prefs.getString('contacts');
    if (contactsJson != null) {
      final contactsList = (jsonDecode(contactsJson) as List)
          .map((e) => EmergencyContact.fromMap(e))
          .toList();
      setState(() {
        _contacts = contactsList;
      });
    }
  }

  Future<void> _saveContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final contactsJson = jsonEncode(_contacts.map((e) => e.toMap()).toList());
    await prefs.setString('contacts', contactsJson);
  }

  void _addContact(EmergencyContact contact) {
    setState(() {
      _contacts.add(contact);
    });
    _saveContacts();
  }

  void _editContact(int index, EmergencyContact contact) {
    setState(() {
      _contacts[index] = contact;
    });
    _saveContacts();
  }

  void _deleteContact(int index) {
    setState(() {
      _contacts.removeAt(index);
    });
    _saveContacts();
  }

  Future<void> _addContactDialog(BuildContext context) async {
    TextEditingController nameController = TextEditingController();
    TextEditingController phoneController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Contact'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                String name = nameController.text.trim();
                String phone = phoneController.text.trim();
                if (name.isNotEmpty && phone.isNotEmpty) {
                  if (_contacts.length >= _maxContacts) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            'Cannot add more than $_maxContacts contacts.')));
                  } else {
                    _addContact(EmergencyContact(name: name, phone: phone));
                    Navigator.of(context).pop();
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _editContactDialog(BuildContext context, int index) async {
    TextEditingController nameController =
        TextEditingController(text: _contacts[index].name);
    TextEditingController phoneController =
        TextEditingController(text: _contacts[index].phone);
    await showDialog(      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Contact'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                String name = nameController.text.trim();
                String phone = phoneController.text.trim();
                if (name.isNotEmpty && phone.isNotEmpty) {
                  _editContact(
                      index, EmergencyContact(name: name, phone: phone));
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteContactDialog(BuildContext context, int index) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Contact'),
          content: Text('Are you sure you want to delete this contact?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                _deleteContact(index);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _callContact(EmergencyContact contact) async {
    String phone = contact.phone;
    if (await canLaunch('tel:$phone')) {
      await launch('tel:$phone');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch phone app.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emergency Contacts'),
        backgroundColor: Colors.orange,
      ),
      body: ListView.builder(
        itemCount: _contacts.length,
        itemBuilder: (context, index) {
          EmergencyContact contact = _contacts[index];
          return ListTile(
            title: Text(contact.name),
            subtitle: Text(contact.phone),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _editContactDialog(context, index),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteContactDialog(context, index),
                ),
                IconButton(
                  icon: Icon(Icons.phone),
                  onPressed: () => _callContact(contact),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _addContactDialog(context),
         backgroundColor: Colors.orange
      ),
    );
  }
}

     

