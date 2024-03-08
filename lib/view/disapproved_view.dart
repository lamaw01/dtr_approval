import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/disapproved_provider.dart';
import '../widgets/data_row_widget.dart';

class DisapprovedView extends StatefulWidget {
  const DisapprovedView({super.key});

  @override
  State<DisapprovedView> createState() => _DisapprovedViewState();
}

class _DisapprovedViewState extends State<DisapprovedView> {
  final _scrollController = ScrollController();

  static const String imageFolder = 'http://103.62.153.74:53000/field_api/';

  static const String googleMapsUrl = 'https://maps.google.com/maps?q=loc:';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    final disapproved =
        Provider.of<DisapprovedProvider>(context, listen: false);
    _scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (disapproved.disapprovedList.isEmpty) {
        await disapproved.getDisapproved();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() async {
    final approved = Provider.of<DisapprovedProvider>(context, listen: false);
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      approved.changeLoadingState(true);
      await approved.getDisapprovedLoadmore();
      approved.changeLoadingState(false);
    }
    // if (_scrollController.offset >=
    //     _scrollController.position.maxScrollExtent) {
    //   approved.changeLoadingState(true);
    //   await approved.getDisapprovedLoadmore();
    //   approved.changeLoadingState(false);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DisapprovedProvider>(
      builder: (ctx, disapproved, widget) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              color: Colors.grey,
              width: 1000.0,
              height: 30.0,
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
                    width: 80.0,
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
                    text: 'Disapproved By',
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
                    await disapproved.getDisapproved();
                  },
                  child: ListView.separated(
                    controller: _scrollController,
                    separatorBuilder: (_, __) => const Divider(),
                    itemCount: disapproved.disapprovedList.length,
                    itemBuilder: (_, index) {
                      return SizedBox(
                        width: 1000.0,
                        height: 30.0,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            DataRowWidget(
                              text:
                                  disapproved.disapprovedList[index].employeeId,
                              width: 50.0,
                              color: Colors.amber,
                            ),
                            DataRowWidget(
                              text: disapproved
                                  .fullName(disapproved.disapprovedList[index]),
                              width: 200.0,
                              color: Colors.pink,
                            ),
                            DataRowWidget(
                              text: disapproved.disapprovedList[index].logType,
                              width: 80.0,
                              color: Colors.teal,
                            ),
                            DataRowWidget(
                              text:
                                  disapproved.disapprovedList[index].department,
                              width: 100.0,
                              color: Colors.teal,
                            ),
                            DataRowWidget(
                              text: disapproved.disapprovedList[index].team,
                              width: 100.0,
                              color: Colors.teal,
                            ),
                            DataRowWidget(
                              text: DateFormat('yyyy-MM-dd HH:mm').format(
                                  disapproved.disapprovedList[index].timeStamp),
                              width: 150.0,
                              color: Colors.blue,
                            ),
                            DataRowWidget(
                              text:
                                  disapproved.disapprovedList[index].approvedBy,
                              width: 150.0,
                              color: Colors.purple,
                            ),
                            SizedBox(
                              height: 20.0,
                              width: 20.0,
                              child: PopupMenuButton<String>(
                                onSelected: (String value) async {
                                  String latlng = disapproved
                                      .disapprovedList[index].latlng
                                      .replaceAll(' ', ',');

                                  if (value == 'Show Image') {
                                    launchUrl(
                                      Uri.parse(
                                          '$imageFolder${disapproved.disapprovedList[index].imagePath}'),
                                    );
                                  } else if (value == 'Show Map') {
                                    launchUrl(
                                      Uri.parse('$googleMapsUrl$latlng'),
                                    );
                                  }
                                  // else if (value == 'Loadmore') {
                                  //   disapproved.changeLoadingState(true);
                                  //   await disapproved.getDisapprovedLoadmore();
                                  //   disapproved.changeLoadingState(false);
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
                                        style: const TextStyle(fontSize: 13.0),
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
            if (disapproved.loadMore) ...[
              const SizedBox(
                height: 30.0,
                width: 30.0,
                child: CircularProgressIndicator(),
              ),
            ],
          ],
        );
      },
    );
  }
}
