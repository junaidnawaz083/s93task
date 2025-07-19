import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:s93task/consts/enums.dart';
import 'package:s93task/controllers/home_screen_controller.dart';
import 'package:s93task/models/parser_model.dart';
import 'package:s93task/services/parser_service.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class TextToSpeechScreen extends StatefulWidget {
  final HomeScreenController con;
  const TextToSpeechScreen({super.key, required this.con});

  @override
  State<TextToSpeechScreen> createState() => _TextToSpeechScreenState();
}

class _TextToSpeechScreenState extends State<TextToSpeechScreen> {
  final _stt = SpeechToText();
  bool _animate = false;
  String _rescognizedText = '';
  bool _isListenCompleted = false;
  ParserStatus _status = ParserStatus.none;

  @override
  void initState() {
    super.initState();
    _initSTT();
  }

  @override
  void dispose() {
    super.dispose();
    _stopListening();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width,
      height: context.height * 0.7,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: context.height * 0.1),

          SizedBox(
            height: context.height * 0.2,
            width: context.width * 0.85,
            child: Text(
              _rescognizedText,
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.w600,
                fontSize: 24,
              ),
            ),
          ),

          SizedBox(height: context.height * 0.1),
          AnimatedSwitcher(
            duration: Duration(milliseconds: 500),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child:
                _isListenCompleted
                    ? _status == ParserStatus.invalid
                        ? SizedBox(
                          height: 120,

                          child: Column(
                            children: [
                              SizedBox(
                                height: 85,
                                child: Center(
                                  child: SizedBox(
                                    height: 47,
                                    width: context.width * 0.5,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.black,
                                      ),
                                      onPressed: () async {
                                        await tryAgain();
                                      },
                                      child: Text(
                                        'Try Again',

                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                'Please try again with a valid command',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        )
                        : getInprogressParserLoadingWidget()
                    : getVoiceAnimationWidget(),
          ),
          SizedBox(height: context.height * 0.1),
        ],
      ),
    );
  }

  Future<void> tryAgain() async {
    _status = ParserStatus.none;
    _animate = false;
    _isListenCompleted = false;
    _rescognizedText = '';
    setState(() {});
    _startListening();
  }

  Widget getInprogressParserLoadingWidget() {
    return SizedBox(
      height: 120,
      child: Column(
        children: [
          SizedBox(
            height: 85,
            child: SpinKitThreeBounce(
              // size: 60,
              //color: Colors.black,
              itemBuilder:
                  (context, index) => Container(
                    height: 10,
                    width: 4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.black,
                    ),
                  ),
            ),
          ),
          Text(
            'Parsing your command ...',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget getVoiceAnimationWidget() {
    return SizedBox(
      height: 120,
      child: Column(
        children: [
          SizedBox(
            height: 85,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                animatedContainerWidget(maxHeight: 30, minHeight: 10),
                SizedBox(width: 15),
                animatedContainerWidget(maxHeight: 50, minHeight: 10),
                SizedBox(width: 15),
                animatedContainerWidget(maxHeight: 65, minHeight: 10),
                SizedBox(width: 15),
                animatedContainerWidget(maxHeight: 40, minHeight: 10),
                SizedBox(width: 15),
                animatedContainerWidget(maxHeight: 20, minHeight: 10),
                SizedBox(width: 15),
                animatedContainerWidget(maxHeight: 30, minHeight: 10),
              ],
            ),
          ),
          Text(
            'Listining....',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget animatedContainerWidget({
    required double maxHeight,
    required double minHeight,
  }) {
    return AnimatedContainer(
      onEnd: () {
        setState(() {
          _animate = false;
        });
      },
      height: _animate ? maxHeight : minHeight,
      width: 10,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.black,
      ),
      duration: Duration(milliseconds: 100),
    );
  }

  Future<void> _initSTT() async {
    bool res = await _stt.initialize(
      onStatus: (status) {
        print(status);
      },
    );
    if (!res) {
      Get.back();
      Get.showSnackbar(
        GetSnackBar(
          title: 'Denied',
          message: 'The user has denied the use of speech recognition.',
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    _startListening();
  }

  Future<void> _startListening() async {
    await _stt.listen(onResult: _onSpeechResult);
  }

  Future<void> _stopListening() async {
    await _stt.stop();
  }

  _onSpeechResult(SpeechRecognitionResult result) async {
    _rescognizedText = result.recognizedWords;
    _animate = true;

    if (_stt.isNotListening) {
      _isListenCompleted = true;
      setState(() {});
      await parseCommand(command: _rescognizedText);
      return;
    } else {}
    setState(() {});
  }

  Future<void> parseCommand({required String command}) async {
    ParserModel? model = await ParserService.instance.parseCommand(
      command: _rescognizedText.replaceAll('task ', ''),
    );
    if (model == null || model.status == ParserStatus.invalid) {
      _status = ParserStatus.invalid;
      setState(() {});
      return;
    }
    if (model.status == ParserStatus.success) {
      await widget.con.processParserModel(model: model);
    }
  }
}
