import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moiverecommend/LoginPage.dart';
import 'package:moiverecommend/SelectPage.dart';

class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _handelCurrentScreen();
  }
  Widget _handelCurrentScreen(){
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          // 연결 상태가 기다리는 중이라면 로딩 페이지를 반환
          return Center(child: CircularProgressIndicator());
        } else {
          //연결이 되었고 데이터가 있다면
          if(snapshot.hasData){
            return SelectPage(snapshot.data);
          }
          return LoginPage();
        }
      },
    );
  }}
