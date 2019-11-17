import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../models/dbmodel.dart';
import 'attendancelist.dart';




class HomePage extends StatefulWidget{
  @override
  HomePageState createState() => HomePageState();
}


class HomePageState extends State<HomePage> {

  final db = DB();
  DateTime selectedDate = DateTime.now();
  Stats stats = new Stats(0,0);
  Details day = new Details(DateTime.now());

  int dateid(DateTime date) 
  {
    var temp = date.year.toString();
    if(date.month < 10) temp = temp + '0';
    temp = temp + date.month.toString();
    if(date.day < 10) temp = temp + '0';
    temp = temp + date.day.toString();
    return int.parse(temp);
  }



  Future<Null> _selectDate(BuildContext context) async 
  {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2019, 6),
      lastDate: DateTime(2020, 5)
    );
    if (picked != null && picked != selectedDate)
    {
      if(picked.isAfter(DateTime.now())) return;
      if(picked.weekday==7 || picked.weekday==6) return;

      setState(() {
        selectedDate = picked;
        day = new Details(selectedDate);
      });
    }
  }



  
  @override
  Widget build(BuildContext context) {
    if(selectedDate.weekday == 7) selectedDate = selectedDate.add(Duration(days: -2));
    if(selectedDate.weekday == 6) selectedDate = selectedDate.add(Duration(days: -1));
    day.refresh();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          children: <Widget>[

              Container(
                padding: EdgeInsets.fromLTRB(0.0, 35.0, 0.0, 30.0),
                child: Center(
                  child: Text(
                    'ATTENDANCE TRACKER', 
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15.0),
                  )
                )
              ),

              Container(
                decoration: BoxDecoration(color: Colors.grey[100]),
                padding: EdgeInsets.fromLTRB(25.0, 30.0, 25.0, 50.0),
                child: Column(
                  children: <Widget>[

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Text(
                            "${selectedDate.day} - ${selectedDate.month} - ${selectedDate.year}",
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(5.0),
                          child: RaisedButton(
                            onPressed: () => _selectDate(context),
                            child: Text('change date'),
                            color: Colors.white,  
                          )
                        )
                      ],
                    ),

                    SizedBox(height: 30.0,),

                    Row(
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            padding: EdgeInsets.symmetric(vertical: 25.0),
                            color: Colors.white,
                            elevation: 1.0,
                            child: new Column(  
                              children: <Widget>[
                                Icon(day.h1 ? Icons.check_circle_outline:Icons.error_outline, color: day.h1 ? Colors.blue:Colors.red[200],),
                                SizedBox(height:12.0),
                                Text(day.h1 ? 'Present':'Absent'),
                              ]
                            ),
                            onPressed: () {
                              setState(() {
                                day.h1 = !day.h1;
                                if(day.h1 == true) day.total += 1;
                                else day.total -= 1;
                                day.update();
                                stats.update();
                              });
                            },
                          )
                        ),
                        SizedBox(width: 20.0,),
                        Expanded(
                          child: RaisedButton(
                            padding: EdgeInsets.symmetric(vertical: 25.0),
                            color: Colors.white,
                            elevation: 1.0,
                            child: new Column(  
                              children: <Widget>[
                                Icon(day.h2 ? Icons.check_circle_outline:Icons.error_outline, color: day.h2 ? Colors.blue:Colors.red[200],),
                                SizedBox(height:12.0),
                                Text(day.h2 ? 'Present':'Absent'),
                              ]
                            ),
                            onPressed: () {
                              setState(() {
                                day.h2 = !day.h2;
                                if(day.h2 == true) day.total += 1;
                                else day.total -= 1;
                                day.update();
                                stats.update();
                              });
                            },
                          )
                        ),
                        SizedBox(width: 20.0,),
                        Expanded(
                          child: RaisedButton(
                            padding: EdgeInsets.symmetric(vertical: 25.0),
                            color: Colors.white,
                            elevation: 1.0,
                            child: new Column(  
                              children: <Widget>[
                                Icon(day.h3 ? Icons.check_circle_outline:Icons.error_outline, color: day.h3 ? Colors.blue:Colors.red[200],),
                                SizedBox(height:12.0),
                                Text(day.h3 ? 'Present':'Absent'),
                              ]
                            ),
                            onPressed: () {
                              setState(() {
                                day.h3 = !day.h3;
                                if(day.h3 == true) day.total += 1;
                                else day.total -= 1;
                                day.update();
                                stats.update();
                              });
                            },
                          )
                        ),
                      ],
                    ),
                    SizedBox(height:20.0),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            padding: EdgeInsets.symmetric(vertical: 25.0),
                            color: Colors.white,
                            elevation: 1.0,
                            child: new Column(  
                              children: <Widget>[
                                Icon(day.h4 ? Icons.check_circle_outline:Icons.error_outline, color: day.h4 ? Colors.blue:Colors.red[200],),
                                SizedBox(height:12.0),
                                Text(day.h4 ? 'Present':'Absent'),
                              ]
                            ),
                            onPressed: () {
                              setState(() {
                                day.h4 = !day.h4;
                                if(day.h4 == true) day.total += 1;
                                else day.total -= 1;
                                day.update();
                                stats.update();
                              });
                            },
                          )
                        ),
                        SizedBox(width: 20.0,),
                        Expanded(
                          child: RaisedButton(
                            padding: EdgeInsets.symmetric(vertical: 25.0),
                            color: Colors.white,
                            elevation: 1.0,
                            child: new Column(  
                              children: <Widget>[
                                Icon(day.h5 ? Icons.check_circle_outline:Icons.error_outline, color: day.h5 ? Colors.blue:Colors.red[200],),
                                SizedBox(height:12.0),
                                Text(day.h5 ? 'Present':'Absent'),
                              ]
                            ),
                            onPressed: () {
                              setState(() {
                                day.h5 = !day.h5;
                                if(day.h5 == true) day.total += 1;
                                else day.total -= 1;
                                day.update();
                                stats.update();
                              });
                            },
                          )
                        ),
                        SizedBox(width: 20.0,),
                        Expanded(
                          child: RaisedButton(
                            padding: EdgeInsets.symmetric(vertical: 25.0),
                            color: Colors.white,
                            elevation: 1.0,
                            child: new Column(  
                              children: <Widget>[
                                Icon(day.h6 ? Icons.check_circle_outline:Icons.error_outline, color: day.h6 ? Colors.blue:Colors.red[200],),
                                SizedBox(height:12.0),
                                Text(day.h6 ? 'Present':'Absent'),
                              ]
                            ),
                            onPressed: () {
                              setState(() {
                                day.h6 = !day.h6;
                                if(day.h6 == true) day.total += 1;
                                else day.total -= 1;
                                day.update();
                                stats.update();
                              });
                            },
                          )
                        ),
                      ],
                    )
                  ],
                )
              ),

              Container(
                  padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 25.0),
                  decoration: BoxDecoration(
                    color: Colors.white, 
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Center(
                    child: CircularPercentIndicator(
                      radius: 150.0,
                      animation: true,
                      animationDuration: 1200,
                      lineWidth: 15.0,
                      percent: stats.working==0 ? 0.0 : stats.total/stats.working,
                      center: new Text(
                        "${stats.total} / ${stats.working}",
                        style: new TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0),
                      ),
                      circularStrokeCap: CircularStrokeCap.butt,
                      backgroundColor: Colors.grey[200],
                      progressColor: Colors.blue[800],
                    ),
                  )
              ),

              Container(
                padding: EdgeInsets.symmetric(vertical:10.0), 
                child:Center(
                  child: FlatButton(
                    child: Text('view all attendance',),
                    onPressed: () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => ListPage())
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}