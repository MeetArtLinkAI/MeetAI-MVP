import 'dart:convert';
import 'package:http/http.dart' as http;

class CloudVisionService {
  static const String apiKey = 'AIzaSyD2sjxv7D-r-1Oz0PDnFGhbvwOsjc8nru8';  // Replace with your actual key
  static const String apiUrl = 'https://vision.googleapis.com/v1/images:annotate?key=$apiKey';
}


  Future<List<String>> analyzeImage(String imageUrl) async {
    final Map<String, dynamic> requestBody = {
      "requests": [
        {
          "image": {"source": {"imageUri": imageUrl}},
          "features": [
            {"type": "LABEL_DETECTION", "maxResults": 5}
          ]
        }
      ]
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<String> labels = [];
      for (var annotation in data['responses'][0]['labelAnnotations']) {
        labels.add(annotation['description']);
      }
      return labels;
    } else {
      throw Exception("Failed to analyze image");
    }
  }
}



