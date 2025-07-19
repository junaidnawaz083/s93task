import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (ctx) {
              return TextToSpeechScreen(con: _con);
            },
          );
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
}
