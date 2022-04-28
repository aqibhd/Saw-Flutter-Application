import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saw/controller/home_controller.dart';
import 'package:saw/utils/colors.dart';
import 'package:http/http.dart' as http;
import 'package:saw/widgets/thumbnail.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _pageNo = 1;

  HomeController homeController = Get.put(HomeController());
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
    return Scaffold(
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) =>
            [
          const SliverAppBar(
            backgroundColor: background,
            floating: true,
            snap: true,
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 16),
                child: Icon(
                  Icons.search,
                  color: white,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 16),
                child: Icon(
                  Icons.more_horiz_rounded,
                  color: white,
                ),
              ),
            ],
          ),
        ],
        body: Container(
          color: background,
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
                                      color: white,
                                      height:
                                          MediaQuery.of(context).size.height,
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
                                  return Thumbnail(
                                      url: homeController.photos[index]['src']
                                          ['tiny'],
                                      avgColor: homeController.photos[index]
                                          ['avg_color']);
                                }, childCount: homeController.photos.length),
                              ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return !homeController.initLoading
                                  ? Container(
                                      height: 60,
                                      alignment: Alignment.center,
                                      child: const SizedBox(
                                          height: 16,
                                          width: 16,
                                          child: CircularProgressIndicator(
                                            color: Color(0xff353535),
                                            strokeWidth: 1,
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
  }
}
