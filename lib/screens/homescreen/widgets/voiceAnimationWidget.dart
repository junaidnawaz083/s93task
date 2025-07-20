import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:s93task/controllers/home_screen_controller.dart';

class Voiceanimationwidget extends GetView<HomeScreenController> {
  const Voiceanimationwidget({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => HomeScreenController());
    return GetBuilder<HomeScreenController>(
      builder: (con) {
        return getVoiceAnimationWidget();
      },
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
        controller.animate = false;
        controller.update();
      },
      height: controller.animate ? maxHeight : minHeight,
      width: 10,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.black,
      ),
      duration: Duration(milliseconds: 100),
    );
  }
}
