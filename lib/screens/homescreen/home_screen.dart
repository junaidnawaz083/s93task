import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:s93task/controllers/home_screen_controller.dart';
import 'package:s93task/screens/homescreen/widgets/task_card.dart';
import 'package:s93task/screens/homescreen/widgets/text_to_speech_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final _con = Get.put(HomeScreenController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (await requestMicrophonePermission()) {
            showModalBottomSheet(
              isScrollControlled: true,
              // ignore: use_build_context_synchronously
              context: context,
              builder: (ctx) {
                return TextToSpeechScreen(con: _con);
              },
            );
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
                _con.loading
                    ? Center(child: CircularProgressIndicator())
                    : _con.taskList.isEmpty
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
                        itemCount: _con.taskList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, ind) {
                          bool showDate = false;
                          if (ind == 0) {
                            showDate = true;
                          } else {
                            showDate = checkDate(ind);
                          }
                          return TastCard(
                            themeNo: (ind + 3) % 3,
                            showDate: showDate,
                            model: _con.taskList[ind],
                          );
                        },
                      ),
                    ),
      ),
    );
  }

  bool checkDate(int index) {
    DateTime time1 = DateTime.fromMicrosecondsSinceEpoch(
      _con.taskList[index].timestemp!,
    );
    DateTime time2 = DateTime.fromMicrosecondsSinceEpoch(
      _con.taskList[index - 1].timestemp!,
    );
    return time1.day != time2.day ||
        time1.month != time2.month ||
        time1.year != time2.year;
  }

  Future<bool> requestMicrophonePermission() async {
    var status = await Permission.microphone.status;

    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      PermissionStatus newStatus = await Permission.microphone.request();
      if (newStatus.isGranted) {
        return true;
      } else {
        return false;
      }
    } else if (status.isPermanentlyDenied) {
      openAppSettings(); // Opens the app settings for the user to manually enable.
    } else if (status.isRestricted) {
      return false;
    }
    return false;
  }
}
