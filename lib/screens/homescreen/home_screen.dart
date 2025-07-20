import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:s93task/controllers/home_screen_controller.dart';
import 'package:s93task/screens/homescreen/widgets/task_card.dart';
import 'package:s93task/screens/homescreen/widgets/speech_to_text_widget.dart';

class HomeScreen extends GetView<HomeScreenController> {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => HomeScreenController());

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (await controller.requestMicrophonePermission()) {
            showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (ctx) {
                return SpeechToTextWidget();
              },
            );
            controller.listenToSpeech();
          }
        },
        backgroundColor: Colors.amber,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        child: const Icon(Icons.mic),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: GetBuilder<HomeScreenController>(
        builder:
            (_) =>
                controller.loading
                    ? Center(child: CircularProgressIndicator())
                    : controller.taskList.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'No task found!',
                            style: TextStyle(
                              // color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'click on mic to record your command',
                            style: TextStyle(
                              // color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    )
                    : SizedBox(
                      width: context.width,
                      height: context.height,
                      child: ListView.builder(
                        padding: EdgeInsets.only(
                          bottom: context.height * 0.2,
                          top: context.height * 0.1,
                        ),
                        itemCount: controller.taskList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, ind) {
                          bool showDate = false;
                          if (ind == 0) {
                            showDate = true;
                          } else {
                            showDate = controller.checkDate(ind);
                          }
                          return TastCard(
                            themeNo: (ind + 3) % 3,
                            showDate: showDate,
                            model: controller.taskList[ind],
                          );
                        },
                      ),
                    ),
      ),
    );
  }
}
