import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/selfies_provider.dart';
import '../model/log_model.dart';

class LogsWidget extends StatefulWidget {
  const LogsWidget({super.key, required this.logs, required this.index});
  final List<Log> logs;
  final int index;

  @override
  State<LogsWidget> createState() => _LogsWidgetState();
}

class _LogsWidgetState extends State<LogsWidget> {
  final textStyleImage = const TextStyle(
    color: Colors.blue,
    decoration: TextDecoration.underline,
    fontSize: 13.0,
  );

  TextStyle fontStyleFunc(String logType) {
    return TextStyle(
      color: logType == 'IN' ? Colors.green : Colors.red,
      fontSize: 13.0,
    );
  }

  static const String imageFolder = 'http://103.62.153.74:53000/field_api/';

  static const String googleMapsUrl = 'https://maps.google.com/maps?q=loc:';

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
    var selfies = Provider.of<SelfiesProvider>(context, listen: false);

    Widget approvalStatus(int status) {
      switch (status) {
        case 1:
          return const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Approved',
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.green,
                ),
              ),
              Icon(
                Icons.check,
                size: 15.0,
                color: Colors.green,
              ),
            ],
          );
        case 2:
          return const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Disapproved',
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.red,
                ),
              ),
              Icon(
                Icons.close,
                size: 15.0,
                color: Colors.red,
              ),
            ],
          );
        default:
          return const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'For Approval',
                style: TextStyle(fontSize: 12.0),
              ),
              Icon(Icons.access_time, size: 15.0),
            ],
          );
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int j = 0; j < widget.logs.length; j++) ...[
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(widget.logs[j].logType,
                  style: fontStyleFunc(widget.logs[j].logType)),
              Text(
                selfies.dateFormat12or24Web(widget.logs[j].timeStamp),
                style: textStyleImage,
              ),
              approvalStatus(widget.logs[j].approvalStatus),
            ],
          ),
          SizedBox(
            height: 20.0,
            width: 20.0,
            child: PopupMenuButton<String>(
              onSelected: (String value) async {
                String latlng = widget.logs[j].latlng.replaceAll(' ', ',');

                if (value == 'Show Image') {
                  launchUrl(
                    Uri.parse('$imageFolder${widget.logs[j].imagePath}'),
                  );
                } else if (value == 'Show Map') {
                  launchUrl(
                    Uri.parse('$googleMapsUrl$latlng'),
                  );
                } else if (value == 'Approve') {
                  await selfies.insertStatus(
                    approved: 1,
                    approvedBy: 'Janrey Dumaog',
                    logId: widget.logs[j].id,
                    indexList: widget.index,
                    indexLog: j,
                  );
                } else if (value == 'Disapprove') {
                  await selfies.insertStatus(
                    approved: 2,
                    approvedBy: 'Janrey Dumaog',
                    logId: widget.logs[j].id,
                    indexList: widget.index,
                    indexLog: j,
                  );
                }
              },
              iconSize: 20.0,
              tooltip: 'Menu',
              splashRadius: 12.0,
              padding: const EdgeInsets.all(0.0),
              itemBuilder: (BuildContext context) {
                return {'Show Image', 'Show Map', 'Approve', 'Disapprove'}
                    .map((String choice) {
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
      ],
    );
  }
}
