import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:spotiquiz/models/question_model.dart';

final assetsAudioPlayer = AssetsAudioPlayer();
//bool isPlaying = false;
void playPauseAudioNetwork(String URL, bool doPlay) async {
  if (!doPlay) {
    assetsAudioPlayer.pause();
  } else {
    try {
      await assetsAudioPlayer.open(Audio.network(URL), autoStart: false, showNotification: true);
      assetsAudioPlayer.play();
    } catch (t) {
      print(t);
    }
  }
}

class QuestionWidget extends StatefulWidget {
  QuestionModel question;
  int index;
  QuestionWidget({super.key, required this.question, required this.index});

  @override
  State<QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  ValueNotifier<bool> isPlaying = ValueNotifier(false);

  @override
  void initState() {
    isPlaying = ValueNotifier<bool>(false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
      SizedBox(
        width: double.infinity,
        child: Text(
          "Question${widget.index}/10",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w300,
            fontSize: 28.0,
          ),
        ),
      ),

      Divider(
        color: Colors.white,
        height: 8.0,
        thickness: 1.0,
      ),

      const SizedBox(
        height: 20.0,
      ),

      SizedBox(
        width: double.infinity,
        height: 200.0,
        child: Text(
          widget.question.question,
          style: TextStyle(color: Colors.white, fontSize: 22.0),
        ),
      ),
      if (widget.question.songURL != null)
        ValueListenableBuilder(
            valueListenable: isPlaying,
            builder: (context, value, child) => IconButton(
                iconSize: 50,
                icon: (isPlaying.value) ? const Icon(Icons.stop) : Icon(Icons.play_arrow),
                onPressed: () {
                  isPlaying.value = !isPlaying.value;
                  playPauseAudioNetwork(widget.question.songURL!, isPlaying.value);
                })),

      SizedBox(
        height: 25.0,
      ),

      // generate 4 bottons for the answers
      for (int i = 0; i < widget.question.answers.length; i++)
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(bottom: 18.0),
          child: MaterialButton(
            shape: StadiumBorder(),
            color: Colors.blueAccent,
            padding: EdgeInsets.symmetric(vertical: 18.0),
            onPressed: () {},
            child: Text(widget.question.answers[i], style: TextStyle(color: Colors.white)),
          ),
        ),
      SizedBox(
        height: 30.0,
      ),
      OutlinedButton(
        onPressed: () {},
        style: ButtonStyle(
            // we will do it later
            ),
        child: Text(
          "Next Question",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      )
    ]);
  }
}
