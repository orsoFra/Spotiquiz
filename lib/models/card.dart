import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../screens/questionpage.dart';

class SliderCard extends StatelessWidget {
  const SliderCard({
    super.key,
    required this.cols,
    required this.icon,
    required this.text,
    required this.isListening,
  });
  final List<Color> cols;
  final IconData icon;
  final String text;
  final int isListening;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => QuestionPage(
                  isListening: isListening,
                )));
      },
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: cols,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => QuestionPage(
                            isListening: isListening,
                          )));
                },
                style: ElevatedButton.styleFrom(primary: Colors.transparent, shadowColor: Colors.transparent),
                child: Text(text,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                    ))),
            Icon(
              icon,
              color: Colors.white,
              size: 50,
            )
          ],
        ),
      ),
    );
  }
}
