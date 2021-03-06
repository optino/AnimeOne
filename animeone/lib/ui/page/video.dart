import 'dart:io';

import 'package:animeone/core/anime/AnimeVideo.dart';
import 'package:animeone/core/parser/VideoSourceParser.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:video_player/video_player.dart';

class Video extends StatefulWidget {
  
  final AnimeVideo video;
  Video({Key key, @required this.video}) : super(key: key);

  @override
  _VideoState createState() => _VideoState();

}
class _VideoState extends State<Video> {

  VideoPlayerController videoController;
  ChewieController chewie;
  VideoSourceParser parser;
  String downloadLink;
  bool canUseChewie = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    // Landscape only
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    // Fullscreen mode
    SystemChrome.setEnabledSystemUIOverlays([]);

    this.parser = new VideoSourceParser(widget.video.video);
    this.parser.downloadHTML().then((body) {
      String link = this.parser.parseHTML(body);
      if (link != null) {
        this.downloadLink = link;
        setState(() {
          this.canUseChewie = true;
          this.videoController = VideoPlayerController.network(link);
          this.chewie = ChewieController(
            videoPlayerController: videoController,
            allowedScreenSleep: false,
            aspectRatio: 16 / 9,
            autoPlay: true,
            errorBuilder: (context, msg) {
              return Text(
                '無法加載視頻\n請截圖并且聯係開發者\n鏈接:$link\n\n$msg', 
                style: TextStyle(color: Colors.white), 
                textAlign: TextAlign.center
              );
            },
            looping: false,
          );
        });
      }

      setState(() {
        this.isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    // Reset rotation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    // Reset UI overlay
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);

    this.disposeThis();
    super.dispose();
  }

  void disposeThis() {
    if (this.chewie != null) {
      // It might not be used
      this.videoController.dispose();
      this.chewie.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (this.isLoading) {
      // Still loading
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (this.canUseChewie) {
      // Use the player
      return Scaffold(
        backgroundColor: Colors.black,
        body: this.renderBody(),
        bottomNavigationBar: this.renderClose(),
      );
    } else {
      // Load webpage in app
      return WebviewScaffold(
        url: widget.video.video,
        withZoom: false,
        withLocalStorage: true,
        hidden: true,
        initialChild: Container(
          color: Colors.black,
          child: this.renderIndicator()
        ),
        bottomNavigationBar: this.renderClose(),
      );
    }
  }

  /// Only render a close button for IOS
  renderClose() {
    if (Platform.isIOS) {
      return BottomAppBar(
        child: Row(
          children: <Widget>[
            Expanded(
              child: IconButton(
                icon: Icon(Icons.close),
                tooltip: '關閉視頻',
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      );
    } else {
      // return nothing
      return SizedBox.shrink();
    }
  }

  renderBody() {
    if (this.chewie != null) {
      return SizedBox.expand(
        child: Chewie(
          controller: chewie,
        ),
      );
    } else {
      return this.renderIndicator();
    }
  }

  renderIndicator() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
  
}
