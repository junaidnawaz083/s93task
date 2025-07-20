import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:s93task/consts/enums.dart';
import 'package:s93task/controllers/home_screen_controller.dart';
import 'package:s93task/screens/homescreen/widgets/parsing_loading_widget.dart';
import 'package:s93task/screens/homescreen/widgets/voiceAnimationWidget.dart';

class SpeechToTextWidget extends GetView<HomeScreenController> {
  const SpeechToTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => HomeScreenController());
    return GetBuilder<HomeScreenController>(
      builder: (con) {
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
                  controller.rescognizedText,
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
                    controller.isListenCompleted
                        ? controller.status == ParserStatus.invalid
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
                                            await controller.tryAgain();
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
                            : ParsingLoadingWidget()
                        : Voiceanimationwidget(),
              ),
              SizedBox(height: context.height * 0.1),
            ],
          ),
        );
      },
    );
  }
}
