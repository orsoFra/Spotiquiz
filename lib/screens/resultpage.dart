import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';



class ResultPage extends StatelessWidget {
  final int score;
  const ResultPage(this.score, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(
              "Congratulations!",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
              )
            ),
          ),

          SizedBox(
            height: 45.0,
          ),

          Text(
            "Your Score is:",
            style: TextStyle(
              color: Colors.white,
              fontSize: 34.0
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Text(
            "${score}",
            style: TextStyle(
              color: Colors.orange,
              fontSize: 80.0,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      )
    );
  }
}
