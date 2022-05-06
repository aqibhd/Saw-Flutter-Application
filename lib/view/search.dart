import 'dart:convert';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:saw/controller/search_controller.dart';
import 'package:saw/utils/functions.dart';
import 'package:saw/utils/simple_colors.dart';
import 'package:saw/view/photo.dart';
import 'package:saw/widgets/thumbnail.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  int? _pageNo;
  String? _query;
  final String baseUrl = 'https://api.pexels.com/v1/search?';
  final TextEditingController textEditingController = TextEditingController();
  late ScrollController _scrollController;
  final SearchController searchController = Get.put(SearchController());

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    searchController.reset();
    textEditingController.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          splashColor: Colors.transparent, highlightColor: Colors.transparent),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.light,
          ),
          backgroundColor: SimpleColors.background,
          title: TextField(
            style: TextStyle(color: SimpleColors.text),
            decoration: const InputDecoration(
                hintText: "Search photo...",
                hintStyle: TextStyle(color: Color(0xffBABABA))),
            onSubmitted: (value) async {
              _query = value;
              searchPhotos();
            },
            controller: textEditingController,
          ),
        ),
        body: GetBuilder<SearchController>(
            init: SearchController(),
            builder: (_) {
              return Container(
                color: SimpleColors.background,
                child: NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (notification.metrics.pixels ==
                              notification.metrics.maxScrollExtent &&
                          !searchController.isScrollAtEnd) {
                        searchController.updateIsScrollAtEndValue = true;

                        if (searchController.isEmptyList ||
                            !searchController.isLoading) {
                          searchController.updateIsScrollAtEndValue = false;
                          return true;
                        }

                        getMorePhotos();
                      }
                      return true;
                    },
                    child: RefreshIndicator(
                      color: Colors.black,
                      displacement: 10,
                      onRefresh: () async {
                        await getPhotos();
                      },
                      child: CustomScrollView(
                        physics: (searchController.isGettingPhotos ||
                                searchController.photos.isEmpty)
                            ? const NeverScrollableScrollPhysics()
                            : const AlwaysScrollableScrollPhysics(),
                        controller: _scrollController,
                        slivers: [
                          (searchController.isGettingPhotos ||
                                  searchController.photos.isEmpty)
                              ? SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, int index) {
                                      return Container(
                                        color: SimpleColors.background,
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
                                    return OpenContainer(
                                      openColor: Color(int.parse(code(
                                          searchController.photos[index]
                                              ['avg_color']))),
                                      closedColor: Color(int.parse(code(
                                          searchController.photos[index]
                                              ['avg_color']))),
                                      middleColor: Color(int.parse(code(
                                          searchController.photos[index]
                                              ['avg_color']))),
                                      closedShape: const RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.all(Radius.zero)),
                                      transitionType:
                                          ContainerTransitionType.fadeThrough,
                                      closedBuilder: (context, openContainer) {
                                        return InkWell(
                                          onTap: () {
                                            openContainer();
                                          },
                                          child: Thumbnail(
                                              url: searchController
                                                  .photos[index]['src']['tiny'],
                                              avgColor: searchController
                                                  .photos[index]['avg_color']),
                                        );
                                      },
                                      openBuilder: (context, openContainer) {
                                        return Photo(
                                            source:
                                                searchController.photos[index]);
                                      },
                                    );
                                  },
                                      childCount:
                                          searchController.photos.length),
                                ),
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                return searchController.isEmptyList
                                    ? Container(
                                        height: 60,
                                        alignment: Alignment.center,
                                        child: const Text(
                                          "You’ve reached the end of the list 😦",
                                          style: TextStyle(
                                              color: Color(0xffBABABA),
                                              fontSize: 13),
                                        ),
                                      )
                                    : searchController.isLoading
                                        ? Container(
                                            height: 60,
                                            alignment: Alignment.center,
                                            child: const SizedBox(
                                                height: 16,
                                                width: 16,
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Color(0xffBABABA),
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
                    )),
              );
            }),
      ),
    );
  }

  void searchPhotos() {
    searchController.updateGettingPhotos = true;
    getPhotos();
  }

  void scrollToTop() {
    _scrollController.animateTo(0,
        duration: const Duration(microseconds: 10), curve: Curves.ease);
  }

  Future<void> getPhotos() async {
    scrollToTop();
    _pageNo = 1;
    searchController.changeIsEmptyList = false;
    searchController.updateIsLoadingValue = false;
    await http.get(
        Uri.parse('${baseUrl}query=$_query&per_page=80&page=$_pageNo'),
        headers: {
          'Authorization':
              '563492ad6f917000010000013828121f1c0e40caa2a2b92e8da6a38b'
        }).then((value) {
      Map result = jsonDecode(value.body);
      if (result['total_results'] == 0) {}
      searchController.updatePhotoList = result['photos'];
    });
    searchController.updateGettingPhotos = false;
    Future.delayed(const Duration(seconds: 1), () {
      if (_scrollController.position.maxScrollExtent > 0) {
        searchController.updateIsLoadingValue = true;
      }
    });
  }

  Future<void> getMorePhotos() async {
    _pageNo = _pageNo! + 1;
    await http.get(
        Uri.parse('${baseUrl}query=$_query&per_page=80&page=$_pageNo'),
        headers: {
          'Authorization':
              '563492ad6f9170000100000168782372e52a4568b8e065c6b69373cd'
        }).then((value) {
      Map result = jsonDecode(value.body);
      searchController.addMorePhotosList = result['photos'];
    });
  }
}
