import 'package:flutter/material.dart';
import 'package:saw/utils/functions.dart';
import 'package:saw/utils/simple_colors.dart';

class AdditionalResource extends StatelessWidget {
  const AdditionalResource({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          highlightColor: Colors.transparent, splashColor: Colors.transparent),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: SimpleColors.background,
          elevation: 0.6,
          shadowColor: SimpleColors.hint,
          leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back,
              color: SimpleColors.text,
            ),
          ),
          title: Text(
            "Additional Resource",
            style: TextStyle(color: SimpleColors.text),
          ),
        ),
        body: Container(
          color: SimpleColors.background,
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(top: 0),
              child: PhysicalModel(
                color: Colors.transparent,
                elevation: 0.4,
                shadowColor: SimpleColors.hint,
                child: Container(
                  alignment: Alignment.centerLeft,
                  height: 50,
                  color: SimpleColors.background,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Text(
                      "Version 1.0.4",
                      style: TextStyle(color: SimpleColors.text, fontSize: 13),
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                launchGivenUrl(
                    host: 'www.github.com',
                    path: 'paanTom/SAW/blob/main/Privacy-Policy.md/');
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 0),
                child: Container(
                  alignment: Alignment.centerLeft,
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Text(
                      "Privacy Policy",
                      style: TextStyle(
                          color: SimpleColors.text,
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                launchGivenUrl(
                    host: 'www.github.com',
                    path: '/paanTom/SAW/blob/main/Terms-of-Service.md/');
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 0),
                child: Container(
                  alignment: Alignment.centerLeft,
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Text(
                      "Terms of Service",
                      style: TextStyle(
                          color: SimpleColors.text,
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                    ),
                  ),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
