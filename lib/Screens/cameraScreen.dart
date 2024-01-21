import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skinsight/Screens/previewScreen.dart';
import 'package:skinsight/utils/constant.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late List<CameraDescription> cameras;
  late CameraController cameraController;
  bool showFocus = false;
  double x = 0;
  double y = 0;
  int direction = 0;

  @override
  void initState() {
    startCamera(direction);
    super.initState();
  }

  Future<void> _onTap(TapUpDetails details) async {
    if (cameraController.value.isInitialized) {
      showFocus = true;
      x = details.localPosition.dx;
      y = details.localPosition.dy;

      double fullWidth = MediaQuery.of(context).size.width;
      double cameraHeight = fullWidth * cameraController.value.aspectRatio;

      double xp = x / fullWidth;
      double yp = y / cameraHeight;

      Offset point = Offset(xp, yp);
      print("point : $point");

      // Manually focus
      await cameraController.setFocusPoint(point);

      setState(() {
        Future.delayed(const Duration(seconds: 2)).whenComplete(() {
          setState(() {
            showFocus = false;
          });
        });
      });
    }
  }

  void startCamera(int direction) async {
    cameras = await availableCameras();

    cameraController = CameraController(
      cameras[direction],
      ResolutionPreset.max,
      enableAudio: false,
    );

    await cameraController.initialize().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((e) {
      print(e);
    });
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  Future<void> _pickImageFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PreviewScreen(file: XFile(pickedFile.path)),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    try {
      return Scaffold(
        body: GestureDetector(
          onTapUp: (details) {
            _onTap(details);
          },
          child: Stack(
            children: [
              CameraPreview(cameraController),
              if (showFocus)
                Positioned(
                  top: y - 20,
                  left: x - 20,
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        border: Border.all(color: Colors.white, width: 1)),
                  ),
                ),
              Align(
                alignment: Alignment.topCenter,
                child: AppBar(
                  backgroundColor: Colors.transparent,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 1.9,
                              child: Text(
                                'Maintain a moderate distance for a clear view.',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  direction = direction == 0 ? 1 : 0;
                                  startCamera(direction);
                                });
                              },
                              child: Icon(
                                Icons.flip_camera_ios_outlined,
                                size: 32,
                              ),
                            ),
                            GestureDetector(
                              onTap: _pickImageFromGallery ,
                              child: Icon(Icons.photo_library_outlined,
                              size: 32),
                            )
                          ],
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (!cameraController.value.isInitialized) {
                              return null;
                            }
                        
                            if (cameraController.value.isTakingPicture) {
                              return null;
                            }
                        
                            try {
                              await cameraController.setFlashMode(FlashMode.auto);
                              cameraController
                                  .takePicture()
                                  .then((XFile? file) {
                                if (mounted) {
                                  if (file != null) {
                                    print('save picture to ${file.path}');
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => PreviewScreen(file: file),
                                      ),
                                    );
                                  }
                                }
                              });
                            } on Exception catch (e) {
                              // TODO
                            }
                          },
                          child: Container(
                            height: 70,
                            decoration: BoxDecoration(
                              color: kGreencolor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                'Capture',
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
                  ),
                ),
              )
            ],
          ),
        ),
      );
    } catch (e) {
      return const SizedBox();
    }
  }
}
