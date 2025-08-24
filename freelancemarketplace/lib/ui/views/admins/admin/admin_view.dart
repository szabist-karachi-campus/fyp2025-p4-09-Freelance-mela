import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:freelancemarketplace/ui/common/customwidget/button_helper.dart';
import 'package:stacked/stacked.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../common/apihelper/apihelper.dart';
import '../../../common/app_colors.dart';
import '../../../common/customwidget/snakbar_helper.dart';
import '../../../common/customwidget/text_helper.dart';
import '../../../common/ui_helpers.dart';
import '../../../widgets/common/users/users.dart';
import 'admin_viewmodel.dart';

class AdminView extends StackedView<AdminViewModel> {
  const AdminView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    AdminViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.white,
          title: Row(
            children: [
              Image.asset(
                "assets/logo.jpg",
                width: 100,
                height: 100,
              ),
              horizontalSpaceMedium,
              text_helper(data: "Admin Portal", fontWeight: FontWeight.bold),
            ],
          ),
          actions: [
            horizontalSpaceTiny,
            btn(context, viewModel, "Agreement",
                () => agreement(context, viewModel)),
            horizontalSpaceTiny,
            btn(context, viewModel, "Chat", () => viewModel.allchat()),
            horizontalSpaceTiny,
            btn(context, viewModel, "Complains",
                () => complains(context, viewModel)),
            horizontalSpaceTiny,
            btn(context, viewModel, "All Users",
                () => user(context, viewModel, true)),
            horizontalSpaceTiny,
            btn(context, viewModel, "Users",
                () => user(context, viewModel, false)),
            horizontalSpaceTiny,
            btn(context, viewModel, "Logout", () => viewModel.logout()),
          ],
        ),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(15),
          child: ListView(
            children: [
              FutureBuilder(
                future: ApiHelper.allproject(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.toString() == '[]') {
                      return Center(
                        child: text_helper(data: "No Data"),
                      );
                    } else {
                      final List projectsJson = snapshot.data;
                      final projects = projectsJson
                          .map((j) =>
                              Project.fromJson(j as Map<String, dynamic>))
                          .toList();
                      return Wrap(
                        children: [
                          SizedBox(
                            width: screenWidthCustom(context, 0.3),
                            child: SfCartesianChart(
                              title: const ChartTitle(text: 'Project Prices'),
                              primaryXAxis: const CategoryAxis(),
                              series: <CartesianSeries<Project, String>>[
                                // ← CartesianSeries, not ChartSeries
                                ColumnSeries<Project, String>(
                                  dataSource: projects,
                                  xValueMapper: (proj, _) => proj.title,
                                  yValueMapper: (proj, _) => proj.price,
                                  name: 'Price',
                                  dataLabelSettings:
                                      const DataLabelSettings(isVisible: true),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: screenWidthCustom(context, 0.3),
                            child: SfCartesianChart(
                              title: const ChartTitle(text: 'Price Trend'),
                              primaryXAxis: const NumericAxis(
                                  title: AxisTitle(text: 'Project Index')),
                              series: [
                                // Dart sees ColumnSeries/LineSeries → infers CartesianSeries
                                LineSeries<Project, int>(
                                  dataSource: projects,
                                  xValueMapper: (_, idx) => idx,
                                  yValueMapper: (proj, _) => proj.price,
                                  markerSettings:
                                      const MarkerSettings(isVisible: true),
                                  dataLabelSettings:
                                      const DataLabelSettings(isVisible: true),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: screenWidthCustom(context, 0.3),
                            child: SfCartesianChart(
                              title: const ChartTitle(text: 'Price Scatter'),
                              primaryXAxis: const NumericAxis(
                                  title: AxisTitle(text: 'Index')),
                              primaryYAxis: const NumericAxis(
                                  title: AxisTitle(text: 'Price')),
                              series: <CartesianSeries<Project, int>>[
                                // ← CartesianSeries
                                ScatterSeries<Project, int>(
                                  dataSource: projects,
                                  xValueMapper: (_, idx) => idx,
                                  yValueMapper: (proj, _) => proj.price,
                                  markerSettings: const MarkerSettings(
                                      width: 10, height: 10),
                                  dataLabelSettings:
                                      const DataLabelSettings(isVisible: true),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: screenWidthCustom(context, 0.3),
                            child: SfCircularChart(
                              title: const ChartTitle(text: 'Project Approval'),
                              series: <CircularSeries>[
                                PieSeries<StatusData, String>(
                                  dataSource: [
                                    StatusData('Approve',
                                        projects.where((p) => p.status).length),
                                    StatusData(
                                        'Waiting',
                                        projects
                                            .where((p) => !p.status)
                                            .length),
                                  ],
                                  xValueMapper: (data, _) => data.status,
                                  yValueMapper: (data, _) => data.count,
                                  dataLabelSettings:
                                      const DataLabelSettings(isVisible: true),
                                )
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                  } else if (snapshot.hasError) {
                    return const Icon(
                      Icons.error,
                    );
                  } else {
                    return displaysimpleprogress(context);
                  }
                },
              ),
              FutureBuilder(
                future: ApiHelper.allbooking(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.toString() == '[]') {
                      return Center(
                        child: text_helper(data: "No Data"),
                      );
                    } else {
                      final bookings = (snapshot.data as List)
                          .map((j) =>
                              Booking.fromJson(j as Map<String, dynamic>))
                          .toList();

                      final trackingData = countByTracking(bookings)
                          .entries
                          .map((e) => ChartData<String>(e.key, e.value))
                          .toList();

                      final partnerData = countByPartner(bookings)
                          .entries
                          .map((e) => ChartData<String>(e.key, e.value))
                          .toList();

                      final dailyData = countPerDay(bookings)
                          .entries
                          .map((e) => ChartData<DateTime>(e.key, e.value))
                          .toList();

                      final days = countPerDay(bookings).keys.toList();
                      final trueCounts = <ChartData<DateTime>>[];
                      final falseCounts = <ChartData<DateTime>>[];

                      for (var day in days) {
                        final onDay = bookings.where((b) =>
                            b.date.year == day.year &&
                            b.date.month == day.month &&
                            b.date.day == day.day);
                        trueCounts.add(ChartData<DateTime>(
                            day, onDay.where((b) => b.status).length));
                        falseCounts.add(ChartData<DateTime>(
                            day, onDay.where((b) => !b.status).length));
                      }

                      return Wrap(
                        children: [
                          SizedBox(
                            width: screenWidthCustom(context, 0.3),
                            child: SfCircularChart(
                              title: const ChartTitle(text: 'Tracking Status'),
                              series: [
                                PieSeries<ChartData, String>(
                                  dataSource: trackingData,
                                  xValueMapper: (d, _) => d.x,
                                  yValueMapper: (d, _) => d.y,
                                  dataLabelSettings:
                                      const DataLabelSettings(isVisible: true),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: screenWidthCustom(context, 0.3),
                            child: SfCartesianChart(
                              title:
                                  const ChartTitle(text: 'Bookings by Partner'),
                              primaryXAxis: const CategoryAxis(),
                              series: <CartesianSeries<ChartData, String>>[
                                ColumnSeries<ChartData, String>(
                                  dataSource: partnerData,
                                  xValueMapper: (d, _) => d.x,
                                  yValueMapper: (d, _) => d.y,
                                  dataLabelSettings:
                                      const DataLabelSettings(isVisible: true),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: screenWidthCustom(context, 0.3),
                            child: SfCartesianChart(
                              title: const ChartTitle(text: 'Daily Bookings'),
                              primaryXAxis: const DateTimeAxis(),
                              series: <CartesianSeries<ChartData, DateTime>>[
                                LineSeries<ChartData, DateTime>(
                                  dataSource: countPerDay(bookings)
                                      .entries
                                      .map((e) => ChartData(e.key, e.value))
                                      .toList(),
                                  xValueMapper: (d, _) => d.x as DateTime,
                                  yValueMapper: (d, _) => d.y,
                                  markerSettings:
                                      const MarkerSettings(isVisible: true),
                                  dataLabelSettings:
                                      const DataLabelSettings(isVisible: true),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: screenWidthCustom(context, 0.3),
                            child: SfCartesianChart(
                              title: const ChartTitle(text: 'Status by Day'),
                              primaryXAxis: const DateTimeAxis(),
                              series: <CartesianSeries<ChartData, DateTime>>[
                                StackedColumnSeries<ChartData, DateTime>(
                                  dataSource: trueCounts,
                                  xValueMapper: (d, _) => d.x as DateTime,
                                  yValueMapper: (d, _) => d.y,
                                  name: 'Success',
                                  dataLabelSettings:
                                      const DataLabelSettings(isVisible: true),
                                ),
                                StackedColumnSeries<ChartData, DateTime>(
                                  dataSource: falseCounts,
                                  xValueMapper: (d, _) => d.x as DateTime,
                                  yValueMapper: (d, _) => d.y,
                                  name: 'Failure',
                                  dataLabelSettings:
                                      const DataLabelSettings(isVisible: true),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: screenWidthCustom(context, 0.3),
                            child: SfCartesianChart(
                              title: const ChartTitle(text: 'Time vs. Status'),
                              primaryXAxis: const DateTimeAxis(),
                              primaryYAxis:
                                  const NumericAxis(minimum: 0, maximum: 1),
                              series: <CartesianSeries<Booking, DateTime>>[
                                ScatterSeries<Booking, DateTime>(
                                  dataSource: bookings,
                                  xValueMapper: (b, _) => b.date,
                                  yValueMapper: (b, _) => b.status ? 1 : 0,
                                  markerSettings:
                                      const MarkerSettings(width: 8, height: 8),
                                  dataLabelSettings:
                                      const DataLabelSettings(isVisible: false),
                                )
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                  } else if (snapshot.hasError) {
                    return const Icon(
                      Icons.error,
                    );
                  } else {
                    return displaysimpleprogress(context);
                  }
                },
              ),
              FutureBuilder(
                future: ApiHelper.allusers(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.toString() == '[]') {
                      return Center(
                        child: text_helper(data: "No Data"),
                      );
                    } else {
                      final raw = snapshot.data as List;
                      final users = raw
                          .map((j) => User.fromJson(j as Map<String, dynamic>))
                          .toList();

                      final catData = countByCategory(users)
                          .entries
                          .map((e) => UChartData<String>(e.key, e.value))
                          .toList();

                      final statData = countByStatus(users)
                          .entries
                          .map((e) => UChartData<String>(e.key, e.value))
                          .toList();

                      final colCatData = catData;

                      final statusCatMap = countStatusWithinCategory(users);
                      final cats = statusCatMap.keys.toList();
                      final activeSeries = <UChartData<String>>[];
                      final inactiveSeries = <UChartData<String>>[];

                      for (var c in cats) {
                        activeSeries.add(
                            UChartData<String>(c, statusCatMap[c]!['Active']!));
                        inactiveSeries.add(UChartData<String>(
                            c, statusCatMap[c]!['Inactive']!));
                      }

                      return Wrap(
                        children: [
                          SizedBox(
                            width: screenWidthCustom(context, 0.3),
                            child: SfCircularChart(
                              title: const ChartTitle(text: 'User Categories'),
                              series: [
                                PieSeries<UChartData<String>, String>(
                                  dataSource: catData, // now matches!
                                  xValueMapper: (d, _) => d.x,
                                  yValueMapper: (d, _) => d.y,
                                  dataLabelSettings:
                                      const DataLabelSettings(isVisible: true),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: screenWidthCustom(context, 0.3),
                            child: SfCircularChart(
                              title: const ChartTitle(text: 'User Status'),
                              series: [
                                PieSeries<UChartData<String>, String>(
                                  dataSource: statData,
                                  xValueMapper: (d, _) => d.x,
                                  yValueMapper: (d, _) => d.y,
                                  dataLabelSettings:
                                      const DataLabelSettings(isVisible: true),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: screenWidthCustom(context, 0.3),
                            child: SfCartesianChart(
                              title:
                                  const ChartTitle(text: 'Count per Category'),
                              primaryXAxis: const CategoryAxis(),
                              series: <CartesianSeries<UChartData<String>,
                                  String>>[
                                ColumnSeries<UChartData<String>, String>(
                                  dataSource: colCatData,
                                  xValueMapper: (d, _) => d.x,
                                  yValueMapper: (d, _) => d.y,
                                  dataLabelSettings:
                                      const DataLabelSettings(isVisible: true),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: screenWidthCustom(context, 0.3),
                            child: SfCartesianChart(
                              title: const ChartTitle(
                                  text: 'Active vs. Inactive by Category'),
                              primaryXAxis: const CategoryAxis(),
                              series: <CartesianSeries<UChartData<String>,
                                  String>>[
                                StackedColumnSeries<UChartData<String>, String>(
                                  dataSource: activeSeries,
                                  xValueMapper: (d, _) => d.x,
                                  yValueMapper: (d, _) => d.y,
                                  name: 'Active',
                                  dataLabelSettings:
                                      const DataLabelSettings(isVisible: true),
                                ),
                                StackedColumnSeries<UChartData<String>, String>(
                                  dataSource: inactiveSeries,
                                  xValueMapper: (d, _) => d.x,
                                  yValueMapper: (d, _) => d.y,
                                  name: 'Inactive',
                                  dataLabelSettings:
                                      const DataLabelSettings(isVisible: true),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                  } else if (snapshot.hasError) {
                    return const Icon(
                      Icons.error,
                    );
                  } else {
                    return displaysimpleprogress(context);
                  }
                },
              ),
              verticalSpaceSmall,
              verticalSpaceSmall,
              text_helper(data: "Approve Projects", fontWeight: FontWeight.bold, size: fontSize20,),
              verticalSpaceSmall,
              FutureBuilder(
                future: ApiHelper.allproject(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.toString() == '[]') {
                      return Center(
                        child: text_helper(data: "No Data"),
                      );
                    } else {
                      return Wrap(
                        children: snapshot.data.map<Widget>((item) {
                          return item['status'] == "false"
                              ? InkWell(
                                  onTap: () => viewModel.projectdetails(item),
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    margin: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: getColorWithOpacity(
                                            Theme.of(context).primaryColorLight,
                                            0.1)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          child: CachedNetworkImage(
                                            imageUrl: item['img'][0],
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              width: screenWidthCustom(
                                                  context, 0.2),
                                              height: screenWidthCustom(
                                                  context, 0.2),
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            placeholder: (context, url) =>
                                                displaysimpleprogress(context),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(
                                              Icons.error,
                                            ),
                                          ),
                                        ),
                                        verticalSpaceSmall,
                                        text_helper(
                                          data: item['title'],
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueAccent,
                                        ),
                                        text_helper(
                                          data: "PKR " + item['price'],
                                          color: Colors.green,
                                          size: fontSize12,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink();
                        }).toList(),
                      );
                    }
                  } else if (snapshot.hasError) {
                    return const Icon(
                      Icons.error,
                    );
                  } else {
                    return displaysimpleprogress(context);
                  }
                },
              ),
            ],
          ),
        )));
  }

  Widget btn(BuildContext context, AdminViewModel viewModel, String title,
      Function funtion) {
    return InkWell(
      onTap: () => funtion(),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color:
                getColorWithOpacity(Theme.of(context).primaryColorLight, 0.2)),
        child: text_helper(
          data: title,
          size: fontSize10,
        ),
      ),
    );
  }

  Future<void> user(
      BuildContext context, AdminViewModel viewModel, user) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Users(
            all: user,
          ),
        );
      },
    );
    viewModel.notifyListeners();
  }

  Future<void> complains(BuildContext context, AdminViewModel viewModel) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            child: FutureBuilder(
          future: ApiHelper.allcomplains(context),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.toString() == '[]') {
                return const SizedBox.shrink();
              } else {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      width: screenWidth(context),
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: getColorWithOpacity(Colors.grey, 0.1)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          FutureBuilder(
                            future:
                                ApiHelper.findone(snapshot.data[index]['uid']),
                            builder: (BuildContext context,
                                AsyncSnapshot snapshot2) {
                              if (snapshot2.hasData) {
                                if (snapshot2.data.toString() == '[]') {
                                  return const SizedBox.shrink();
                                } else {
                                  return Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: CachedNetworkImage(
                                          imageUrl: snapshot2.data["img"],
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            width:
                                                screenWidthCustom(context, 0.1),
                                            height:
                                                screenWidthCustom(context, 0.1),
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          placeholder: (context, url) =>
                                              displaysimpleprogress(context),
                                          errorWidget: (context, url, error) =>
                                              const Icon(
                                            Icons.error,
                                          ),
                                        ),
                                      ),
                                      horizontalSpaceMedium,
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          text_helper(
                                            data: snapshot2.data["name"],
                                            fontWeight: FontWeight.bold,
                                            size: fontSize12,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          text_helper(
                                            data: snapshot2.data["email"],
                                            size: fontSize10,
                                            textAlign: TextAlign.start,
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                }
                              } else if (snapshot2.hasError) {
                                return const Icon(
                                  Icons.error,
                                );
                              } else {
                                return displaysimpleprogress(context);
                              }
                            },
                          ),
                          verticalSpaceSmall,
                          text_helper(
                            data: snapshot.data[index]["title"],
                            fontWeight: FontWeight.bold,
                            size: fontSize10,
                            color: Theme.of(context).primaryColor,
                          ),
                          text_helper(
                            data: snapshot.data[index]["ans"],
                            size: fontSize10,
                            textAlign: TextAlign.start,
                          ),
                          verticalSpaceSmall,
                          button_helper(
                              onpress: () =>
                                  viewModel.chat(snapshot.data[index]["uid"]),
                              child: text_helper(data: "Chat"))
                        ],
                      ),
                    );
                  },
                );
              }
            } else if (snapshot.hasError) {
              return const Icon(
                Icons.error,
              );
            } else {
              return displaysimpleprogress(context);
            }
          },
        ));
      },
    );
    viewModel.notifyListeners();
  }

  Future<void> agreement(BuildContext context, AdminViewModel viewModel) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            child: FutureBuilder(
          future: ApiHelper.allbooking(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.toString() == '[]') {
                return const SizedBox.shrink();
              } else {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (snapshot.data[index]["status"] == "false") {
                      return Container(
                        width: screenWidth(context),
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: getColorWithOpacity(Colors.grey, 0.1)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            FutureBuilder(
                              future: ApiHelper.findone(
                                  snapshot.data[index]['uid']),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot2) {
                                if (snapshot2.hasData) {
                                  if (snapshot2.data.toString() == '[]') {
                                    return const SizedBox.shrink();
                                  } else {
                                    return Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: CachedNetworkImage(
                                            imageUrl: snapshot2.data["img"].toString(),
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              width: screenWidthCustom(
                                                  context, 0.1),
                                              height: screenWidthCustom(
                                                  context, 0.1),
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            placeholder: (context, url) =>
                                                displaysimpleprogress(context),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(
                                              Icons.error,
                                            ),
                                          ),
                                        ),
                                        horizontalSpaceMedium,
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            text_helper(
                                              data: snapshot2.data["name"],
                                              fontWeight: FontWeight.bold,
                                              size: fontSize12,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            text_helper(
                                              data: snapshot2.data["email"],
                                              size: fontSize10,
                                              textAlign: TextAlign.start,
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  }
                                } else if (snapshot2.hasError) {
                                  return const Icon(
                                    Icons.error,
                                  );
                                } else {
                                  return displaysimpleprogress(context);
                                }
                              },
                            ),
                            verticalSpaceSmall,
                            FutureBuilder(
                              future: ApiHelper.findone(
                                  snapshot.data[index]['ppid']),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot2) {
                                if (snapshot2.hasData) {
                                  if (snapshot2.data.toString() == '[]') {
                                    return const SizedBox.shrink();
                                  } else {
                                    return Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: CachedNetworkImage(
                                            imageUrl: snapshot2.data["img"],
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              width: screenWidthCustom(
                                                  context, 0.1),
                                              height: screenWidthCustom(
                                                  context, 0.1),
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            placeholder: (context, url) =>
                                                displaysimpleprogress(context),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(
                                              Icons.error,
                                            ),
                                          ),
                                        ),
                                        horizontalSpaceMedium,
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            text_helper(
                                              data: snapshot2.data["name"],
                                              fontWeight: FontWeight.bold,
                                              size: fontSize12,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            text_helper(
                                              data: snapshot2.data["email"],
                                              size: fontSize10,
                                              textAlign: TextAlign.start,
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  }
                                } else if (snapshot2.hasError) {
                                  return const Icon(
                                    Icons.error,
                                  );
                                } else {
                                  return displaysimpleprogress(context);
                                }
                              },
                            ),
                            verticalSpaceSmall,
                            FutureBuilder(
                              future: ApiHelper.getoneproject(
                                  snapshot.data[index]['pid']),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot2) {
                                if (snapshot2.hasData) {
                                  if (snapshot2.data.toString() == '[]') {
                                    return const SizedBox.shrink();
                                  } else {
                                    return Column(
                                      children: [
                                        t(context, "Title",
                                            snapshot2.data['title'].toString()),
                                        t(context, "Description",
                                            snapshot2.data['des'].toString()),
                                        t(context, "Price",
                                            "PKR " + snapshot2.data['price'].toString()),
                                      ],
                                    );
                                  }
                                } else if (snapshot2.hasError) {
                                  return const Icon(
                                    Icons.error,
                                  );
                                } else {
                                  return displaysimpleprogress(context);
                                }
                              },
                            ),
                            verticalSpaceSmall,
                            verticalSpaceSmall,
                            button_helper(
                                onpress: () {
                                  displayprogress(context);
                                  ApiHelper.statusbookingchange(
                                      snapshot.data[index]["_id"]);
                                  hideprogress(context);
                                  Navigator.pop(context);
                                },
                                child: text_helper(data: "Approve"))
                          ],
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                );
              }
            } else if (snapshot.hasError) {
              return const Icon(
                Icons.error,
              );
            } else {
              return displaysimpleprogress(context);
            }
          },
        ));
      },
    );
    viewModel.notifyListeners();
  }

  Widget t(BuildContext context, String data, String data2) {
    return Column(
      children: [
        Container(
          width: screenWidth(context),
          height: 1,
          color: Colors.grey,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              text_helper(
                data: data,
                size: fontSize10,
                fontWeight: FontWeight.bold,
              ),
              horizontalSpaceSmall,
              Expanded(
                  child: text_helper(
                data: data2,
                size: fontSize10,
                textAlign: TextAlign.start,
              )),
            ],
          ),
        ),
        Container(
          width: screenWidth(context),
          height: 1,
          color: Colors.grey,
        ),
      ],
    );
  }

  @override
  AdminViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      AdminViewModel();
}
