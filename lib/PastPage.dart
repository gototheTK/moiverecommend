import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moiverecommend/GridItem.dart';
import 'package:moiverecommend/LoadingPage.dart';
import 'package:moiverecommend/LoginPage.dart';
import 'package:moiverecommend/ResultPage.dart';
import 'package:moiverecommend/SelectPage.dart';
class PastPage extends StatefulWidget {
  static String pageYear = '/oneYear';
  final year;
  final FirebaseUser user;
  PastPage(this.year, this.user);
  @override
  _PastPageState createState() => _PastPageState(year);
}
class _PastPageState extends State<PastPage> {
  List<Item> itemList;
  static List<Item> selectedList = List();
  final year;
  _PastPageState(this.year);
  void checkCount() {
    if (SelectPage.count ==5) {
      Navigator.pushReplacementNamed(
          context, '/twoYear');
    } else if (SelectPage.count == 10) {
      Navigator.pushReplacementNamed(
          context, '/threeYear');
    }else if( SelectPage.count == 15){



      List name = List();
      List img = List();
      List genre = List();
      List gender = List();
      List point = List();
      List age = List();
      List enjoy = List();
      List score = List();
      for(int i=0; i<selectedList.length; i++){
        name.add(selectedList[i].name);
        img.add(selectedList[i].imageUrl);
        genre.add(selectedList[i].genre);
        gender.add(selectedList[i].gender);
        point.add(selectedList[i].point);
        age.add(selectedList[i].age);
        enjoy.add(selectedList[i].enjoy);
        score.add(selectedList[i].score);
      }
      var save = Firestore.instance;
      save.collection('Users')
          .document(widget.user.email)
          .setData({
        'name' : name.toList(),
        'img' : img.toList(),
        'genre' : genre.toList(),
        'gender' : gender.toList(),
        'point' : point.toList(),
        'age' : age.toList(),
        'year' : [1,1,1,1,1,2,2,2,2,2,3,3,3,3,3],
        'enjoy' : enjoy.toList(),
        'score' : score.toList(),
        'completed' : true,
      }).then((onValue) {
        selectedList.removeRange(0, selectedList.length-1);
        SelectPage.count=0;
        SelectPage.completed=true;
      });
      String uptime = DateTime.now().millisecondsSinceEpoch.toString();
      save.collection('Logs').document(widget.user.email)
          .setData({
        uptime : false,
      }).then((onValue) {
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => LoadingPage(widget.user, uptime)
        ));
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      backgroundColor: Colors.black,
    );
  }
  Widget _buildBody() {
    itemList = List();
    setState(() {
      switch(year) {
        case 'oneYearData':
          for(int i=0; i< SelectPage.oneYearImgs.length; i++){
            itemList.add(Item(
                SelectPage.oneYearImgs[i],
                SelectPage.oneYearNames[i],
                SelectPage.oneYearGenres[i],
                SelectPage.oneYearAges[i],
                SelectPage.oneYearGenders[i],
                SelectPage.oneYearPoints[i],
                SelectPage.oneYearEnjoy[i],
                SelectPage.oneYearScore[i]));
          }
          break;
        case 'twoYearData':
          for(int i=0; i< SelectPage.twoYearImgs.length; i++){
            itemList.add(Item(
                SelectPage.twoYearImgs[i],
                SelectPage.twoYearNames[i],
                SelectPage.twoYearGenres[i],
                SelectPage.twoYearAges[i],
                SelectPage.twoYearGenders[i],
                SelectPage.twoYearPoints[i],
                SelectPage.twoYearEnjoy[i],
                SelectPage.twoYearScore[i]));
          }
          break;
        case 'threeYearData':
          for(int i=0; i< SelectPage.threeYearImgs.length; i++){
            itemList.add(Item(
                SelectPage.threeYearImgs[i],
                SelectPage.threeYearNames[i],
                SelectPage.threeYearGenres[i],
                SelectPage.threeYearAges[i],
                SelectPage.threeYearGenders[i],
                SelectPage.threeYearPoints[i],
                SelectPage.threeYearEnjoy[i],
                SelectPage.threeYearScore[i]));
          }
          break;
      }
    });
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.56,
            mainAxisSpacing: 2,
            crossAxisSpacing: 5),
        itemCount: itemList.length,
        itemBuilder: (context, index) {
          return GridItem(
              item: itemList[index],
              isSelected: (bool value) {
                setState(
                        () {
                      if (value) {
                        selectedList.add(
                            itemList[index]);
                        SelectPage.count++;
                        print(
                            "개수 $SelectPage.count");
                        checkCount();
                      } else {
                        selectedList.remove(
                            itemList[index]);
                        SelectPage.count--;
                        print(
                            "개수 $SelectPage.count");
                      }
                    });
                print(
                    "$index : $value");
              },
              key: Key(
                  itemList[index].name.toString(
                  )));                     }); }}
