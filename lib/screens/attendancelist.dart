import 'package:flutter/material.dart';
import '../models/dbmodel.dart';


class ListPage extends StatefulWidget{
  @override
  ListPageState createState() => ListPageState();
}

class ListPageState extends State<ListPage> {
  DB db = DB();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        minimum: EdgeInsets.only(top:40.0),
        child: FutureBuilder<List<Details>>(
          future: db.fetchAll(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Center(child: Text('No records', style: TextStyle(fontSize: 23.0, fontWeight: FontWeight.w500)));
            return new ListView(
              children: snapshot.data.map((day) {
                var temp = day.dateid.toString();
                print (temp);
                var date = '${temp[6]}${temp[7]} - ${temp[4]}${temp[5]} - ${temp[2]}${temp[3]}';
                var boxcolor = Colors.white;
                if(day.total / day.working < 4/6)
                {
                  boxcolor = Colors.red[50];
                  if(day.total / day.working < 2/6)
                  {
                    boxcolor = Colors.red[100];
                    if(day.total == 0) boxcolor = Colors.red[200];
                  }
                }
                if(day.total / day.working == 1 ) boxcolor = Colors.green[100];

                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
                  child: GestureDetector(
                    child:Container(
                      padding: EdgeInsets.all(20.0),
                      decoration: BoxDecoration(color: boxcolor, borderRadius: BorderRadius.circular(4.0)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Text(date, style: TextStyle(color: Colors.black, fontSize: 15.0),),
                          ),
                          Container(
                            child: Text('${day.total} / ${day.working}', style: TextStyle(color: Colors.black, fontSize: 15.0),),
                          ),
                        ],
                      ),
                    ),
                    onPanUpdate: (move) {
                      if(move.delta.dx != 0) {
                        print('swiped');
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Delete?'),
                              content: Text('If you confirm, the data of the date cannot be restored.'),
                              actions: <Widget>[
                                new FlatButton(
                                  child: Text('Cancel'),
                                  onPressed: () { Navigator.of(context).pop(); }
                                ),
                                new FlatButton(
                                  child: Text('Delete'),
                                  onPressed: () { 
                                    setState(() { day.remove(); Navigator.of(context).pop(); }); 
                                  },
                                )
                              ],
                            );
                          }
                        );
                      }
                    },
                  ),
                );
              }).toList(),
            );
          },
        )
      ),
    );
  }
}