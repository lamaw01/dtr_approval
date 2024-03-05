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
  late ScrollController _scrollController;

  static const String imageFolder = 'http://103.62.153.74:53000/field_api/';

  static const String googleMapsUrl = 'https://maps.google.com/maps?q=loc:';

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) async {});
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() async {
    final approved = Provider.of<ApprovedProvider>(context, listen: false);
    // if (_scrollController.position.extentAfter < 500) {
    //   setState(() {
    //     items.addAll(List.generate(42, (index) => 'Inserted $index'));
    //   });
    // }
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !approved.loadMore) {
      await approved.getApprovedLoadmore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ApprovedProvider>(
      builder: (ctx, approved, widget) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              color: Colors.grey,
              width: 800.0,
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
                    text: 'Approved By',
                    width: 150.0,
                    color: Colors.purple,
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
                width: 800.0,
                child: ListView.separated(
                  separatorBuilder: (_, __) => const Divider(),
                  itemCount: approved.approvedList.length,
                  itemBuilder: (_, index) {
                    return SizedBox(
                      width: 600.0,
                      height: 30.0,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          DataRowWidget(
                            text: approved.approvedList[index].employeeId,
                            width: 50.0,
                            color: Colors.amber,
                          ),
                          DataRowWidget(
                            text:
                                approved.fullName(approved.approvedList[index]),
                            width: 200.0,
                            color: Colors.pink,
                          ),
                          DataRowWidget(
                            text: approved.approvedList[index].logType,
                            width: 75.0,
                            color: Colors.teal,
                          ),
                          DataRowWidget(
                            text: approved.approvedList[index].approvedBy,
                            width: 150.0,
                            color: Colors.purple,
                          ),
                          DataRowWidget(
                            text: DateFormat('yyyy-MM-dd HH:mm')
                                .format(approved.approvedList[index].timeStamp),
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
                                    Uri.parse('$googleMapsUrl$latlng'),
                                  );
                                } else if (value == 'Loadmore') {
                                  approved.getApprovedLoadmore();
                                }
                              },
                              iconSize: 20.0,
                              tooltip: 'Menu',
                              splashRadius: 12.0,
                              padding: const EdgeInsets.all(0.0),
                              itemBuilder: (BuildContext context) {
                                return {'Show Image', 'Show Map', 'Loadmore'}
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
            if (approved.loadMore) ...[
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
