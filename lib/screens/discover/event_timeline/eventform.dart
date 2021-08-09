import 'package:connected_community_app/constants/constant.dart';
import 'package:connected_community_app/services/database.dart';
import 'package:connected_community_app/services/notifier.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';

class AddEventForm extends StatefulWidget {
  @override
  _AddEventFormState createState() => _AddEventFormState();
}

class _AddEventFormState extends State<AddEventForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> types = [
    'Service',
    'Festival',
    'Community',
    'Construction'
  ];

  String _eventTitle;
  String _eventDescription;
  String _eventType;
  String error;
  String eventId;
  DateTime _fromDate = DateTime.now();
  TimeOfDay _fromTime = TimeOfDay.fromDateTime(DateTime.now());

  Future<void> _showDatePicker(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fromDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _fromDate) {
      setState(() {
        _fromDate = picked;
      });
    }
  }

  Future<void> _showTimePicker(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _fromTime,
    );
    if (picked != null && picked != _fromTime) {
      setState(() {
        _fromTime = picked;
      });
    }
  }

  genRandomEventId() {
    eventId = randomAlphaNumeric(12);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                'Update your Settings',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: textInputDecor.copyWith(hintText: 'Event Title'),
                validator: (value) =>
                    value.isEmpty ? 'Please enter an Event Title' : null,
                onChanged: (value) {
                  setState(() {
                    _eventTitle = value;
                  });
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: 8,
                maxLength: 100,
                decoration:
                    textInputDecor.copyWith(hintText: 'Event Description'),
                validator: (value) =>
                    value.isEmpty ? 'Please enter an Event Description' : null,
                onChanged: (value) {
                  setState(() {
                    _eventDescription = value;
                  });
                },
              ),
              SizedBox(
                height: 20,
              ),
              DropdownButtonFormField(
                decoration: textInputDecor,
                value: types[0],
                items: types.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Container(
                      child: Row(
                        children: [
                          getIcon(type, Colors.black54),
                          SizedBox(
                            width: 5,
                          ),
                          Text('$type'),
                        ],
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _eventType = value;
                  });
                },
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => _showDatePicker(context),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 5,
                            color: Colors.black26,
                          )
                        ],
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            DateFormat.yMd().format(_fromDate),
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _showTimePicker(context),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 5,
                            color: Colors.black26,
                          )
                        ],
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            _fromTime.format(context),
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                child: Text(
                  'Add Event',
                  style: TextStyle(color: Colors.white, fontSize: 17),
                ),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    genRandomEventId();
                    DateTime eventScheduledDate = new DateTime(
                        _fromDate.year,
                        _fromDate.month,
                        _fromDate.day,
                        _fromTime.hour,
                        _fromTime.minute);
                    Map<String, dynamic> eventData = {
                      'title': _eventTitle,
                      'description': _eventDescription,
                      'type': _eventType,
                      'scheduledDate': eventScheduledDate,
                    };
                    await Notifications()
                        .sendEventNotif(_eventTitle, _eventDescription);
                    await DatabaseMethods().addEventToTimeline(
                      eventId: eventId,
                      data: eventData,
                    );
                    Navigator.pop(context);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
