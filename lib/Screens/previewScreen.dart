import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:skinsight/API/apiService.dart';
import 'package:skinsight/API/authServices.dart';
import 'package:skinsight/Model/resultModel.dart';
import 'package:skinsight/Screens/resultScreen.dart';
import 'package:image_cropper/image_cropper.dart';

import '../utils/constant.dart';

class PreviewScreen extends StatefulWidget {
  final XFile file;
  final ApiService apiService = ApiService();

  PreviewScreen({Key? key, required this.file}) : super(key: key);

  @override
  _PreviewScreenState createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  String? croppedImagePath;

  Future<void> _cropImage(BuildContext context) async {
    File? croppedFile = await ImageCropper().cropImage(
      sourcePath: widget.file.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 90,
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: 'Crop Image',
        toolbarColor: kGreencolor,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false,
      ),
    );

    if (croppedFile != null) {
      print("Cropped image path: ${croppedFile.path}");
      setState(() {
        croppedImagePath = croppedFile.path;
      });
    }
  }

  void _proceedToResultScreen(BuildContext context) {
  String imagePath = croppedImagePath ?? widget.file.path;

  Future<Disease> disease = widget.apiService.fetchDisease(File(imagePath));
  Navigator.pop(context);
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => ResultScreen(image: File(imagePath), disease: disease),
  ));
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          croppedImagePath != null
              ? Align(
                  alignment: Alignment.topCenter,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    
                    child: Image.file(File(croppedImagePath!), height: MediaQuery.of(context).size.height/1.2, 
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.contain,
                    )),
                )
              : Align(
                  alignment: Alignment.center,
                  child: Image.file(File(widget.file.path), width: double.maxFinite,),
                ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 1.2,
                        child: Center(
                          child: Text(
                            'Preview Your Image Before Diagnosing.',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      Row(
                       mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _cropImage(context);
                            },
                            child: Container(
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(
                                color: kPurplecolor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Icon(Icons.crop,size: 30,)
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _proceedToResultScreen(context);
                            },
                            child: Container(
                              height: 70,
                              width: 260,
                              decoration: BoxDecoration(
                                color: kGreencolor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: 
                                Text(
                                  'Proceed',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
