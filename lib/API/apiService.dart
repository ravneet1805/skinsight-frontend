import 'dart:convert';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

import '../Model/historyModel.dart';
import '../Model/resultModel.dart';
import 'package:http/http.dart' as http;


class ApiService{
  Future<Disease> fetchDisease(File imageFile) async {
  try {
    print('function started');
    var request = http.MultipartRequest('POST', Uri.parse('http://192.168.50.246:4000/classify'));
    request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    var response = await request.send();

    if (response.statusCode == 200) {
      print('entered');
      // final responseData = json.decode(await response.stream.bytesToString());
      // print(responseData['predicted_class']);
      // print(responseData['precautions']);

      return Disease.fromJson(json.decode(await response.stream.bytesToString()));
    } else {
      throw Exception('Failed to load API response. Status Code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
    throw Exception('Failed to fetch disease. Error: $e');
  }
}


Future<bool> saveResultToHistory(Disease disease, File image) async {
  final String apiUrl = 'https://skinsight-kctt.onrender.com/api/v1/auth/historycreated';
    try {

         final prefs = await SharedPreferences.getInstance();

         String? userToken = await prefs.getString('user_token');
         print("token"+userToken!);

       print('sending');
       print(disease.name);
       print(disease.precautions);
      final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $userToken'
        },
      body: jsonEncode({
        'disease': disease.name,
        'precautions': disease.precautions,
      }),
    );
      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {

        print('saved');
        print('saved result. Status code: ${response.statusCode}, Response data: ${responseData['message']}');
        // Result saved successfully
        return true;
      } else {
        // Failed to save result
        print('Failed to save result. Status code: ${response.statusCode}, Response data: ${responseData['message']}');
        return false;
      }
    } catch (e) {
      // Exception occurred during the API call
      print('Exception during API call: $e');
      return false;
    }
  }


Future<List<HistoryItem>> fetchHistory() async {
  final String apiUrl = 'https://skinsight-kctt.onrender.com/api/v1/auth/historyget';
  try {
    final prefs = await SharedPreferences.getInstance();
    String? userToken = await prefs.getString('user_token');

    var response = await http.get(
      Uri.parse(apiUrl),
      headers: {'Authorization': 'Bearer $userToken'},
    );

    if (response.statusCode == 200) {
      // Parse the response into a Map
      final Map<String, dynamic> responseData = json.decode(response.body);

      // Check if the API response indicates success
      if (responseData['success'] == true) {
        // Extract the 'history' field and parse it into a List<HistoryItem>
        final List<dynamic> historyData = responseData['history'];
        List<HistoryItem> historyList = historyData
            .map((historyItem) => HistoryItem.fromJson(historyItem))
            .toList();

        return historyList;
      } else {
        // Handle the case where the API indicates failure
        throw Exception('API indicated failure. Message: ${responseData['message']}');
      }
    } else {
      throw Exception('Failed to load history. Status Code: ${response.statusCode}');
    }
  } catch (e) {
    print('Exception during API call: $e');
    throw Exception('Failed to fetch history. Error: $e');
  }
}


}