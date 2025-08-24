import 'package:flutter/material.dart';

import '../../../common/apihelper/firebsaeuploadhelper.dart';
import '../../../common/app_colors.dart';
import '../../../common/customwidget/text_helper.dart';
import '../../../common/ui_helpers.dart';
import '../../../widgets/common/addproject/addproject.dart';
import '../../users/user/about.dart';

class HeaderContent1 extends StatelessWidget {
  String title;
  HeaderContent1({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1200) {
          return DesktopHeaderContent1(
            title: title,
          );
        } else if (constraints.maxWidth > 800 && constraints.maxWidth < 1200) {
          return DesktopHeaderContent1(
            title: title,
          );
        } else {
          return MobileHeaderContent1(
            title: title,
          );
        }
      },
    );
  }
}

class DesktopHeaderContent1 extends StatelessWidget {
  String title;
  DesktopHeaderContent1({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 55.0),
                child: Container(
                  height: MediaQuery.of(context).size.height - 300,
                  width: _width / 2.2,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "We Are",
                          style: TextStyle(
                              fontFamily: "Sofia",
                              color: Theme.of(context).primaryColorDark,
                              fontWeight: FontWeight.w500,
                              fontSize: 19.0),
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          "Freelance Mela",
                          style: TextStyle(
                              fontFamily: "Sofia",
                              color: Theme.of(context).primaryColorDark,
                              fontWeight: FontWeight.w900,
                              fontSize: 42.0),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          child: Text(
                            "Scale your professional workforce\nwith freelancers",
                            style: TextStyle(
                                fontSize: 18.0,
                                color: Theme.of(context).primaryColor,
                                fontFamily: "Sofia",
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        InkWell(
                          onTap: () {},
                          child: Container(
                            height: 40.0,
                            width: 155.0,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Theme.of(context).primaryColorDark,
                                    Theme.of(context).primaryColor
                                  ],
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0))),
                            child: Center(
                              child: InkWell(
                                onTap: () {
                                  if (title == "user") {
                                    showCoolAboutDialog(context);
                                  } else {
                                    addproject(context, {});
                                  }
                                },
                                child: Text(
                                  "GET STARTED",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Sofia",
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: MediaQuery.of(context).size.height - 300,
                  width: _width / 2.2,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          // image: AssetImage("assets/image/imageHeader.jpg"),
                          image: AssetImage(
                            "assets/pro.jpg",
                          ),
                          fit: BoxFit.contain)),
                ),
              ),
              const SizedBox(width: 10.0)
            ],
          ),
        ],
      ),
    );
  }
}

class MobileHeaderContent1 extends StatelessWidget {
  String title;
  MobileHeaderContent1({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: _width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          height: 400.0,
                          width: _width,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      // AssetImage("assets/image/imageHeader.jpg"),
                                      AssetImage(
                                    "assets/pro.jpg",
                                  ),
                                  fit: BoxFit.contain)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, top: 95.0, right: 10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "We Are",
                              style: TextStyle(
                                  fontFamily: "Sofia",
                                  color: Theme.of(context).primaryColorDark,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 19.0),
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              "Freelance Mela",
                              style: TextStyle(
                                  fontFamily: "Sofia",
                                  color: Theme.of(context).primaryColorDark,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 42.0),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.0),
                              child: Text(
                                "Scale your professional workforce\nwith freelancers",
                                style: TextStyle(
                                    fontSize: 18.0,
                                    color: Theme.of(context).primaryColor,
                                    fontFamily: "Sofia",
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            const SizedBox(
                              height: 30.0,
                            ),
                            InkWell(
                              onTap: () {},
                              child: Container(
                                height: 40.0,
                                width: 155.0,
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Theme.of(context).primaryColorDark,
                                        Theme.of(context).primaryColor
                                      ],
                                    ),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20.0))),
                                child: Center(
                                  child: InkWell(
                                    onTap: () {
                                      if (title == "user") {
                                        showCoolAboutDialog(context);
                                      } else {
                                        addproject(context, {});
                                      }
                                    },
                                    child: Text(
                                      "GET IN TOUCH",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "Sofia",
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> addproject(BuildContext context, Map data) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: Addproject(
          data: data,
        ),
      );
    },
  );
}
