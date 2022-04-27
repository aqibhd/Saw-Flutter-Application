import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saw/controller/home_controller.dart';
import 'package:saw/utils/colors.dart';
import 'package:http/http.dart' as http;
import 'package:saw/widgets/thumnail.dart';

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

  void getPhotos() async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        floatHeaderSlivers: true,
        body: GetBuilder<HomeController>(
            init: HomeController(),
            builder: (value) {
              return Container(
                color: background,
                child: homeController.initLoading
                    ? Container(
                        color: white,
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(0),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 2,
                                mainAxisSpacing: 2,
                                childAspectRatio: 2 / 3),
                        itemCount: homeController.photos!.length,
                        itemBuilder: (context, index) {
                          return Thumbnail(
                              url: homeController.photos![index]['src']['tiny'],
                              avgColor: homeController.photos![index]
                                  ['avg_color']);
                        }),
              );
            }),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) =>
            [
          const SliverAppBar(
            backgroundColor: background,
            floating: true,
            snap: true,
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.search,
                  color: white,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.more_horiz_rounded,
                  color: white,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
