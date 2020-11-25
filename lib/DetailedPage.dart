import 'package:flutter/material.dart';
import 'package:moiverecommend/RadarChart.dart';
import 'ResultPage.dart';
import 'dart:math';
class DetailedPage extends StatelessWidget {
  String name;
  var genre;
  var recommendScore;
  var preferScore;
  var enjoyScore;
  var people;
  var content;
  var point;
  var director;
  var timetable;
  Map region = {
    '1' : '서울',
    '2' : '인천',
    '3' : '경기',
    '4' : '대전',
    '5' : '충청',
    '6' : '강원',
    '7' : '광주',
    '8' : '전라',
    '9' : '부산',
    '10' : '대구',
    '11' : '경상',
    '12' : '제주'
  };
  DetailedPage(this.name ,this.genre, this.recommendScore, this.preferScore, this.enjoyScore, this.people, this.content, this.point, this.director, this.timetable);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0),
        backgroundColor: Colors.black87,
        body: buildBody()
    );
  }
  Widget buildBody() {
    var directKey = director.keys.toList()[0];
    var directValue = director.values.toList()[0];
    var key = people.keys.toList();
    var value = people.values.toList();
    var timetableKey = timetable.keys.toList();
    timetableKey.sort((a,b) => int.parse(a).compareTo(int.parse(b)));
    var timetableValue = new List();
    timetableKey.forEach((number) => timetableValue.add(timetable[number]));
    movieEstimate();
    print(timetable);
    print(timetableKey);
    print(timetableValue);
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(padding: EdgeInsets.all(16.0)),
            Center(
              child: Text(name,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),             ),           ),
            Padding(padding: EdgeInsets.all(16.0)),
            Center(
              child: Text('종합분석',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),            ),           ),
            Padding(padding: EdgeInsets.all(8.0)),
            Center(             child: Text(               movieEstimate(),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),             ),           ),           Padding(padding: EdgeInsets.all(16.0)),           Center(             child: Text('장르분석',               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),             ),           ),           Padding(padding: EdgeInsets.all(8.0)),          Text(             '당신의 선호장르 : ' + ResultPage.userGenre,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),           Text(             '이 영화의 장르 : ' + genre,             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),           ),           Padding(padding: EdgeInsets.all(16.0)),           Center(child:           Text('성별*나이별 만족도 분석 : '               + '\n (초록색:관객, 파란색:당신)' ,               style: TextStyle(                   fontSize: 20,                   fontWeight: FontWeight.bold,                   color: Colors.white),           textAlign: TextAlign.center,)           ),           Padding(padding: EdgeInsets.all(16.0)),           Container(             width: double.maxFinite,             height: 300,             child: RadarChart([               '남자10대','남자20대','남자30대','남자40대','남자50대',               '여자10대','여자20대','여자30대','여자40대','여자50대'],                 preferScore, ResultPage.userPreferScoreList),),           Padding(padding: EdgeInsets.all(16.0)),           Padding(padding: EdgeInsets.all(16.0)),           Center(child:           Text('감상포인트별 분석 : '               + '\n (초록색:관객, 파란색:당신)' ,               style: TextStyle(                   fontSize: 20,                   fontWeight: FontWeight.bold,                   color: Colors.white),
              textAlign: TextAlign.center,)           ),           Padding(padding: EdgeInsets.all(16.0)),           Container(             width: double.maxFinite,
              height: 300,            child: RadarChart(['연출','연기','스토리','영상미','OST'],  enjoyScore, ResultPage.userEnjoyScoreList),),           Padding(padding: EdgeInsets.all(16.0)),           Text('감독 및 주연배우',
                style : TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)
            ),
            Padding(padding: EdgeInsets.all(8.0)),
            Container(
                margin: EdgeInsets.symmetric(vertical:10.0),
                height: 200,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: List<Widget>.generate(key.length+1,
                          (index){

                        if(index==0){
                          return Column(
                            children: <Widget>[
                              Image.network(directValue),
                              Text(directKey,
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white))
                            ],
                          );
                        }

                        return Column(
                          children: <Widget>[
                            Image.network(value[index-1]),
                            Text(key[index-1],
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white))
                          ],
                        );
                      }),
                )
            )
            ,
            Card(

              color: Colors.black87,
              child: Text( '줄거리\n\n'+ this.content,
                  style : TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)
              ),
            )
            ,
            Padding(padding: EdgeInsets.all(16.0))
            ,
            Text('상영정보',
                style : TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)
            )
            ,
            Padding(padding: EdgeInsets.all(16.0))
            ,
            Container(
                margin: EdgeInsets.symmetric(vertical:10.0),
                height: 300,
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: List<Widget>.generate(timetableKey.length,
                          (index){
                        var theaters = timetableValue[index][0];
                        print(theaters);
                        var theaterKeys = theaters.keys.toList();
                        var theaterValues = theaters.values.toList();
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: Text( region[timetableKey[index]],
                                  style : TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)
                              ),
                            ),
                            Padding(padding: EdgeInsets.all(16.0)),
                            timeTable(theaterKeys, theaterValues),
                            Padding(padding: EdgeInsets.all(16.0))                   ],                 );                     }),               )           ),
            Padding(padding: EdgeInsets.all(8.0))         ],       ),     ),   ); }
  Widget timeTable(names, times){
    List<Widget> talbe = List();
    Column inform;
    for(int i=0; i<names.length; i++){
      print(names[i]);
      inform = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(names[i].toString().replaceAll('\n', ''),
              style : TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              )
          ),
          Text(times[i][0].toString().replaceAll('\n', '|'),
              style : TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)
          )
          ,
          Padding(padding: EdgeInsets.all(8.0))
        ],
      );
      talbe.add(inform);
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: talbe);
  }
  String movieEstimate(){
    List enjoy = [
      '연출',
      '연기',
      '스토리',
      '영상미',
      'OST'
    ];
    List prefer = [
      '10대 남성',
      '20대 남성',
      '30대 남성',
      '40대 남성',
      '50대 남성',
      '10대 여성',
      '20대 여성',
      '30대 여성',
      '40대 여성',
      '50대 여성'
    ];
    String result = '이 영화는 장르가 ' + genre + '이고 ';
    int index=0;
    List temp1 = enjoyScore;
    for(int i=index; i<temp1.length; i++){
      if(temp1[index]<temp1[i]){
        index=i;
        i=index;
      }
    }
    result += '감상포인트가 ' + enjoy[index];
    for(int i=0; i<temp1.length; i++){
      if(index!=i && temp1[i]==temp1[index]){
        result += ' ' + enjoy[i];
      }
    }
    result += ' 이며 ';
    index = 0;
    temp1 = preferScore;
    for(int i=index; i<temp1.length; i++){
      if(temp1[index]<temp1[i]){
        index=i;
        i=index;     }   }
    for(int i=0; i<temp1.length; i++){
      if(index!=i && temp1[i]==temp1[index]){
        result += ' ' + prefer[i];
      }   }
    result += prefer[index] + '이 좋아하는 ';
    result += '평점 ' +point.toString()
        + ' 영화입니다. 추천 점수는 ' + recommendScore.toString()
        +' 으로 ';
    if(recommendScore>75){
      result += '당신에게 추천합니다.';
    }else{
      result += '당신에게 별로 추천하지 않습니다.';
    }
    return result;
  }}
