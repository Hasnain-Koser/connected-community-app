import 'dart:io';

import 'package:connected_community_app/constants/constant.dart';
import 'package:connected_community_app/models/user_model.dart';
import 'package:connected_community_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class NewServiceForm extends StatefulWidget {
  final MyUser user;
  final String type;
  NewServiceForm({this.user, this.type});
  @override
  _NewServiceFormState createState() => _NewServiceFormState();
}

class _NewServiceFormState extends State<NewServiceForm> {
  final _formKey = GlobalKey<FormState>();
  String service;
  String serviceDesc;
  File image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Text(
              'Provide a Service to your Community',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              decoration: textInputDecor.copyWith(
                  hintText: 'What Service will you be providing?'),
              validator: (value) =>
                  value.isEmpty ? 'Please enter your service' : null,
              onChanged: (value) {
                setState(() {
                  service = value;
                });
              },
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              decoration:
                  textInputDecor.copyWith(hintText: 'Describe your service'),
              validator: (value) =>
                  value.isEmpty ? 'Please enter a description' : null,
              onChanged: (value) {
                setState(() {
                  serviceDesc = value;
                });
              },
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: getImage,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: image != null
                        ? FileImage(image)
                        : AssetImage('assets/img_avatar.png'),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              child: Text(
                'Add Service',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  String serviceId = randomAlphaNumeric(12);
                  String imageURL = image != null ?await DatabaseMethods()
                      .uploadImageToStorage(image, serviceId) : null;
                  Map<String, dynamic> serviceData = {
                    'serviceBy': widget.user.uid,
                    'serviceByImg': widget.user.profileUrl,
                    'serviceByName': widget.user.name,
                    'service': service,
                    'serviceDescription': serviceDesc,
                    'serviceImg': imageURL,
                  };
                  await DatabaseMethods()
                      .addServiceToDB(widget.type, serviceId, serviceData);
                  Navigator.pop(context);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
