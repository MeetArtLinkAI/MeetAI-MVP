import 'dart:convert';
import 'package:http/http.dart' as http;

class CloudVisionService {
  static const String apiKey = "YOUR_API_KEY_HERE";
  static const String apiUrl = "https://vision.googleapis.com/v1/images:annotate?key=$apiKey";

  Future<void> testCloudVision() async {
    print("🚀 Sending test request to Cloud Vision API...");

    final Map<String, dynamic> requestBody = {
      "requests": [
        {
          "image": {
            "source": {
              "imageUri": "https://upload.wikimedia.org/wikipedia/commons/6/6a/VanGogh-starry_night_ballance1.jpg"
            }
          },
          "features": [
            {"type": "LABEL_DETECTION"}
          ]
        }
      ]
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      print("✅ Cloud Vision API Response:");
      print(response.body);
    } catch (e) {
      print("❌ Cloud Vision API Error: $e");
    }
  }
}


