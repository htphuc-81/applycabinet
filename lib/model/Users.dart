import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Users {
  String defiKey;
  String email;
  String firstname;
  String lastname;

  Users({this.defiKey, this.email, this.firstname, this.lastname});

  Users.from({String key, Map data}) {
    defiKey = key;
    email = data['email'];
    firstname = data['firstname'];
    lastname = data['lastname'];
  }
}
