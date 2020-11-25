import 'package:firebase_auth/firebase_auth.dart';
import'package:flutter/material.dart';
import 'package:moiverecommend/LoadingPage.dart';
import 'package:moiverecommend/PastPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moiverecommend/ResultPage.dart';
class SelectPage extends StatefulWidget {
  final FirebaseUser user;
  SelectPage(this.user);
  static int count = 0;
  static bool completed = true;
  static List<dynamic> oneYearNames;
  static List<dynamic> twoYearNames;
  static List<dynamic> threeYearNames;
  static List<dynamic> oneYearImgs;
  static List<dynamic> twoYearImgs;
  static List<dynamic> threeYearImgs;
  static List<dynamic> oneYearGenres;
  static List<dynamic> twoYearGenres;
  static List<dynamic> threeYearGenres;
  static List<dynamic> oneYearAges;
  static List<dynamic> twoYearAges;
  static List<dynamic> threeYearAges;
  static List<dynamic> oneYearGenders;
  static List<dynamic> twoYearGenders;
  static List<dynamic> threeYearGenders;
  static List<dynamic> oneYearPoints;
  static List<dynamic> twoYearPoints;
  static List<dynamic> threeYearPoints;
  static List<dynamic> oneYearEnjoy;
  static List<dynamic> twoYearEnjoy;
  static List<dynamic> threeYearEnjoy;
  static List<dynamic> oneYearScore;
  static List<dynamic> twoYearScore;
  static List<dynamic> threeYearScore;
  @override
  _SelectPageState createState() => _SelectPageState();}
class _SelectPageState extends State<SelectPage> {
  static final String oneYear = 'oneYearData';
  static final String twoYear = 'twoYearData';
  static final String threeYear = 'threeYearData';
  Firestore firestore = Firestore.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState(
    );
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('movieData').snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator(),);
          }
          var temps = snapshot.data.documents;
          for(int i=0; i<temps.length; i++){
            calldata(temps[i], temps[i].documentID);
          }
          return MaterialApp (
              initialRoute:  SelectPage.completed ? '/result':'/oneYear',
              routes: <String, WidgetBuilder>{
                '/oneYear': (BuildContext context) => PastPage(oneYear, widget.user),
                '/twoYear': (BuildContext context) => PastPage(twoYear, widget.user),
                '/threeYear': (BuildContext context) => PastPage(threeYear, widget.user),
                '/result' : (BuildContext context) => ResultPage(widget.user),
              }
          );
        }
    );
  }
  void calldata(documnets, id) {
    switch (id){
      case 'oneYearData':
        SelectPage.oneYearNames = documnets.data['name'];
        SelectPage.oneYearImgs =  documnets.data['img'];
        SelectPage.oneYearGenres = documnets.data['genre'];
        SelectPage.oneYearAges = documnets['age'];
        SelectPage.oneYearGenders = documnets['gender'];
        SelectPage.oneYearPoints = documnets['point'];
        SelectPage.oneYearEnjoy = documnets['enjoy'];
        SelectPage.oneYearScore = documnets['score'];
        break;
      case 'twoYearData':
        SelectPage.twoYearNames = documnets.data['name'];
        SelectPage.twoYearImgs = documnets.data['img'];
        SelectPage.twoYearGenres = documnets.data['genre'];
        SelectPage.twoYearAges = documnets['age'];
        SelectPage.twoYearGenders = documnets['gender'];
        SelectPage.twoYearPoints = documnets['point'];
        SelectPage.twoYearEnjoy = documnets['enjoy'];
        SelectPage.twoYearScore = documnets['score'];
        break;
      case 'threeYearData':
        SelectPage.threeYearNames = documnets.data['name'];
        SelectPage.threeYearImgs = documnets.data['img'];
        SelectPage.threeYearGenres = documnets.data['genre'];
        SelectPage.threeYearAges = documnets['age'];
        SelectPage.threeYearGenders = documnets['gender'];
        SelectPage.threeYearPoints = documnets['point'];
        SelectPage.threeYearEnjoy = documnets['enjoy'];
        SelectPage.threeYearScore = documnets['score'];
        break;
    }
  }
}
