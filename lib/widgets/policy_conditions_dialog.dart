import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/services.dart';

class PolicyConditionsDialog extends StatelessWidget {
  PolicyConditionsDialog({
  Key? key,
  this.radius = 8,
  required this.mdFileName,
  }) : assert(mdFileName.contains('.md'), 'The file must contain the .md extension'), super(key: key);

  final double radius;
  final String mdFileName;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      child: Column(
        children: [
          Expanded(
            // take file md
              child: FutureBuilder(
                future: Future.delayed(Duration(milliseconds: 150)).then((value) {
                  return rootBundle.loadString('assets/terms_and_policy/$mdFileName');
                }),
                builder: (context, snapshot){
                  if(snapshot.hasData){
                    return Markdown(
                      data: snapshot.data.toString(),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
          ),
          // show the content of md files in a text button
          TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.all(0),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(radius),
                  bottomRight: Radius.circular(radius),
                )
              )
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(radius),
                  bottomRight: Radius.circular(radius),
                )
              ),
              alignment: Alignment.center,
              height: 50,
              width: double.infinity,
              child: const Text(
                "CLOSE",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          )
        ],
      )
    );
  }
}
