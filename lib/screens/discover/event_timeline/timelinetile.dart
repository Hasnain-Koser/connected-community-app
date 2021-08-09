import 'package:connected_community_app/constants/constant.dart';
import 'package:flutter/material.dart';

class TimelineTile extends StatefulWidget {
  final String title, description, type, date, time;
  TimelineTile({this.title, this.description, this.type, this.date, this.time});
  @override
  _TimelineTileState createState() => _TimelineTileState();
}

class _TimelineTileState extends State<TimelineTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Flexible(
              flex: 3,
              child: Container(
                child: Card(
                  margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Text(
                          widget.date,
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(widget.time)
                      ],
                    ),
                  ),
                ),
              )),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Container(
                  width: 2,
                  height: 50,
                  color: Colors.black,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: getIcon(widget.type, Colors.white),
                ),
                Container(
                  width: 2,
                  height: 50,
                  color: Colors.black,
                )
              ],
            ),
          ),
          Expanded(
            flex: 6,
            child: Container(
              height: 115,
              decoration: BoxDecoration(
                border: Border(top: BorderSide(width: 4, color: Colors.blue)),
                boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black26)],
                color: Colors.white,
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 7,),
                    Text(widget.description, textAlign: TextAlign.center)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
