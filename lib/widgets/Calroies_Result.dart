import 'dart:math';

import 'package:flutter/material.dart';
import 'package:model4/services/constant.dart';

class Result extends StatelessWidget {
  final String gender;
  final int age;
  final int height;
  final int weight;
  final double calc;
  Result({required this.calc,required this.gender,required this.age,required this.weight,required this.height});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0E5D8),
      appBar: AppBar(
        backgroundColor: Color(0xFFFE7C7C),
        leading: IconButton(onPressed:(){Navigator.pop(context);} ,icon: Icon(Icons.arrow_back),),
        title: Text('Result'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
         double h =  constraints.maxHeight;
          return    Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(

                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(color: Color(0xFFF3CDA2),
                    borderRadius: BorderRadius.circular(20)),
                child: ListView(
                  children: [
                    Row(children: [
                      Expanded(child: Text('Gender:',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),)),
                      Text('${gender}',style: TextStyle(fontSize: 25,color: Colors.white,fontWeight: FontWeight.bold),)
                    ],)
             ,  space_hight(hight: h)
                    ,  Row(children: [
                      Expanded(child: Text('Age:',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),))
                      , Text('${age}',style: TextStyle(fontSize: 25,color: Colors.white,fontWeight: FontWeight.bold),)                ],)
                    ,  space_hight(hight: h)

                    ,  Row(children: [
                      Expanded(child: Text('Normal BMI:',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),))
                      , Text('${(weight/pow(height/100, 2)).round()}',style: TextStyle(fontSize: 25,color: Colors.white,fontWeight: FontWeight.bold),)
                    ],)
                    ,  space_hight(hight: h)

                    ,  Row(
                      children: [
                        Expanded(child: Text('Calories needed if used to sit a lot:',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),))
                        , Text('${(((weight*10)+(6.25*height)-(5*age)+calc)*1.2).round()}',style: TextStyle(fontSize: 25,color: Colors.white,fontWeight: FontWeight.bold),)

                      ],)
                    ,  space_hight(hight: h)

                    ,  Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(child: Text('Calories needed if you are an average activity:',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),))
                        , Text('${(((weight*10)+(6.25*height)-(5*age)+calc)*1.55).round()}',style: TextStyle(fontSize: 25,color: Colors.white,fontWeight: FontWeight.bold),)

                      ],)
                    ,  space_hight(hight: h)

                    ,  Row(
                      crossAxisAlignment: CrossAxisAlignment.end,

                      children: [
                        Expanded(child: Text('Calories needed if you are high activity:',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),))
                        , Text('${(((weight*10)+(6.25*height)-(5*age)+calc)*1.725).round()}',style: TextStyle(fontSize: 25,color: Colors.white,fontWeight: FontWeight.bold),)

                      ],),
                  ],
                ),
              ),
            ),
          );

        }),


    );
  }
}
