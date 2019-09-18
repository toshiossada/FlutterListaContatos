import 'dart:io';

import 'package:agenda_contato/helpers/contact_helper.dart';
import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {
  final Contact contact;

  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  Contact _editingContact;
  bool _edited = false;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  final _nameFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    if (widget.contact == null)
      _editingContact = Contact(null, null, null, null);
    else
      _editingContact = Contact.fromMap(widget.contact.toMap());

    _nameController.text = _editingContact.name;
    _emailController.text = _editingContact.email;
    _phoneController.text = _editingContact.phone;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text(_editingContact.name ?? 'Novo Contato'),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.save),
          backgroundColor: Colors.red,
          onPressed: () {
            if (_editingContact.name != null && _editingContact.name.isNotEmpty)
              Navigator.pop(context, _editingContact);
            else
              FocusScope.of(context).requestFocus(_nameFocus);
          },
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              GestureDetector(
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: _editingContact.img != null &&
                              !_editingContact.img.isEmpty
                          ? FileImage(File(_editingContact.img))
                          : AssetImage('images/person.png'),
                    ),
                  ),
                ),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Nome'),
                onChanged: (value) {
                  setState(() {
                    _editingContact.name = value;
                    _edited = true;
                  });
                },
                controller: _nameController,
                focusNode: _nameFocus,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Email'),
                onChanged: (value) {
                  _editingContact.email = value;
                  _edited = true;
                },
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Phone'),
                onChanged: (value) {
                  _editingContact.phone = value;
                  _edited = true;
                },
                keyboardType: TextInputType.phone,
                controller: _phoneController,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _requestPop() {
    if (_edited) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Descartar alterações?'),
                content: Text('Se sair as alterações serão perdidas.'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Cancelar'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  FlatButton(
                    child: Text('Sim'),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  )
                ],
              ));
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
