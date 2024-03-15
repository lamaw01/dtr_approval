import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/approved_provider.dart';
import '../widgets/data_row_widget.dart';

class ApprovedView extends StatefulWidget {
  const ApprovedView({super.key});

  @override
  State<ApprovedView> createState() => _ApprovedViewState();
}

class _ApprovedViewState extends State<ApprovedView> {
  final _scrollController = ScrollController();

  static const String imageFolder = 'http://103.62.153.74:53000/field_api/';

  static const String googleMapsUrl = 'https://maps.google.com/maps?q=loc:';

  @override
  void initState() {
    super.initState();
    final approved = Provider.of<ApprovedProvider>(context, listen: false);
    _scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (approved.approvedList.isEmpty) {
        await approved.getApproved();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() async {
    final approved = Provider.of<ApprovedProvider>(context, listen: false);
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      approved.changeLoadingState(true);
      await approved.getApprovedLoadmore();
      approved.changeLoadingState(false);
    }
    // if (_scrollController.offset >=
    //     _scrollController.position.maxScrollExtent) {
    //   approved.changeLoadingState(true);
    //   await approved.getApprovedLoadmore();
    //   approved.changeLoadingState(false);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Approved Selfies'),
      ),
      body: Consumer<ApprovedProvider>(
        builder: (ctx, approved, widget) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (MediaQuery.of(context).size.width > 600) ...[
                  Container(
                    color: Colors.grey,
                    width: 1000.0,
                    height: 40.0,
                    child: const Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        DataRowWidget(
                          text: 'Emp Id',
                          width: 50.0,
                          color: Colors.amber,
                        ),
                        DataRowWidget(
                          text: 'Name',
                          width: 200.0,
                          color: Colors.pink,
                        ),
                        DataRowWidget(
                          text: 'Log Type',
                          width: 75.0,
                          color: Colors.teal,
                        ),
                        DataRowWidget(
                          text: 'Department',
                          width: 100.0,
                          color: Colors.teal,
                        ),
                        DataRowWidget(
                          text: 'Team',
                          width: 100.0,
                          color: Colors.teal,
                        ),
                        DataRowWidget(
                          text: 'Timestamp',
                          width: 150.0,
                          color: Colors.blue,
                        ),
                        DataRowWidget(
                          text: 'Approved By',
                          width: 150.0,
                          color: Colors.purple,
                        ),
                        SizedBox(
                          height: 20.0,
                          width: 20.0,
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      // color: Colors.pink[300],
                      width: 1000.0,
                      child: RefreshIndicator(
                        onRefresh: () async {
                          await approved.getApproved();
                        },
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: approved.approvedList.length,
                          itemBuilder: (_, index) {
                            return Container(
                              width: 1000.0,
                              height: 40.0,
                              color: index % 2 == 0 ? null : Colors.grey[300],
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  DataRowWidget(
                                    text:
                                        approved.approvedList[index].employeeId,
                                    width: 50.0,
                                    color: Colors.amber,
                                  ),
                                  DataRowWidget(
                                    text: approved
                                        .fullName(approved.approvedList[index]),
                                    width: 200.0,
                                    color: Colors.pink,
                                  ),
                                  DataRowWidget(
                                    text: approved.approvedList[index].logType,
                                    width: 75.0,
                                    color: Colors.teal,
                                  ),
                                  DataRowWidget(
                                    text:
                                        approved.approvedList[index].department,
                                    width: 100.0,
                                    color: Colors.teal,
                                  ),
                                  DataRowWidget(
                                    text: approved.approvedList[index].team,
                                    width: 100.0,
                                    color: Colors.teal,
                                  ),
                                  DataRowWidget(
                                    text: DateFormat('yyyy-MM-dd HH:mm').format(
                                        approved.approvedList[index].timeStamp),
                                    width: 150.0,
                                    color: Colors.blue,
                                  ),
                                  DataRowWidget(
                                    text:
                                        approved.approvedList[index].approvedBy,
                                    width: 150.0,
                                    color: Colors.purple,
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                    width: 20.0,
                                    child: PopupMenuButton<String>(
                                      onSelected: (String value) async {
                                        String latlng = approved
                                            .approvedList[index].latlng
                                            .replaceAll(' ', ',');

                                        if (value == 'Show Image') {
                                          launchUrl(
                                            Uri.parse(
                                                '$imageFolder${approved.approvedList[index].imagePath}'),
                                          );
                                        } else if (value == 'Show Map') {
                                          launchUrl(
                                            Uri.parse('$googleMapsUrl$latlng'),
                                          );
                                        }
                                        // else if (value == 'Loadmore') {
                                        //   approved.changeLoadingState(true);
                                        //   await approved.getApprovedLoadmore();
                                        //   approved.changeLoadingState(false);
                                        // }
                                      },
                                      iconSize: 20.0,
                                      tooltip: 'Menu',
                                      splashRadius: 12.0,
                                      padding: const EdgeInsets.all(0.0),
                                      itemBuilder: (BuildContext context) {
                                        return {'Show Image', 'Show Map'}
                                            .map((String choice) {
                                          return PopupMenuItem<String>(
                                            value: choice,
                                            child: Text(
                                              choice,
                                              style: const TextStyle(
                                                  fontSize: 13.0),
                                            ),
                                          );
                                        }).toList();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  if (approved.loadMore) ...[
                    const SizedBox(
                      height: 30.0,
                      width: 30.0,
                      child: CircularProgressIndicator(),
                    ),
                  ],
                ] else ...[
                  Expanded(
                    child: SizedBox(
                      // color: Colors.pink[300],
                      width: 500.0,
                      child: RefreshIndicator(
                        onRefresh: () async {
                          await approved.getApproved();
                        },
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: approved.approvedList.length,
                          itemBuilder: (_, index) {
                            return Container(
                              width: 450.0,
                              height: 40.0,
                              color: index % 2 == 0 ? null : Colors.grey[300],
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      DataRowWidget(
                                        text: approved
                                            .approvedList[index].employeeId,
                                        width: 100.0,
                                        color: Colors.amber,
                                      ),
                                      DataRowWidget(
                                        text: approved.fullName(
                                            approved.approvedList[index]),
                                        width: 200.0,
                                        color: Colors.pink,
                                      ),
                                      DataRowWidget(
                                        text: approved
                                            .approvedList[index].department,
                                        width: 50.0,
                                        color: Colors.teal,
                                      ),
                                      DataRowWidget(
                                        text: approved.approvedList[index].team,
                                        width: 100.0,
                                        color: Colors.teal,
                                      ),
                                      const SizedBox(
                                        height: 20.0,
                                        width: 20.0,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      DataRowWidget(
                                        text: approved
                                            .approvedList[index].logType,
                                        width: 100.0,
                                        color: Colors.teal,
                                      ),
                                      DataRowWidget(
                                        text: approved
                                            .approvedList[index].approvedBy,
                                        width: 200.0,
                                        color: Colors.purple,
                                      ),
                                      DataRowWidget(
                                        text: DateFormat('yyyy-MM-dd HH:mm')
                                            .format(approved
                                                .approvedList[index].timeStamp),
                                        width: 150.0,
                                        color: Colors.blue,
                                      ),
                                      SizedBox(
                                        height: 20.0,
                                        width: 20.0,
                                        child: PopupMenuButton<String>(
                                          onSelected: (String value) async {
                                            String latlng = approved
                                                .approvedList[index].latlng
                                                .replaceAll(' ', ',');

                                            if (value == 'Show Image') {
                                              launchUrl(
                                                Uri.parse(
                                                    '$imageFolder${approved.approvedList[index].imagePath}'),
                                              );
                                            } else if (value == 'Show Map') {
                                              launchUrl(
                                                Uri.parse(
                                                    '$googleMapsUrl$latlng'),
                                              );
                                            }
                                            // else if (value == 'Loadmore') {
                                            //   approved.changeLoadingState(true);
                                            //   await approved.getApprovedLoadmore();
                                            //   approved.changeLoadingState(false);
                                            // }
                                          },
                                          iconSize: 20.0,
                                          tooltip: 'Menu',
                                          splashRadius: 12.0,
                                          padding: const EdgeInsets.all(0.0),
                                          itemBuilder: (BuildContext context) {
                                            return {'Show Image', 'Show Map'}
                                                .map((String choice) {
                                              return PopupMenuItem<String>(
                                                value: choice,
                                                child: Text(
                                                  choice,
                                                  style: const TextStyle(
                                                      fontSize: 13.0),
                                                ),
                                              );
                                            }).toList();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  if (approved.loadMore) ...[
                    const SizedBox(
                      height: 30.0,
                      width: 30.0,
                      child: CircularProgressIndicator(),
                    ),
                  ],
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
