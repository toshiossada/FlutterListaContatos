import 'dart:io';

import 'package:agenda_contato/UI/contact_page.dart';
import 'package:agenda_contato/helpers/contact_helper.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

enum OrderOption { orderAZ, orderZA }

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _helper = ContactHelper();
  var contacts = List<Contact>();

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
        actions: <Widget>[
          PopupMenuButton<OrderOption>(
            itemBuilder: (context) => <PopupMenuEntry<OrderOption>>[
              const PopupMenuItem<OrderOption>(
                child: Text('Ordenar A-Z'),
                value: OrderOption.orderAZ,
              ),
              const PopupMenuItem<OrderOption>(
                child: Text('Ordenar Z-A'),
                value: OrderOption.orderZA,
              ),
            ],
            onSelected: _orderList,
          )
        ],
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
        _showOptions(context, contact);
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
                    fit: BoxFit.cover,
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

  void _showOptions(BuildContext context, Contact contact) {
    showModalBottomSheet(
        context: context,
        builder: (context) => BottomSheet(
              builder: (context) => Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: FlatButton(
                        child: Text(
                          'Ligar',
                          style: TextStyle(color: Colors.red, fontSize: 20),
                        ),
                        onPressed: () {
                          launch('tel:${contact.phone}');
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: FlatButton(
                        child: Text(
                          'Editar',
                          style: TextStyle(color: Colors.red, fontSize: 20),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          _showContactPage(contact: contact);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: FlatButton(
                        child: Text(
                          'Excluir',
                          style: TextStyle(color: Colors.red, fontSize: 20),
                        ),
                        onPressed: () {
                          _helper.delete(contact.id);
                          setState(() {
                            contacts.remove(contact);
                            Navigator.pop(context);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              onClosing: () {},
            ));
  }

  void _orderList(OrderOption result) {
    switch (result) {
      case OrderOption.orderAZ:
        contacts.sort(
            (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        break;
      case OrderOption.orderZA:
        contacts.sort(
            (a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()));
        break;
    }

    setState(() {});
  }
}
