import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  static Route<dynamic> route() => MaterialPageRoute(
    builder: (context) => AboutPage(),
  );

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About"),
      ),
      body: Container(
        margin: const EdgeInsets.all(10.0), child: Column(
        mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[ Text("About"),
      ],
      ), ),
    );
  }
}
