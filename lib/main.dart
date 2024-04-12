import 'dart:io';
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:share_plus/share_plus.dart';
import 'package:vs_story_designer/vs_story_designer.dart';
import 'dart:ui' as ui;

void main() {
  runApp(const My_story_App());
}

class My_story_App extends StatelessWidget {
  const My_story_App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Story Instagram',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: const story_pm(),
    );
  }
}

class story_pm extends StatefulWidget {
  const story_pm({Key? key}) : super(key: key);

  @override
  State<story_pm> createState() => _story_pmState();
}

class _story_pmState extends State<story_pm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: RepaintBoundary(
          key: _globalKey,
          child: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                Center(
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(5),
                    child: const Text(
                      'Social Media',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(5),
                    child: const Text(
                      'MADE IN INDIA',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(5),
                    child: ElevatedButton(
                      onPressed: () async {
                        String? mediaPath = await _prepareImage();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VSStoryDesigner(
                                      centerText: "LIVE Start Story",
                                      themeType: ThemeType.light,
                                      galleryThumbnailQuality: 250,
                                      onDone: (uri) {
                                        debugPrint(uri);
                                        Share.shareFiles([uri]);
                                      },
                                      mediaPath: mediaPath,
                                    )));
                      },
                      child: const Text('Create Story',
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.black,
                              fontWeight: FontWeight.w500)),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal.shade800,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                    ),
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
        ));
  }

  final GlobalKey _globalKey = GlobalKey();

  Future<String?> _prepareImage() async {
    ByteData? byteData;

    try {
      RenderRepaintBoundary? boundary = _globalKey.currentContext
          ?.findRenderObject() as RenderRepaintBoundary?;

      ui.Image? image = await boundary?.toImage(pixelRatio: 4);
      byteData = await image?.toByteData(format: ui.ImageByteFormat.png);
      Uint8List bytes = byteData!.buffer.asUint8List();

      final directory = (await getTemporaryDirectory()).path;
      String imgPath = '$directory/${Random().nextInt(999999)}.jpg';
      File imgFile = File(imgPath);
      await imgFile.writeAsBytes(bytes);

      return imgFile.path;
    } catch (e) {
      return null;
    }
  }
}
