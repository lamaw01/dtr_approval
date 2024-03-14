import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../data/department_provider.dart';
import '../data/selfies_provider.dart';
import '../data/version_provider.dart';
import '../model/department_model.dart';
import '../services/stream_shared.dart';
import '../widgets/logs_widget.dart';
import 'approved_view.dart';
import 'disapproved_view.dart';
import 'for_approval_view.dart';
import 'login_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final idController = TextEditingController();
  final fromController =
      TextEditingController(text: DateFormat.yMEd().format(DateTime.now()));
  final toController =
      TextEditingController(text: DateFormat.yMEd().format(DateTime.now()));
  final scrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    idController.dispose();
    fromController.dispose();
    toController.dispose();
    scrollController.dispose();
  }

  Future<DateTime> showDateFromDialog({required BuildContext context}) async {
    var selfies = Provider.of<SelfiesProvider>(context, listen: false);
    var dateFrom = await showDatePicker(
      context: context,
      initialDate: selfies.selectedFrom,
      firstDate: DateTime(2023, 1, 1),
      lastDate: DateTime.now(),
    );
    if (dateFrom != null) {
      selfies.selectedFrom = dateFrom;
    }
    return selfies.selectedFrom;
  }

  Future<DateTime> showDateToDialog({required BuildContext context}) async {
    var selfies = Provider.of<SelfiesProvider>(context, listen: false);
    var dateTo = await showDatePicker(
      context: context,
      initialDate: selfies.selectedTo,
      firstDate: DateTime(2023, 1, 1),
      lastDate: DateTime.now(),
    );
    if (dateTo != null) {
      selfies.selectedTo = dateTo;
    }
    return selfies.selectedTo;
  }

  Color? getDataRowColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
      MaterialState.selected
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.grey[300];
    }
    return null;
  }

  late Future<String> _getApproverName;

  @override
  void initState() {
    final version = Provider.of<VersionProvider>(context, listen: false);
    final department = Provider.of<DepartmentProvider>(context, listen: false);
    final selfies = Provider.of<SelfiesProvider>(context, listen: false);
    super.initState();
    _getApproverName = SharedPreference().approverName();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await version.getPackageInfo();
      await department.getDepartment();
      await selfies.getSelfiesAll(department.dropdownValue);
    });
  }

  void confirmDeleteGroup() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          content: const Text('Logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                SharedPreference().removeLoginData();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginView()),
                );
              },
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const String title = 'DTR Approval';
    final department = Provider.of<DepartmentProvider>(context);
    final version = Provider.of<VersionProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text(title),
            const SizedBox(
              width: 2.5,
            ),
            Text(
              "v${version.version}",
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: FutureBuilder<String>(
                future: _getApproverName,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  return Text(
                    snapshot.data!,
                    style: const TextStyle(color: Colors.white, fontSize: 20.0),
                  );
                },
              ),
              accountEmail: null,
            ),
            Card(
              child: ListTile(
                title: const Text('For approval'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ForApprovalView(),
                    ),
                  );
                },
              ),
            ),
            Card(
              child: ListTile(
                title: const Text('Approved'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ApprovedView(),
                    ),
                  );
                },
              ),
            ),
            Card(
              child: ListTile(
                title: const Text('Disapproved'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const DisapprovedView(),
                    ),
                  );
                },
              ),
            ),
            Card(
              child: ListTile(
                title: const Text('Logout'),
                onTap: confirmDeleteGroup,
              ),
            ),
          ],
        ),
      ),
      body: Consumer<SelfiesProvider>(
        builder: (ctx, selfies, widget) {
          return Scrollbar(
            // thickness: 18,
            thumbVisibility: true,
            trackVisibility: true,
            // interactive: true,
            // radius: const Radius.circular(15),
            controller: scrollController,
            child: SingleChildScrollView(
              controller: scrollController,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ValueListenableBuilder<bool>(
                      valueListenable: selfies.isLoading,
                      builder: (context, value, child) {
                        if (value) {
                          return LinearProgressIndicator(
                            backgroundColor: Colors.grey,
                            color: Colors.orange[300],
                            minHeight: 10,
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                    const SizedBox(height: 10.0),
                    if (MediaQuery.of(context).size.width > 600) ...[
                      SizedBox(
                        height: 300.0,
                        width: 800.0,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'From :',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 300.0,
                                      child: TextField(
                                        style: const TextStyle(fontSize: 18.0),
                                        readOnly: true,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.grey,
                                              width: 1.0,
                                            ),
                                          ),
                                          isDense: true,
                                          contentPadding: EdgeInsets.fromLTRB(
                                              12.0, 12.0, 12.0, 12.0),
                                        ),
                                        controller: fromController,
                                        onTap: () async {
                                          selfies.selectedFrom =
                                              await showDateFromDialog(
                                                  context: context);
                                          setState(() {
                                            fromController.text =
                                                DateFormat.yMEd().format(
                                                    selfies.selectedFrom);
                                          });
                                        },
                                      ),
                                    ),
                                    const Text(
                                      'To :',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 300.0,
                                      child: TextField(
                                        style: const TextStyle(fontSize: 18.0),
                                        readOnly: true,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.grey,
                                              width: 1.0,
                                            ),
                                          ),
                                          isDense: true,
                                          contentPadding: EdgeInsets.fromLTRB(
                                              12.0, 12.0, 12.0, 12.0),
                                        ),
                                        controller: toController,
                                        onTap: () async {
                                          selfies.selectedTo =
                                              await showDateToDialog(
                                                  context: context);
                                          setState(() {
                                            toController.text =
                                                DateFormat.yMEd()
                                                    .format(selfies.selectedTo);
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10.0),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Department: ',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Container(
                                      height: 40.0,
                                      width: 640.0,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                          color: Colors.grey,
                                          style: BorderStyle.solid,
                                          width: 1.0,
                                        ),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<DepartmentModel>(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          value: department.dropdownValue,
                                          onChanged:
                                              (DepartmentModel? value) async {
                                            if (value != null) {
                                              setState(() {
                                                department.dropdownValue =
                                                    value;
                                              });
                                            }
                                          },
                                          items: department.departmentList.map<
                                                  DropdownMenuItem<
                                                      DepartmentModel>>(
                                              (DepartmentModel value) {
                                            return DropdownMenuItem<
                                                DepartmentModel>(
                                              value: value,
                                              child: Text(value.departmentName),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10.0),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        style: const TextStyle(fontSize: 18.0),
                                        decoration: const InputDecoration(
                                          label: Text('ID no. or Name'),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.grey,
                                              width: 1.0,
                                            ),
                                          ),
                                          isDense: true,
                                          contentPadding: EdgeInsets.fromLTRB(
                                              12.0, 12.0, 12.0, 12.0),
                                        ),
                                        controller: idController,
                                        onSubmitted: (data) async {
                                          selfies.changeLoadingState(true);
                                          await Future.delayed(
                                              const Duration(seconds: 1));
                                          if (idController.text.isEmpty) {
                                            // get records all
                                            await selfies.getSelfiesAll(
                                                department.dropdownValue);
                                          } else {
                                            // get records with id or name
                                            await selfies.getSelfies(
                                                idController.text.trim(),
                                                department.dropdownValue);
                                          }
                                          selfies.changeLoadingState(false);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5.0),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      '24 Hour format: ',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    ValueListenableBuilder(
                                      valueListenable: is24HourFormat,
                                      builder: (_, value, __) {
                                        return Checkbox(
                                          value: is24HourFormat.value,
                                          onChanged: (newCheckboxState) {
                                            is24HourFormat.value =
                                                newCheckboxState!;
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10.0),
                                Container(
                                  color: Colors.green[300],
                                  width: double.infinity,
                                  height: 50.0,
                                  child: TextButton(
                                    onPressed: () async {
                                      selfies.changeLoadingState(true);

                                      await Future.delayed(
                                          const Duration(seconds: 1));

                                      await selfies.getSelfiesAll(
                                          department.dropdownValue);

                                      selfies.changeLoadingState(false);
                                    },
                                    child: const Text(
                                      'View',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (selfies.selfieList.isNotEmpty) ...[
                        DataTable(
                          dataRowMaxHeight: 70.0,
                          showCheckboxColumn: false,
                          dataRowColor: MaterialStateProperty.resolveWith(
                              getDataRowColor),
                          columns: const <DataColumn>[
                            DataColumn(
                              label: Expanded(
                                child: Text(
                                  'ID No.',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Expanded(
                                child: Text(
                                  'Name',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Expanded(
                                child: Text(
                                  'DATE',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Expanded(
                                child: Text(
                                  'TIME',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                          rows: <DataRow>[
                            for (int i = 0; i < selfies.uiList.length; i++) ...[
                              DataRow(
                                // onSelectChanged: (value) {},
                                selected: i % 2 == 0 ? true : false,
                                cells: <DataCell>[
                                  DataCell(SelectableText(
                                    selfies.uiList[i].employeeId,
                                    style: const TextStyle(fontSize: 13.0),
                                  )),
                                  DataCell(SelectableText(
                                    '${selfies.uiList[i].lastName}, ${selfies.uiList[i].firstName} ${selfies.uiList[i].middleName}',
                                    style: const TextStyle(fontSize: 13.0),
                                  )),
                                  DataCell(SelectableText(
                                    DateFormat.yMMMEd()
                                        .format(selfies.uiList[i].date),
                                    style: const TextStyle(fontSize: 13.0),
                                  )),
                                  DataCell(LogsWidget(
                                      logs: selfies.uiList[i].logs, index: i)),
                                ],
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 25.0),
                        if (selfies.uiList.length <
                            selfies.selfieList.length) ...[
                          SizedBox(
                            height: 50.0,
                            width: 180.0,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.green[300],
                              ),
                              onPressed: () {
                                if (selfies.uiList.length <
                                    selfies.selfieList.length) {
                                  selfies.loadMore();
                                }
                              },
                              child: const Text(
                                'Load more..',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15.0),
                        ],
                        Text(
                          'Showing ${selfies.uiList.length} out of ${selfies.selfieList.length} results.',
                          style: const TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        const SizedBox(height: 50.0),
                      ] else if (selfies.selfieList.isEmpty) ...[
                        const SizedBox(height: 25.0),
                        if (selfies.selectedFrom
                            .isAfter(selfies.selectedTo)) ...[
                          const Text(
                            'Date From is advance than Date To.',
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ] else ...[
                          const Text(
                            'No data found.',
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ]
                      ]
                    ] else ...[
                      SizedBox(
                        height: 380.0,
                        width: 400.0,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 35.0,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'From :',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 250.0,
                                        child: TextField(
                                          style:
                                              const TextStyle(fontSize: 18.0),
                                          readOnly: true,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.grey,
                                                width: 1.0,
                                              ),
                                            ),
                                            isDense: true,
                                            contentPadding: EdgeInsets.fromLTRB(
                                                12.0, 12.0, 12.0, 12.0),
                                          ),
                                          controller: fromController,
                                          onTap: () async {
                                            selfies.selectedFrom =
                                                await showDateFromDialog(
                                                    context: context);
                                            setState(() {
                                              fromController.text =
                                                  DateFormat.yMEd().format(
                                                      selfies.selectedFrom);
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                SizedBox(
                                  height: 35.0,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'To :',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 250.0,
                                        child: TextField(
                                          style:
                                              const TextStyle(fontSize: 18.0),
                                          readOnly: true,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.grey,
                                                width: 1.0,
                                              ),
                                            ),
                                            isDense: true,
                                            contentPadding: EdgeInsets.fromLTRB(
                                                12.0, 12.0, 12.0, 12.0),
                                          ),
                                          controller: toController,
                                          onTap: () async {
                                            selfies.selectedTo =
                                                await showDateToDialog(
                                                    context: context);
                                            setState(() {
                                              toController.text =
                                                  DateFormat.yMEd().format(
                                                      selfies.selectedTo);
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                SizedBox(
                                  height: 35.0,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Department: ',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Container(
                                        height: 35.0,
                                        width: 250.0,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                            color: Colors.grey,
                                            style: BorderStyle.solid,
                                            width: 1.0,
                                          ),
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child:
                                              DropdownButton<DepartmentModel>(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10.0),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            value: department.dropdownValue,
                                            onChanged:
                                                (DepartmentModel? value) async {
                                              if (value != null) {
                                                setState(() {
                                                  department.dropdownValue =
                                                      value;
                                                });
                                              }
                                            },
                                            items: department.departmentList
                                                .map<
                                                        DropdownMenuItem<
                                                            DepartmentModel>>(
                                                    (DepartmentModel value) {
                                              return DropdownMenuItem<
                                                  DepartmentModel>(
                                                value: value,
                                                child:
                                                    Text(value.departmentName),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        style: const TextStyle(fontSize: 18.0),
                                        decoration: const InputDecoration(
                                          label: Text('ID no. or Name'),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.grey,
                                              width: 1.0,
                                            ),
                                          ),
                                          isDense: true,
                                          contentPadding: EdgeInsets.fromLTRB(
                                              12.0, 12.0, 12.0, 12.0),
                                        ),
                                        controller: idController,
                                        onSubmitted: (data) async {
                                          selfies.changeLoadingState(true);
                                          await Future.delayed(
                                              const Duration(seconds: 1));
                                          if (idController.text.isEmpty) {
                                            // get records all
                                            await selfies.getSelfiesAll(
                                                department.dropdownValue);
                                          } else {
                                            // get records with id or name
                                            await selfies.getSelfies(
                                                idController.text.trim(),
                                                department.dropdownValue);
                                          }
                                          selfies.changeLoadingState(false);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5.0),
                                SizedBox(
                                  height: 30.0,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        '24 Hour format: ',
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      ValueListenableBuilder(
                                        valueListenable: is24HourFormat,
                                        builder: (_, value, __) {
                                          return Checkbox(
                                            value: is24HourFormat.value,
                                            onChanged: (newCheckboxState) {
                                              is24HourFormat.value =
                                                  newCheckboxState!;
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                Container(
                                  color: Colors.green[300],
                                  width: double.infinity,
                                  height: 40.0,
                                  child: TextButton(
                                    onPressed: () async {
                                      selfies.changeLoadingState(true);
                                      await Future.delayed(
                                          const Duration(seconds: 1));
                                      await selfies.getSelfiesAll(
                                          department.dropdownValue);
                                      selfies.changeLoadingState(false);
                                    },
                                    child: const Text(
                                      'View',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (selfies.selfieList.isNotEmpty) ...[
                        for (int i = 0; i < selfies.uiList.length; i++) ...[
                          Container(
                            height: 120.0,
                            color: i % 2 == 0 ? null : Colors.grey[300],
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      width: 200.0,
                                      // color: Colors.green,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text('Date: '),
                                          Text(
                                            DateFormat.yMMMEd()
                                                .format(selfies.uiList[i].date),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style:
                                                const TextStyle(fontSize: 13.0),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 150.0,
                                      // color: Colors.blue,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text('ID No: '),
                                          Text(
                                            selfies.uiList[i].employeeId,
                                            style:
                                                const TextStyle(fontSize: 13.0),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5.0),
                                SizedBox(
                                  width: 400.0,
                                  // color: Colors.red,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text('Name: '),
                                      Text(
                                        '${selfies.uiList[i].lastName}, ${selfies.uiList[i].firstName} ${selfies.uiList[i].middleName}',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: const TextStyle(fontSize: 13.0),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 2.5),
                                const Divider(height: 5.0),
                                const SizedBox(height: 2.5),
                                LogsWidget(
                                    logs: selfies.uiList[i].logs, index: i)
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: 25.0),
                        if (selfies.uiList.length <
                            selfies.selfieList.length) ...[
                          SizedBox(
                            height: 50.0,
                            width: 180.0,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.green[300],
                              ),
                              onPressed: () {
                                if (selfies.uiList.length <
                                    selfies.selfieList.length) {
                                  selfies.loadMore();
                                }
                              },
                              child: const Text(
                                'Load more..',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15.0),
                        ],
                        Text(
                          'Showing ${selfies.uiList.length} out of ${selfies.selfieList.length} results.',
                          style: const TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        const SizedBox(height: 50.0),
                      ] else if (selfies.selfieList.isEmpty) ...[
                        const SizedBox(height: 25.0),
                        if (selfies.selectedFrom
                            .isAfter(selfies.selectedTo)) ...[
                          const Text(
                            'Date From is advance than Date To.',
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ] else ...[
                          const Text(
                            'No data found.',
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ],
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
