import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ParsingLoadingWidget extends StatelessWidget {
  const ParsingLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
}
