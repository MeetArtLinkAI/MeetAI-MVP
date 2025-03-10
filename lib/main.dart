import 'package:flutter/material.dart';
import 'cloud_vision_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print("✅ Running Cloud Vision API test on startup...");

  await CloudVisionService().testCloudVision();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "MeetArtLink MVP",
      home: Scaffold(
        appBar: AppBar(title: Text("MeetArtLink MVP")),
        body: Center(child: Text("The Future of Art AI is here!")),
      ),
    );
  }
}
