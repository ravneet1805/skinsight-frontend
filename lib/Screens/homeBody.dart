import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skinsight/API/apiService.dart';
import 'package:skinsight/Model/historyModel.dart';
import 'package:skinsight/Screens/cameraScreen.dart';
import 'package:skinsight/Screens/chatScreen.dart';
import 'package:skinsight/utils/constant.dart';

class HomeBody extends StatefulWidget {
  HomeBody({Key? key}) : super(key: key);

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  List<HistoryItem> historyList = [];

  @override
  void initState() {
    super.initState();
    fetchHistoryData();
  }

  Future<void> fetchHistoryData() async {
    try {
      List<HistoryItem> history = await ApiService().fetchHistory();
      setState(() {
        historyList = history;
      });
    } catch (e) {
      print('Error fetching history: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Container(
              height: height * 0.1,
              child: AnimatedTextKit(
                isRepeatingAnimation: false,
                animatedTexts: [
                  TyperAnimatedText('How may I help\nyou today?',
                      textStyle: TextStyle(
                          fontSize: width * 0.08,
                          fontWeight: FontWeight.w400),
                      speed: Duration(milliseconds: 60)),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => CameraScreen())),
                child: Container(
                  height: height * 0.25,
                  width: width * 0.45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: kGreencolor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.camera_alt_outlined,
                              size: width * 0.08,
                            ),
                            Icon(
                              Icons.arrow_outward_sharp,
                              size: width * 0.08,
                            )
                          ],
                        ),
                        Text(
                          "Skin\nDiagnostic",
                          style: GoogleFonts.manrope(
                              fontSize: width * 0.070,
                              fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ChatScreen())),
                child: Container(
                  height: height * 0.25,
                  width: width * 0.45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: kPurplecolor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline,
                              size: width * 0.08,
                            ),
                            Icon(
                              Icons.arrow_outward_sharp,
                              size: width * 0.08,
                            )
                          ],
                        ),
                        Text(
                          "Talk\nwith bot",
                          style: GoogleFonts.manrope(
                              fontSize: width * 0.070,
                              fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40,),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  "History:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              Container(
                height: height * 0.38,
                child: ListView.builder(
                  itemCount: historyList.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            
                          },
                          child: ListTile(
                            title: Text(historyList[index].disease),
                            // subtitle: Text(
                            //   historyList[index].date.toString(),
                            // ),
                          ),
                        ),
                        Divider()
                      ],
                    );
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
