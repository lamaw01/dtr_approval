import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/for_approval_provider.dart';
import '../widgets/data_row_widget.dart';

class ForApprovalView extends StatefulWidget {
  const ForApprovalView({super.key});

  @override
  State<ForApprovalView> createState() => _ForApprovalViewState();
}

class _ForApprovalViewState extends State<ForApprovalView> {
  final _scrollController = ScrollController();

  static const String imageFolder = 'http://103.62.153.74:53000/field_api/';

  static const String googleMapsUrl = 'https://maps.google.com/maps?q=loc:';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    final forapproval =
        Provider.of<ForApprovalProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (forapproval.forapprovalList.isEmpty) {
        await forapproval.getForApproval();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() async {
    final forapproval =
        Provider.of<ForApprovalProvider>(context, listen: false);
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      forapproval.changeLoadingState(true);
      await forapproval.getForApprovalLoadmore();
      forapproval.changeLoadingState(false);
    }
    // if (_scrollController.offset >=
    //     _scrollController.position.maxScrollExtent) {
    //   forapproval.changeLoadingState(true);
    //   await forapproval.getforapprovalLoadmore();
    //   forapproval.changeLoadingState(false);
    // }
  }

  Color? getBackground(String status) {
    switch (status) {
      case 'Approve':
        return Colors.green;
      case 'Disapprove':
        return Colors.red;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ForApprovalProvider>(
      builder: (ctx, forapproval, widget) {
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
                    await forapproval.getForApproval();
                  },
                  child: ListView.separated(
                    controller: _scrollController,
                    separatorBuilder: (_, __) => const Divider(),
                    itemCount: forapproval.forapprovalList.length,
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
                                  forapproval.forapprovalList[index].employeeId,
                              width: 50.0,
                              color: Colors.amber,
                            ),
                            DataRowWidget(
                              text: forapproval
                                  .fullName(forapproval.forapprovalList[index]),
                              width: 200.0,
                              color: Colors.pink,
                            ),
                            DataRowWidget(
                              text: forapproval.forapprovalList[index].logType,
                              width: 75.0,
                              color: Colors.teal,
                            ),
                            DataRowWidget(
                              text:
                                  forapproval.forapprovalList[index].department,
                              width: 100.0,
                              color: Colors.teal,
                            ),
                            DataRowWidget(
                              text: forapproval.forapprovalList[index].team,
                              width: 100.0,
                              color: Colors.teal,
                            ),
                            DataRowWidget(
                              text: DateFormat('yyyy-MM-dd HH:mm').format(
                                  forapproval.forapprovalList[index].timeStamp),
                              width: 150.0,
                              color: Colors.blue,
                            ),
                            SizedBox(
                              height: 20.0,
                              width: 20.0,
                              child: PopupMenuButton<String>(
                                onSelected: (String value) async {
                                  String latlng = forapproval
                                      .forapprovalList[index].latlng
                                      .replaceAll(' ', ',');

                                  if (value == 'Show Image') {
                                    launchUrl(
                                      Uri.parse(
                                          '$imageFolder${forapproval.forapprovalList[index].imagePath}'),
                                    );
                                  } else if (value == 'Show Map') {
                                    launchUrl(
                                      Uri.parse('$googleMapsUrl$latlng'),
                                    );
                                  } else if (value == 'Approve') {
                                    await forapproval.insertStatusForApproval(
                                      approved: 1,
                                      approvedBy: 'Janrey Dumaog',
                                      logId:
                                          forapproval.forapprovalList[index].id,
                                    );
                                  } else if (value == 'Disapprove') {
                                    await forapproval.insertStatusForApproval(
                                      approved: 2,
                                      approvedBy: 'Janrey Dumaog',
                                      logId:
                                          forapproval.forapprovalList[index].id,
                                    );
                                  }
                                  // else if (value == 'Loadmore') {
                                  //   forapproval.changeLoadingState(true);
                                  //   await forapproval.getforapprovalLoadmore();
                                  //   forapproval.changeLoadingState(false);
                                  // }
                                },
                                iconSize: 20.0,
                                tooltip: 'Menu',
                                splashRadius: 12.0,
                                padding: const EdgeInsets.all(0.0),
                                itemBuilder: (BuildContext context) {
                                  return {
                                    'Show Image',
                                    'Show Map',
                                    'Approve',
                                    'Disapprove'
                                  }.map((String choice) {
                                    return PopupMenuItem<String>(
                                      value: choice,
                                      child: Text(
                                        choice,
                                        style: TextStyle(
                                          fontSize: 13.0,
                                          color: getBackground(choice),
                                        ),
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
            if (forapproval.loadMore) ...[
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
