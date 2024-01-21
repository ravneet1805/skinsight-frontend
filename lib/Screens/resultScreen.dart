import 'dart:io';

import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:lottie/lottie.dart';
import 'package:skinsight/utils/constant.dart';
import '../API/apiService.dart';
import '../Model/resultModel.dart';
import 'chatScreen.dart';

class ResultScreen extends StatefulWidget {
  final File? image;
  final Future<Disease> disease;

  ResultScreen({Key? key, this.image, required this.disease}) : super(key: key);

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _isSaved = false;
  ApiService apiService = ApiService(); // Create an instance of ApiService

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Skin Diagnostic'),
        surfaceTintColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () async {
            // Show a confirmation dialog
            bool shouldPop = await showDialog(
              context: context,
              builder: (BuildContext dialogContext) {
                return AlertDialog(
                  title: Text('Save Result?'),
                  content: Text('Do you want to save the result?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () async {
                        Navigator.of(dialogContext).pop(true);
                        // Save the result using the API call
                        bool resultSaved =
                            await apiService.saveResultToHistory(await widget.disease, widget.image!);
                        print(resultSaved);

                        if (resultSaved) {
                          // Result saved successfully
                          setState(() {
                            _isSaved = true;
                          });
                        } else {
                          // Failed to save result
                          // Handle accordingly
                          print('Failed to save the result.');
                        }

                        // Return true to allow popping
                        Navigator.pop(context, true); // User wants to save
                      },
                      child: Text('Yes'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop(false); // User doesn't want to save
                      },
                      child: Text('No'),
                    ),
                  ],
                );
              },
            );

            if (shouldPop == true) {
              // Save the result using the API call
              // Call your API here

              // Set a flag to indicate that the result is saved
              setState(() {
                _isSaved = true;
              });

              // Return true to allow popping
              Navigator.pop(context, true);
            } else {
              // User doesn't want to save, return true to allow popping
              Navigator.pop(context, true);
            }
          },
        ),
      ),
      body: FutureBuilder<Disease>(
        future: widget.disease,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/icons/loader.json',
                    width: 200,
                    height: 200,
                  ),
                  Text('AI is at work, deciphering your skin\'s code.'),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Text(
                      'Your Result',
                      style: TextStyle(fontSize: 46, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    children: [
                      // Container for Disease Name
                      Container(
                        height: 150,
                        width: 180,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Skin Condition', style: TextStyle(fontSize: 24)),
                            AnimatedTextKit(
                              isRepeatingAnimation: false,
                              animatedTexts: [
                                TyperAnimatedText(
                                  snapshot.data?.name ?? 'N/A',
                                  textStyle: TextStyle(
                                    fontSize: 30,
                                    overflow: TextOverflow.visible,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  speed: Duration(milliseconds: 50),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 20), // Add spacing between containers
                      // Container for Image
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: kPurplecolor,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.file(
                            widget.image!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20), // Add spacing between the two rows
                  // Container for Precautions
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 2.6,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: kGreencolor, // Replace with your color variable
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Precautions:',
                            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          AnimatedTextKit(
                            isRepeatingAnimation: false,
                            animatedTexts: [
                              TyperAnimatedText(
                                snapshot.data?.precautions
                                        .map((precaution) => '- $precaution')
                                        .join('\n') ??
                                    'N/A',
                                textStyle: TextStyle(
                                  fontSize: 20,
                                ),
                                speed: Duration(milliseconds: 20),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 80,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: kPurplecolor,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                  initialMessage:
                                      '${snapshot.data?.name.substring(0, 1).toUpperCase()}${snapshot.data?.name.substring(1)}' ?? 'N/A',
                                ),
                              ),
                            );
                          },
                          child: Text(
                            'Know More About Your Condition',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                        Container(
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.deepPurple[100],
                          ),
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                    initialMessage: snapshot.data?.name ?? 'N/A',
                                  ),
                                ),
                              );
                            },
                            icon: Icon(Icons.info_outline),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
