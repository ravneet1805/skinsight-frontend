import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_gemini/google_gemini.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skinsight/utils/constant.dart';

const apiKey = "AIzaSyCvf16jK1sFQLT6PgghtWKCxaspatoTUPU"; //paste your gemini api here.

class ChatScreen extends StatefulWidget {
  final String initialMessage;
  const ChatScreen({
    Key? key,
    this.initialMessage =''
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ChatScreen> {
  bool loading = false;
  List<Map<String, String>> textAndImageChat = [];
  String username = '';
  

  final TextEditingController _textController = TextEditingController();
  late  ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();

    getUserName().then((value) {
    setState(() {
      username = value;
    });
  });

    // Set the initial message in the text controller
    _textController.text = widget.initialMessage;
    _controller = ScrollController();

    // Automatically send the initial message
    fromTextAndImage(query: widget.initialMessage);
  }


  @override
  void dispose() {
    _controller.dispose(); // Dispose the ScrollController when the widget is disposed.
    super.dispose();
  }

  


  // Create Gemini Instance
  final gemini = GoogleGemini(
    apiKey: apiKey,
  );

  // Text only input
  void fromTextAndImage({required String query}) {
  if (query.isNotEmpty) {
    setState(() {
      loading = true;
      textAndImageChat.add({"role": "Me", "text": query});
      _textController.clear();
    });

    gemini.generateFromText(query).then((value) {
      setState(() {
        loading = false;
        textAndImageChat.add({"role": "Gemini", "text": value.text});
      });

      WidgetsBinding.instance!.addPostFrameCallback((_) {
        scrollToTheEnd();
      });
    }).onError((error, stackTrace) {
      setState(() {
        loading = false;
        textAndImageChat.add({"role": "Gemini", "text": error.toString()});
      });

      WidgetsBinding.instance!.addPostFrameCallback((_) {
        scrollToTheEnd();
      });
    });
  }
}


  void scrollToTheEnd() {
    _controller.jumpTo(_controller.position.maxScrollExtent);
  }

  void _closeKeyboard() {
    FocusScope.of(context).unfocus();
  }

  Future<String> getUserName() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('name') ?? '';
}


  

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _closeKeyboard,
      child: Scaffold(

        appBar: AppBar(
         surfaceTintColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (textAndImageChat.isEmpty) ...[
                Expanded(
                  flex: 10,
                  child: Center(
                    child: Text(
                      'Hi $username👋\nAsk me a question :)',
                      style: TextStyle(color: Colors.deepPurpleAccent, fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ],
              Expanded(
                child: ListView.builder(
                  controller: _controller,
                  itemCount: textAndImageChat.length,
                  padding: const EdgeInsets.only(bottom: 20),
                  itemBuilder: (context, index) {
                    return ListTile(
                      isThreeLine: true,
                      leading: CircleAvatar(
                        child: Text(textAndImageChat[index]["role"]![0]),
                        backgroundColor: textAndImageChat[index]["role"]![0] =='M' ? kGreencolor: kPurplecolor ,
                      ),
                      title: Text(textAndImageChat[index]["role"]!),
                      subtitle: Text(textAndImageChat[index]["text"]!,)
                      
                      
                      ,
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 26),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _textController,
                        minLines: 1,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Write a Message',
                          contentPadding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
                          hintStyle: Theme.of(context).textTheme.bodySmall!.copyWith(height: 0),
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                        ),
                        onChanged: (value) {},
                      ),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        fromTextAndImage(query: _textController.text);
                        FocusScope.of(context).unfocus();
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.deepPurpleAccent,
                        child: SizedBox(
                          height: 16,
                          width: 16,
                          child: loading
                              ? CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                )
                              : Image.asset('assets/icons/icon-send.png'),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
