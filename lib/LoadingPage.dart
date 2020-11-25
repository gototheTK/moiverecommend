import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moiverecommend/ResultPage.dart';
import 'package:moiverecommend/SelectPage.dart';
class LoadingPage extends StatefulWidget {
  final FirebaseUser user;
  final String updateTime;
  LoadingPage(this.user, this.updateTime);
  @override
  _LoadingPageState createState() => _LoadingPageState();}
class _LoadingPageState extends State<LoadingPage> {
  @override
  Widget build(BuildContext context) {
    StreamController<DocumentSnapshot> triggerController = StreamController();
    Stream<DocumentSnapshot> event = Firestore.instance.collection('Logs').document(widget.user.email).snapshots();
    triggerController.addStream(event);
    event.listen((onData){
      print(onData.data);
      if(onData.exists){
        if(onData[widget.updateTime] == true){
          Navigator.pushReplacementNamed(context, '/result');
        }
      }
    });
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
      backgroundColor: Colors.black87,
    );
  }
}
