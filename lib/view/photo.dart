import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fader/flutter_fader.dart';
import 'package:get/get.dart';
import 'package:saw/controller/photo_controller.dart';
import 'package:saw/utils/colors.dart';
import 'package:saw/utils/functions.dart';
import 'package:screenshot/screenshot.dart';

class Photo extends StatefulWidget {
  final Map<dynamic, dynamic> source;
  const Photo({Key? key, required this.source}) : super(key: key);

  @override
  State<Photo> createState() => _PhotoState();
}

class _PhotoState extends State<Photo> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  final PhotoController photoController = Get.put(PhotoController());
  final ScreenshotController screenshotController = ScreenshotController();
  final FaderController faderController = FaderController();
  String code(String code) {
    //function to convert to hex-code to int
    return '0xff' + code.substring(1);
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
    Future.delayed(const Duration(milliseconds: 400), () {
      animationController.forward();
    });
  }

  @override
  void dispose() {
    super.dispose();
    photoController.isInPreviewMode = false;
    photoController.isSettingWallpaper = false;

    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Container(
        color: background,
        child: Stack(children: [
          GetBuilder<PhotoController>(
              init: PhotoController(),
              builder: (value) {
                return InkWell(
                  onTap: () {
                    photoController.changeIsInPreviewMode =
                        !photoController.isInPreviewMode;
                    if (photoController.isInPreviewMode) {
                      animationController.reverse();
                      faderController.fadeOut();
                    } else {
                      animationController.forward();
                      faderController.fadeIn();
                    }
                  },
                  child: Container(
                    color: Color(int.parse(code(widget.source['avg_color']))),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Screenshot(
                      controller: screenshotController,
                      child: InteractiveViewer(
                        alignPanAxis: true,
                        constrained: true,
                        panEnabled:
                            !photoController.isSettingWallpaper ? true : false,
                        scaleEnabled:
                            !photoController.isSettingWallpaper ? true : false,
                        onInteractionStart: !photoController.isSettingWallpaper
                            ? (value) {
                                animationController.reverse();
                                photoController.changeIsInPreviewMode = true;
                              }
                            : null,
                        onInteractionEnd: !photoController.isSettingWallpaper
                            ? (value) {
                                animationController.forward();
                                faderController.fadeIn();
                                photoController.changeIsInPreviewMode = false;
                              }
                            : null,
                        minScale: 1,
                        maxScale: 1.5,
                        child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: widget.source['src']['portrait'],
                            fadeInDuration: const Duration(milliseconds: 300)),
                      ),
                    ),
                  ),
                );
              }),
          SafeArea(
            child: Fader(
              controller: faderController,
              duration: const Duration(milliseconds: 300),
              child: SizedBox(
                height: 50,
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Opacity(
                      opacity: .25,
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.black,
                      ),
                    ),
                    Row(children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: InkWell(
                          onTap: () => Navigator.pop(context),
                          child: const SizedBox(
                            height: 36,
                            width: 36,
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Text(
                            widget.source['alt'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: SizedBox(
                            height: 36,
                            width: 36,
                          ))
                    ]),
                  ],
                ),
              ),
            ),
          ),
          GetBuilder<PhotoController>(
              init: PhotoController(),
              builder: (value) {
                return Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: SlideTransition(
                    position: Tween<Offset>(
                            begin: const Offset(0, 1), end: const Offset(0, 0))
                        .animate(animationController),
                    child: InkWell(
                      onTap: () async {
                        await setAsWallpaper(context,
                            fileName: widget.source['alt'],
                            controller: screenshotController);
                        photoController.changeIsSettingWallpaper = false;
                      },
                      child: Opacity(
                        opacity: .93,
                        child: Container(
                          alignment: Alignment.center,
                          height: 45,
                          child: Stack(
                            children: [
                              Visibility(
                                visible: photoController.isSettingWallpaper
                                    ? true
                                    : false,
                                child: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                              Visibility(
                                visible: !photoController.isSettingWallpaper
                                    ? true
                                    : false,
                                child: const Text("Set As Wallpaper",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.7,
                                        color: white)),
                              )
                            ],
                          ),
                          color: black,
                        ),
                      ),
                    ),
                  ),
                );
              })
        ]),
      ),
    );
  }
}
