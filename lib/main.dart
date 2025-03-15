import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String imageUrl = "https://firebasestorage.googleapis.com/v0/b/meetartlinkai-mvp.firebasestorage.app/o/IMG_1135.JPG?alt=media";
  List<String> labels = [];

  @override
  void initState() {
    super.initState();
    fetchLabels();
  }

  Future<void> fetchLabels() async {
    String apiKey = "AIzaSyD2sjxv7D-r-1Oz0PDnFGhbvwOsjc8nru8"; // Replace with your actual API key
    String visionApiUrl = "https://vision.googleapis.com/v1/images:annotate?key=$apiKey";

    final response = await http.post(
      Uri.parse(visionApiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "requests": [
          {
            "image": {"source": {"imageUri": imageUrl}},
            "features": [{"type": "LABEL_DETECTION", "maxResults": 5}]
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final labelAnnotations = jsonResponse["responses"][0]["labelAnnotations"];

      setState(() {
        labels = labelAnnotations.map<String>((label) => label["description"].toString()).toList();
      });
    } else {
      print("Failed to get labels: ${response.body}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("MeetArtLink the Future of AI in Arts")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network(
                imageUrl,
                height: 300,
                width: 300,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return Column(
                    children: [
                      Icon(Icons.error, color: Colors.red, size: 50),
                      Text("Image Failed to Load", style: TextStyle(color: Colors.red)),
                    ],
                  );
                },
              ),
              SizedBox(height: 20), // Add spacing
              Text(
                "Detected Labels:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              labels.isNotEmpty
                  ? Column(
                      children: labels
                          .map((label) => Text(label, style: TextStyle(fontSize: 16)))
                          .toList(),
                    )
                  : CircularProgressIndicator(), // Show a loader until labels load
            ],
          ),
        ),
      ),
    );
  }
}
