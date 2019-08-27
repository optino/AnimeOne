import 'package:animeone/core/anime/AnimeVideo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

/// Takes an AnimeVideo object and render it to an Image
class AnimeCoverImage extends StatelessWidget {

  final AnimeVideo video;

  AnimeCoverImage({Key key, @required this.video}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        return Stack(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 16 / 9,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset('lib/assets/cover/${video.image}.jpg'),
              )
            ),
            Positioned.fill(
              child: IconButton(
                onPressed: () {
                  video.launchURL();
                },
                iconSize: constraint.maxWidth / 6,
                icon: Icon(Icons.play_circle_outline),
                color: Colors.white,
              ),
            )
          ]
        );
      }
    );
  }

}