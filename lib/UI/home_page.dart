import 'dart:io';

import 'package:agenda_contato/UI/contact_page.dart';
import 'package:agenda_contato/helpers/contact_helper.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _helper = ContactHelper();
  var contacts = List();

  @override
  void initState() {
    super.initState();

    // Contact o = new Contact(
    //     'Toshi Ossada2', 'toshiossada@gmail.com', '19991200273', null);
    // _helper.create(o);

    getAllContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contatos'),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showContactPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemBuilder: (context, index) {
          return _contactCard(context, contacts[index]);
        },
        itemCount: contacts.length,
      ),
    );
  }

  Widget _contactCard(BuildContext context, Contact contact) {
    return GestureDetector(
      onTap: () {
        _showContactPage(contact: contact);
      },
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: contact.img != null && !contact.img.isEmpty
                        ? FileImage(File(contact.img))
                        : AssetImage('images/person.png'),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      contact.name ?? '',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      contact.email ?? '',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      contact.phone ?? '',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void getAllContacts() {
    _helper.getAll().then((list) {
      setState(() {
        contacts = list;
      });
    });
  }

  void _showContactPage({Contact contact}) async {
    final retContact = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => ContactPage(contact: contact)));

    if (retContact != null) {
      if (contact != null) {
        await _helper.update(retContact);
      } else {
        await _helper.create(retContact);
      }
      getAllContacts();
    }
  }
}
