import 'dart:convert';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:saw/controller/home_controller.dart';
import 'package:saw/controller/theme_controller.dart';
import 'package:http/http.dart' as http;
import 'package:saw/utils/functions.dart';
import 'package:saw/utils/simple_colors.dart';
import 'package:saw/view/additional_resource.dart';
import 'package:saw/view/photo.dart';
import 'package:saw/view/search.dart';
import 'package:saw/widgets/thumbnail.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int? _pageNo;

  HomeController homeController = Get.put(HomeController());
  final ThemeController themeController = Get.find<ThemeController>();
  final theme = GetStorage();
  @override
  void initState() {
    super.initState();
    getPhotos();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
        init: ThemeController(),
        builder: (_) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            body: NestedScrollView(
              floatHeaderSlivers: true,
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) => [
                Theme(
                  data: ThemeData(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent),
                  child: SliverAppBar(
                    elevation: 0,
                    backgroundColor: SimpleColors.background,
                    floating: true,
                    snap: true,
                    systemOverlayStyle: SystemUiOverlayStyle(
                      statusBarColor: Colors.transparent,
                      statusBarIconBrightness: themeController.isDarkMode
                          ? Brightness.light
                          : themeController.isPhotoOpened
                              ? Brightness.light
                              : Brightness.dark,
                    ),
                    actions: [
                      InkWell(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Search())),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: SvgPicture.asset(
                            'assets/icons/search_icon.svg',
                            color: SimpleColors.icon,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                              elevation: 0,
                              isScrollControlled: true,
                              context: context,
                              backgroundColor: Colors.transparent,
                              builder: (context) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 0, right: 0, bottom: 0),
                                  child: GetBuilder<ThemeController>(
                                      init: ThemeController(),
                                      builder: (_) {
                                        return GlassmorphicContainer(
                                          alignment: Alignment.center,
                                          height: MediaQuery.of(context)
                                              .size
                                              .height,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          blur: 6,
                                          border: 0,
                                          borderRadius: 0,
                                          linearGradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                Colors.black.withOpacity(0.6),
                                                Colors.black.withOpacity(0.6),
                                              ],
                                              stops: const [
                                                0.1,
                                                1,
                                              ]),
                                          borderGradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              Colors.black.withOpacity(0.0),
                                              Colors.black.withOpacity(0.0),
                                            ],
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 30),
                                            child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      themeController
                                                              .updateIsDarkModeValue =
                                                          !themeController
                                                              .isDarkMode;
                                                      theme.write(
                                                          'isDarkMode',
                                                          themeController
                                                              .isDarkMode);
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 8),
                                                      child: SizedBox(
                                                        height: 40,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      16),
                                                          child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      right:
                                                                          10),
                                                                  child:
                                                                      SvgPicture
                                                                          .asset(
                                                                    !themeController
                                                                            .isDarkMode
                                                                        ? 'assets/icons/dark_mode_icon.svg'
                                                                        : 'assets/icons/light_mode_icon.svg',
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  !themeController
                                                                          .isDarkMode
                                                                      ? "Dark Mode"
                                                                      : "Light Mode",
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                  ),
                                                                )
                                                              ]),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                      reportBugs();
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 8),
                                                      child: SizedBox(
                                                        height: 40,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      16),
                                                          child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      right:
                                                                          10),
                                                                  child:
                                                                      SvgPicture
                                                                          .asset(
                                                                    'assets/icons/bug_icon.svg',
                                                                    color: Colors
                                                                        .red,
                                                                  ),
                                                                ),
                                                                const Text(
                                                                  "Report Bugs",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .red,
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                  ),
                                                                )
                                                              ]),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const AdditionalResource()));
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 8),
                                                      child: SizedBox(
                                                        height: 40,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      16),
                                                          child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      right:
                                                                          10),
                                                                  child:
                                                                      SvgPicture
                                                                          .asset(
                                                                    'assets/icons/additional_icon.svg',
                                                                    color: Colors
                                                                        .blue,
                                                                  ),
                                                                ),
                                                                const Text(
                                                                  "Additional Resource",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                  ),
                                                                )
                                                              ]),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                      launchGivenUrl(
                                                          path: '/aquib.hamid/',
                                                          host:
                                                              'www.instagram.com');
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 8),
                                                      child: SizedBox(
                                                        height: 40,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      16),
                                                          child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      right:
                                                                          10),
                                                                  child: Image
                                                                      .asset(
                                                                    'assets/icons/Social.png',
                                                                  ),
                                                                ),
                                                                const Text(
                                                                  "Follow Developer",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                  ),
                                                                )
                                                              ]),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ]),
                                          ),
                                        );
                                      }),
                                );
                              });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8, right: 16),
                          child: SvgPicture.asset(
                            'assets/icons/more_icon.svg',
                            color: SimpleColors.icon,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              body: Container(
                color: SimpleColors.background,
                child: NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification.metrics.pixels ==
                            notification.metrics.maxScrollExtent &&
                        !homeController.isAtEnd) {
                      homeController.updateIsAtEnd = true;
                      getMorePhotos();
                    }
                    return true;
                  },
                  child: GetBuilder<HomeController>(
                      init: HomeController(),
                      builder: (value) {
                        return RefreshIndicator(
                          color: Colors.black,
                          displacement: 10,
                          onRefresh: () async {
                            await getPhotos();
                          },
                          child: CustomScrollView(
                            physics: homeController.initLoading
                                ? const NeverScrollableScrollPhysics()
                                : null,
                            slivers: [
                              homeController.initLoading
                                  ? SliverList(
                                      delegate: SliverChildBuilderDelegate(
                                        (BuildContext context, int index) {
                                          return Container(
                                            color: SimpleColors.background,
                                            height: MediaQuery.of(context)
                                                .size
                                                .height,
                                          );
                                        },
                                        childCount: 1,
                                      ),
                                    )
                                  : SliverGrid(
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 3,
                                              crossAxisSpacing: 2,
                                              mainAxisSpacing: 2,
                                              childAspectRatio: 2 / 3),
                                      delegate: SliverChildBuilderDelegate(
                                          (context, index) {
                                        return OpenContainer(
                                          openColor: Color(int.parse(
                                              convertHexToInt(
                                                  homeController.photos[index]
                                                      ['avg_color']))),
                                          closedColor: Color(int.parse(
                                              convertHexToInt(
                                                  homeController.photos[index]
                                                      ['avg_color']))),
                                          middleColor: Color(int.parse(
                                              convertHexToInt(
                                                  homeController.photos[index]
                                                      ['avg_color']))),
                                          closedShape:
                                              const RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.zero)),
                                          transitionType:
                                              ContainerTransitionType
                                                  .fadeThrough,
                                          closedBuilder:
                                              (context, openContainer) {
                                            return InkWell(
                                              onTap: () {
                                                openContainer();
                                                themeController
                                                        .updateIsPhotoOpenedValue =
                                                    true;
                                                setSystemUIOverlayStyle();
                                              },
                                              child: Thumbnail(
                                                  url: homeController
                                                          .photos[index]['src']
                                                      ['tiny'],
                                                  avgColor: homeController
                                                          .photos[index]
                                                      ['avg_color']),
                                            );
                                          },
                                          openBuilder:
                                              (context, openContainer) {
                                            return Photo(
                                                source: homeController
                                                    .photos[index]);
                                          },
                                          onClosed: (_) {
                                            themeController
                                                    .updateIsPhotoOpenedValue =
                                                false;
                                            setSystemUIOverlayStyle();
                                          },
                                        );
                                      },
                                          childCount:
                                              homeController.photos.length),
                                    ),
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                    return !homeController.initLoading
                                        ? Container(
                                            height: 60,
                                            alignment: Alignment.center,
                                            child: SizedBox(
                                                height: 16,
                                                width: 16,
                                                child:
                                                    CircularProgressIndicator(
                                                  color: SimpleColors.icon,
                                                  strokeWidth: 1.5,
                                                )),
                                          )
                                        : const SizedBox();
                                  },
                                  childCount: 1,
                                ),
                              )
                            ],
                          ),
                        );
                      }),
                ),
              ),
            ),
          );
        });
  }

  Future<void> getPhotos() async {
    _pageNo = 1;
    await http.get(
        Uri.parse(
            'https://api.pexels.com/v1/curated?per_page=80&page=$_pageNo'),
        headers: {
          'Authorization':
              '563492ad6f917000010000013828121f1c0e40caa2a2b92e8da6a38b'
        }).then((value) {
      Map result = jsonDecode(value.body);
      homeController.updatePhotoList = result['photos'];

      homeController.updateInitLoading = false;
    });
  }

  void getMorePhotos() async {
    _pageNo = _pageNo! + 1;
    await http.get(
        Uri.parse(
            'https://api.pexels.com/v1/curated?per_page=80&page=$_pageNo'),
        headers: {
          'Authorization':
              '563492ad6f9170000100000168782372e52a4568b8e065c6b69373cd'
        }).then((value) {
      Map result = jsonDecode(value.body);
      homeController.addMorePhotosList = result['photos'];
    });
  }
}
