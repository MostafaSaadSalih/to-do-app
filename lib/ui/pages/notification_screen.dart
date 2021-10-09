// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:getx_project/services/theme_services.dart';
import '../theme.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key, required this.payload}) : super(key: key);
  final String payload;

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String _payload = '';

  @override
  void initState() {
    super.initState();
    _payload = widget.payload;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: context.theme.backgroundColor,
        appBar: AppBar(
          backgroundColor: context.theme.backgroundColor,
          centerTitle: true,
          title: Text(
            _payload.toString().split('|')[0],
            style:
                TextStyle(color: Get.isDarkMode ? Colors.white : darkGreyClr),
          ),
          elevation: 0,
          leading: IconButton(
            onPressed:()=> Get.back(),
            icon: Icon(Icons.arrow_back_ios_new_outlined,color: Get.isDarkMode ? Colors.white : darkGreyClr,),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 5),
              Column(
                children: [
                  Text(
                    "Hello, ${_payload.toString().split('|')[0]}",
                    style: TextStyle(
                        color: Get.isDarkMode ? Colors.white : darkGreyClr,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'OpenSans'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Opss look like you have a reminder",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 30,vertical: 20),
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  decoration: BoxDecoration(
                      color: primaryClr,
                      borderRadius: BorderRadius.circular(32)),
                  child: SingleChildScrollView(
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.font_download_outlined, size: 30,color:Colors.white),
                            SizedBox(width: 10),
                            Text("Title", style: TextStyle(fontSize: 30,color:Colors.white))
                          ],
                        ),
                        SizedBox(height: 15),
                        Text(_payload.toString().split('|')[0], style: TextStyle(color:Colors.white),),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Icon(Icons.description, size: 30,color:Colors.white),
                            SizedBox(width: 10),
                            Text("Description", style: TextStyle(fontSize: 30,color:Colors.white))
                          ],
                        ),
                        SizedBox(height: 15),
                        Text(_payload.toString().split('|')[1], style: TextStyle(color:Colors.white),textAlign: TextAlign.justify,),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Icon(Icons.date_range, size: 30,color:Colors.white),
                            SizedBox(width: 10),
                            Text("Title", style: TextStyle(fontSize: 30,color:Colors.white)
                            )
                          ],
                        ),
                        SizedBox(height: 15),
                        Text(_payload.toString().split('|')[2], style: TextStyle(color:Colors.white),)
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ));
  }
}
