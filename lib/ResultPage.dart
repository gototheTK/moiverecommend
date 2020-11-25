import 'dart:collection';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:moiverecommend/DetailedPage.dart';
import 'package:moiverecommend/RootPage.dart';
import 'package:moiverecommend/SelectPage.dart';
class ResultPage extends StatefulWidget {
  static List userGenreScoreList;
  static List userEnjoyScoreList;
  static List userPreferScoreList;
  static String userGenre;
  final FirebaseUser user;
  ResultPage(this.user);
  @override
  _ResultPageState createState() => _ResultPageState();
}
class _ResultPageState extends State<ResultPage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  Firestore firestore = Firestore.instance;
  List<String> imgList = new List();
  List<String> genreList = new List();
  List<String> titleList = new List();
  List ageList = new List();
  List genderList = new List();
  List pointList = new List();
  List enjoyScoreList = new List();
  List preferScoreList = new List();
  List dateList = new List();
  List levelList = new List();
  List nationList = new List();
  List peopleList = new List();
  List directorList = new List();
  List timeList = new List();
  List contentList = new List();
  List recommendScoreList = new List();
  List timetableList = new List();
  List<Color> color = new List();
  Map dataMap = new Map();
  List userGenreScoreList = new List();
  List userEnjoyScoreList = new List();
  List userPreferScoreList = new List();
  String userGenre = '';
  int rank = 1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firestore.collection(
        widget.user.email).orderBy('rank').getDocuments(
    ).then((onValue){
      onValue.documents.forEach((f) async{
        if(f.data['rank']==-1){
          List temp0 = await f.data['genre_score'];
          List temp1 = await f.data['enjoy_score'];
          List temp2 = await f.data['prefer_score'];
          setState(() {
            userGenreScoreList = temp0;
            temp1.forEach((f){
              userEnjoyScoreList.add(f/15);
            });
            temp2.forEach((f){
              userPreferScoreList.add(f/15);
            });
          });
          userGenre = defineUserGenre();
        }else{
          var director = await f.data['director'];
          String name = await f.data['name'];
          String genre = await f.data['genre'];
          var point = await f.data['point'];
          String img = await f.data['img'];
          String date = await f.data['date'];
          String level = await f.data['level'];
          String nation = await f.data['nation'];
          var people  = await f.data['people'];
          String time = await f.data['time'];
          String content = await f.data['content'];
          var enjoyScore = await f.data['enjoy_score'];
          var preferScore = await f.data['prefer_score'];
          var recommendScore = await f.data['recommend_score'];
          var timetable = await f.data['timetable'];
          setState(() {
            directorList.add(director);
            titleList.add(name);
            genreList.add(genre);
            imgList.add(img);
            pointList.add(point);
            dateList.add(date);
            levelList.add(level);
            nationList.add(nation);
            peopleList.add(people);
            timeList.add(time);
            contentList.add(content);
            recommendScoreList.add(recommendScore);
            enjoyScoreList.add(enjoyScore);
            preferScoreList.add(preferScore);
            timetableList.add(timetable);
          });
        }
      });
    }); }
  String defineUserGenre(){
    List genreName = [
      '드라마',
      '판타지',
      '서부',
      '공포',
      '멜로/로맨스',
      '모험',
      '스릴러',
      '느와르',
      '컬트',
      '다큐멘터리',
      '코미디',
      '가족',
      '미스터리',
      '전쟁',
      '애니메이션',
      '범죄',
      '뮤지컬',
      'SF',
      '액션',
      '무협',
      '에로',
      '서스펜스',
      '서사',
      '블랙코미디',
      '실험',
      '공연실황'
    ];
    String result = '';
    Map temp = {};
    for(int i=0; i<userGenreScoreList.length; i++){
      if(userGenreScoreList[i]>2) {
        temp[genreName[i]] = userGenreScoreList[i];
      }
    }
    var sortedKeys = temp.keys.toList(growable:false)
      ..sort((k1, k2) => temp[k1].compareTo(temp[k2]));
    LinkedHashMap sortedMap = new LinkedHashMap
        .fromIterable(sortedKeys, key: (k) => k, value: (k) => temp[k]);
    var temp2 = sortedMap.keys.toList();
    for(int i=0; i<temp2.length; i++){
      int ranking = i+1;
      result += '$ranking위:' + temp2[i] + '  ' ;
    }
    return result;
  }
  @override
  Widget build(BuildContext context) {
    ResultPage.userGenreScoreList  = userGenreScoreList;
    print(userGenreScoreList);
    ResultPage.userEnjoyScoreList = userEnjoyScoreList;
    print(userEnjoyScoreList);
    ResultPage.userPreferScoreList = userPreferScoreList;
    print(userPreferScoreList);
    ResultPage.userGenre = userGenre;
    print(userGenre);
    return Scaffold(
        extendBody: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black87,
          title:
          Center(
            child: Text(
              '현재 상영 영화 추천 순위',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
          ),
          actions: <Widget>[
            new IconButton(icon: new Icon(Icons.refresh),
                onPressed: (){
                  Navigator.pushReplacementNamed(
                      context, '/result');
                })
          ],
        ),
        backgroundColor: Colors.black87,
        body:Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: imgList.length+1,
            itemBuilder: (BuildContext context, int count) {
              if(count == 0){
                return Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(padding: EdgeInsets.all(20.0))
                      ,
                      CircleAvatar(radius: 50,
                        backgroundImage: NetworkImage(widget.user.photoUrl),
                      ),
                      Padding(padding: EdgeInsets.all(10.0))
                      ,
                      Text(
                        widget.user.displayName,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white70),
                      )
                      ,
                      Padding(padding: EdgeInsets.all(10.0))
                      ,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RaisedButton(
                              textColor: Colors.white70,
                              splashColor: Colors.white70,
                              color: Colors.redAccent,
                              shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(20.0)
                              ),
                              child: Text('다시하기',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),),
                              onPressed: () {
                                SelectPage.count=0;
                                SelectPage.completed=false;
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) => SelectPage(widget.user)));
                              }),
                          Padding(padding: EdgeInsets.all(10.0)),
                          RaisedButton(
                              textColor: Colors.white70,
                              splashColor: Colors.white70,
                              color: Colors.redAccent,
                              shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(20.0)
                              ),
                              child: Text('나가기',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),),
                              onPressed: () {
                                SelectPage.count=0;
                                FirebaseAuth.instance.signOut();
                                _googleSignIn.signOut();
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) => RootPage()));
                              })
                        ],
                      ),
                      Padding(padding: EdgeInsets.all(10.0)),
                    ],
                  ),) ;
              }
              int  index = count - 1;
              var people = new List();
              peopleList[index].forEach((k, v) => people.add(k));
              return Card(
                color: Colors.black,
                margin: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                        'No. '+ (index+1).toString() +' ' + titleList[index],
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        )
                    ),
                    Container(
                      width: 350,
                      child: Image.network(
                          imgList[index],
                          fit: BoxFit.fill),
                    ),
                    Text(
                        '장르 : ' + genreList[index],
                        style:
                        TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)
                    ),
                    Text(
                        '국가/시간 : ' + nationList[index]+
                            '/'+timeList[index],
                        style:
                        TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)
                    ),
                    Text(
                        '개봉일 : ' + dateList[index],
                        style:
                        TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)
                    ),
                    Text(
                        '등급 : ' + levelList[index],
                        style:
                        TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)
                    ),
                    Text( '감독 : ' + directorList[index].keys.toList()[0],
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text( '배우 : ' + peopleList[index].keys.toList().join(', '),
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          '평점 : ',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        Container(
                          width: 300*(double.parse(pointList[index])/10),height: 20,
                          child: Text(
                            pointList[index].toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.all(Radius.circular(5.0))
                          ),
                        ),
                      ],
                    ),
                    Center(
                      child: RaisedButton(
                          textColor: Colors.white70,
                          splashColor: Colors.white70,
                          color: Colors.redAccent,
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)
                          ),
                          child: Text('더보기',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),),
                          onPressed: () {
                            Navigator.push(context,MaterialPageRoute(
                                builder: (context){
                                  return DetailedPage(
                                      titleList[index],
                                      genreList[index],
                                      recommendScoreList[index],
                                      preferScoreList[index],
                                      enjoyScoreList[index],
                                      peopleList[index],
                                      contentList[index],
                                      pointList[index],
                                      directorList[index],
                                      timetableList[index]
                                  );                                     }));                               }),                         )                       ],                     ),                   );                 },               ),       )   ); }}
