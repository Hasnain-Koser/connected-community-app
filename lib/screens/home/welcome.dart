import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    _controller = VideoPlayerController.asset(
      'assets/Society_Welcome_Video_2.mp4',
    );

    _initializeVideoPlayerFuture = _controller.initialize();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Society Video'),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                    color: Colors.cyan[700],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FutureBuilder(
                          future: _initializeVideoPlayerFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return AspectRatio(
                                aspectRatio: _controller.value.aspectRatio,
                                child: Column(
                                  children: [
                                    Expanded(child: VideoPlayer(_controller)),
                                    VideoProgressIndicator(_controller,
                                        allowScrubbing: true)
                                  ],
                                ),
                              );
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          },
                        ),
                        Row(
                          children: [
                            IconButton(
                                icon: Icon(
                                  _controller != null
                                      ? _controller.value.isPlaying
                                          ? Icons.pause
                                          : Icons.play_arrow
                                      : null,
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (_controller.value.isPlaying) {
                                      _controller.pause();
                                    } else {
                                      _controller.play();
                                    }
                                  });
                                }),
                            IconButton(
                                icon: Icon(Icons.replay),
                                onPressed: () {
                                  setState(() {
                                    _controller.seekTo(Duration.zero);
                                  });
                                }),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                margin: EdgeInsets.fromLTRB(130, 20, 30, 20),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.cyan,
                  borderRadius: BorderRadius.circular(16)
                ),
                child: Row(
                  children: [
                    Text('Move to Home Screen', style: TextStyle(fontSize: 17),),
                    SizedBox(width: 10,),
                    Icon(Icons.arrow_forward),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
