import 'dart:convert';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:saw/controller/home_controller.dart';
import 'package:saw/controller/theme_controller.dart';
import 'package:http/http.dart' as http;
import 'package:saw/utils/functions.dart';
import 'package:saw/utils/simple_colors.dart';
import 'package:saw/view/photo.dart';
import 'package:saw/view/search.dart';
import 'package:saw/widgets/thumbnail.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _pageNo = 1;

  HomeController homeController = Get.put(HomeController());
  final ThemeController themeController = Get.find<ThemeController>();
  @override
  void initState() {
    super.initState();

    getPhotos();
  }

  Future<void> getPhotos() async {
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
    _pageNo = _pageNo + 1;
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

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
        init: ThemeController(),
        builder: (_) {
          return Scaffold(
            body: NestedScrollView(
              floatHeaderSlivers: true,
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) => [
                Theme(
                  data: ThemeData(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent),
                  child: SliverAppBar(
                    backgroundColor: SimpleColors.background,
                    floating: true,
                    snap: true,
                    systemOverlayStyle: const SystemUiOverlayStyle(
                      statusBarIconBrightness: Brightness.light,
                    ),
                    actions: [
                      InkWell(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Search())),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Icon(
                            Icons.search,
                            color: SimpleColors.icon,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              builder: (context) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 30, right: 30, bottom: 15),
                                  child: GetBuilder<ThemeController>(
                                      init: ThemeController(),
                                      builder: (_) {
                                        return Container(
                                          decoration: BoxDecoration(
                                              color:
                                                  SimpleColors.modalBackground,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(20))),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 30),
                                            child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(vertical: 8),
                                                    child: SizedBox(
                                                      height: 40,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 16),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Row(children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            10),
                                                                child:
                                                                    SvgPicture
                                                                        .asset(
                                                                  'assets/icons/theme_icon.svg',
                                                                  color:
                                                                      SimpleColors
                                                                          .text,
                                                                ),
                                                              ),
                                                              Text(
                                                                "Dark Mode",
                                                                style:
                                                                    TextStyle(
                                                                  color:
                                                                      SimpleColors
                                                                          .text,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                ),
                                                              )
                                                            ]),
                                                            Switch(
                                                                value: themeController
                                                                    .isDarkMode,
                                                                onChanged:
                                                                    (value) {
                                                                  themeController
                                                                          .changeIsDarkMode =
                                                                      value;
                                                                })
                                                          ],
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
                                                          child: Row(children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      right:
                                                                          10),
                                                              child: SvgPicture
                                                                  .asset(
                                                                'assets/icons/bug_icon.svg',
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                            ),
                                                            const Text(
                                                              "Report Bugs",
                                                              style: TextStyle(
                                                                color:
                                                                    Colors.red,
                                                                fontSize: 14,
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
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(vertical: 8),
                                                    child: SizedBox(
                                                      height: 40,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 16),
                                                        child: Row(children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    right: 10),
                                                            child: SvgPicture
                                                                .asset(
                                                              'assets/icons/additional_icon.svg',
                                                              color:
                                                                  Colors.blue,
                                                            ),
                                                          ),
                                                          Text(
                                                            "Additional Resource",
                                                            style: TextStyle(
                                                              color:
                                                                  SimpleColors
                                                                      .text,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            ),
                                                          )
                                                        ]),
                                                      ),
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                      launchInstagram();
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
                                                          child: Row(children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      right:
                                                                          10),
                                                              child:
                                                                  Image.asset(
                                                                'assets/icons/Social.png',
                                                              ),
                                                            ),
                                                            Text(
                                                              "Follow Developer",
                                                              style: TextStyle(
                                                                color:
                                                                    SimpleColors
                                                                        .text,
                                                                fontSize: 14,
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
                          padding: const EdgeInsets.only(right: 16),
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

                      // enable();
                    } else {
                      //disable();

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
                            _pageNo = 1;
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
                                          openColor: Color(int.parse(code(
                                              homeController.photos[index]
                                                  ['avg_color']))),
                                          closedColor: Color(int.parse(code(
                                              homeController.photos[index]
                                                  ['avg_color']))),
                                          middleColor: Color(int.parse(code(
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
}
