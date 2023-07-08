// ignore_for_file: camel_case_types, non_constant_identifier_names, unused_local_variable, no_leading_underscores_for_local_identifiers
import 'dart:async';

import 'package:finance_user/screen/bottom_sheet.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../color_and_styles.dart';
import '../functions/variables.dart';
import 'dilogue.dart';

class collectionwidget extends StatefulWidget {
  final String loanformate;
  const collectionwidget({super.key, required this.loanformate});

  @override
  State<collectionwidget> createState() => _collectionwidgetState();
}

class _collectionwidgetState extends State<collectionwidget> {
  bool once = true;
  List<dynamic> FinanceArea = [[]];
  Map FinanceLoan = {};
  List<dynamic> jlist = [];
  List<dynamic> LoanUserData = [];
  List<dynamic> LoanCompletedata = [];

  GetArea() async {
    FinanceLoan = {};
    try {
      http.Response res = await http.post(
        Uri.parse('$ip/collection/GetAreaDaily'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          <String, String>{
            "LoanType": widget.loanformate,
          },
        ),
      );
      if (res.statusCode == 200) {
        if (mounted) {
          setState(() {
            FinanceArea = json.decode(res.body);
            for (var element in FinanceArea[0]) {
              if (FinanceLoan.containsKey([element["Area"]]) == false) {
                FinanceLoan[element["Area"]] = [[]];
                once = false;
              }
            }
            if (kDebugMode) {}
            // _streamController.add(FinanceArea);
          });
        }
        if (kDebugMode) {
          //  print(FinanceArea);
        }
      } else {
        if (kDebugMode) {
          print('A unknown error occured. code:${res.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  GetLoanDetail(String Area, String LoanType) async {
    try {
      http.Response res = await http.post(
        Uri.parse('$ip/collection/GetLoanDetails'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          <String, String>{
            "Area": Area,
            "Type": LoanType,
          },
        ),
      );
      if (res.statusCode == 200) {
        if (mounted) {
          setState(() {
            FinanceLoan[Area] = [];
            jlist = json.decode(res.body);
            FinanceLoan[Area].add(jlist[0]);
          });
        }
      } else {
        if (kDebugMode) {
          print('A unknown error occured. code:${res.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future LoanPayAmount(
      String LoanCode, String LoanPaidAmount, String AgentId) async {
    if (kDebugMode) {
      //  print(AgentId);
    }
    try {
      http.Response res = await http.post(
        Uri.parse('$ip/collection/PayAmount'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          <String, String>{
            "LoanCode": LoanCode,
            "LoanPaidAmount": LoanPaidAmount,
            "AgentId": AgentId,
          },
        ),
      );
      if (res.statusCode == 200) {
        if (mounted) {
          setState(() {});
        }
      } else {
        if (kDebugMode) {
          print('A unknown error occured. code:${res.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future GetLoanUserData(String LoanCode) async {
    final http.Response response = await http.post(
      Uri.parse('$ip/collection/GetLoanuserData'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'LoanCode': LoanCode,
        },
      ),
    );
    if (response.statusCode == 200) {
      setState(() {
        LoanUserData = jsonDecode(response.body);
      });
      if (kDebugMode) {
        //   print("LoanUserData:$LoanUserData");
      }
    }
  }

  GetLoanCompleteData(String LoanCode) async {
    final http.Response response = await http.post(
      Uri.parse('$ip/collection/GetLoanCompleteData'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'LoanCode': LoanCode,
        },
      ),
    );
    if (response.statusCode == 200) {
      setState(() {
        LoanCompletedata = jsonDecode(response.body);
      });
      if (kDebugMode) {
        //  print("LoanCompletedata:$LoanCompletedata");
      }
    }
  }

  GetLoanTotalEmi(String LoanType) async {
    final http.Response response = await http.post(
      Uri.parse('$ip/collection/GetLoanTotalEmi'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'LoanType': LoanType,
        },
      ),
    );
    if (response.statusCode == 200) {
      setState(() {
        LoanCompletedata = jsonDecode(response.body);
      });
      if (kDebugMode) {
        //  print("LoanCompletedata:$LoanCompletedata");
      }
    }
  }

  GetLoanTotalAmount(String LoanType) async {
    final http.Response response = await http.post(
      Uri.parse('$ip/collection/GetLoanTotalPaidAmount'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'LoanType': LoanType,
        },
      ),
    );
    if (response.statusCode == 200) {
      setState(() {
        LoanCompletedata = jsonDecode(response.body);
      });
      if (kDebugMode) {
        //  print("LoanCompletedata:$LoanCompletedata");
      }
    }
  }

  @override
  void initState() {
    GetArea();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * 0.9,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: FinanceArea[0].length,
        itemBuilder: (context, index) {
          var CollectionArea = FinanceArea[0][index];

          return Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              ExpansionPanelList.radio(
                expansionCallback: (panelIndex, isExpanded) {
                  if (kDebugMode) {
                    print(index);
                  }
                  if (kDebugMode) {
                    print(CollectionArea["Area"]);
                  }
                  gettingareaemi = CollectionArea["Area"];
                  if (kDebugMode) {
                    print("gettingareaemi:$gettingareaemi");
                  }
                  GetLoanDetail(CollectionArea["Area"], widget.loanformate);
                  if (kDebugMode) {
                    print("FinanceLoan:$FinanceLoan");
                  }
                },
                children: [
                  ExpansionPanelRadio(
                    canTapOnHeader: true,
                    value: CollectionArea["Area"],
                    headerBuilder: ((context, isExpanded) {
                      return Center(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(CollectionArea["Area"].toString()),
                              ),
                              // Text("600/700"),
                            ]),
                      );
                    }),
                    body: SingleChildScrollView(
                      child: Column(
                        children: [
                          StatefulBuilder(builder:
                              (BuildContext context, StateSetter setState) {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              itemCount:
                                  FinanceLoan[CollectionArea["Area"].toString()]
                                          [0]
                                      .length,
                              itemBuilder: (context, indexs) {
                                TextEditingController pay =
                                    TextEditingController();
                                final _focusNode = FocusNode();

                                return GestureDetector(
                                  onTap: () {
                                    var Lcode = FinanceLoan[
                                            CollectionArea["Area"].toString()]
                                        [0][indexs]["Lcode"];

                                    getdate(Lcode).whenComplete(() {
                                      GetLoanUserData(Lcode).whenComplete(() {
                                        newMethod(
                                            context,
                                            size,
                                            LoanUserData[0][0]["Name"]
                                                .toString(),
                                            LoanUserData[0][0]["Amount"]
                                                .toString(),
                                            LoanUserData[0][0]["Start"]
                                                .toString(),
                                            LoanUserData[0][0]["End"]
                                                .toString(),
                                            LoanUserData[0][0]["Due"]
                                                .toString(),
                                            (int.parse(LoanUserData[0][0]
                                                        ["Amount"]) -
                                                    LoanUserData[0][0]["Due"])
                                                .toString());
                                      });
                                    });
                                  },
                                  child: Card(
                                    elevation: 8,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Container(
                                        padding:
                                            EdgeInsets.all(size.width * 0.025),
                                        // width: size.width * 0.8,
                                        child: Column(
                                          children: [
                                            SizedBox(
                                                // width: size.width * 0.4,
                                                child: Text(
                                              "${FinanceLoan[CollectionArea["Area"].toString()][0][indexs]["Lcode"]} - ${FinanceLoan[CollectionArea["Area"].toString()][0][indexs]["Name"]}",
                                              style: c_text,
                                            )),
                                            SizedBox(
                                              height: size.height * 0.01,
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(
                                                    width: size.width * 0.3,
                                                    child: Text(
                                                      "Loan Amount : ${FinanceLoan[CollectionArea["Area"].toString()][0][indexs]["Amount"]}",
                                                      style: c_text,
                                                    )),
                                                SizedBox(
                                                    width: size.width * 0.3,
                                                    child: Text(
                                                      "Paid Amount : ${FinanceLoan[CollectionArea["Area"].toString()][0][indexs]["PaidAmount"]}",
                                                      style: c_text,
                                                    )),
                                                SizedBox(
                                                  width: size.width * 0.2,
                                                  height: size.height * 0.05,
                                                  child: TextFormField(
                                                    cursorColor: first,
                                                    controller: pay,
                                                    autofocus: true,
                                                    onFieldSubmitted: (value) {
                                                      if (kDebugMode) {
                                                        print(
                                                            "${FinanceLoan[CollectionArea["Area"].toString()][0][indexs]["Lcode"]}");
                                                      }
                                                      if (pay.text != "") {
                                                        var loancode = FinanceLoan[
                                                                CollectionArea[
                                                                        "Area"]
                                                                    .toString()]
                                                            [
                                                            0][indexs]["Lcode"];
                                                        LoanPayAmount(
                                                          loancode,
                                                          pay.text
                                                              .toString()
                                                              .trim(),
                                                          store
                                                              .read("id")
                                                              .toString(),
                                                        ).whenComplete(() {
                                                          this.setState(() {
                                                            showDialogue(
                                                                context,
                                                                "Paid Successful",
                                                                // ignore: prefer_interpolation_to_compose_strings
                                                                "${"Paid Amount : " + pay.text + ".00" + "\nPaid by : " + FinanceLoan[CollectionArea["Area"].toString()][0][indexs]["Name"]}\nPayment collected by : " +
                                                                    store.read(
                                                                        "Name"));
                                                            // GetArea();

                                                            GetLoanDetail(
                                                                CollectionArea[
                                                                        "Area"]
                                                                    .toString(),
                                                                widget
                                                                    .loanformate);
                                                          });
                                                          setState(() {
                                                            // GetArea();
                                                            GetLoanDetail(
                                                                CollectionArea[
                                                                        "Area"]
                                                                    .toString(),
                                                                widget
                                                                    .loanformate);
                                                          });
                                                          pay.clear();
                                                        });
                                                        if (kDebugMode) {
                                                          print(
                                                              "AreaData:${CollectionArea["Area"].toString()}");
                                                        }
                                                      } else {
                                                        if (kDebugMode) {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            const SnackBar(
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .vertical(
                                                                  top: Radius
                                                                      .circular(
                                                                          10.0),
                                                                ),
                                                              ),
                                                              content: Text(
                                                                  'Please Enter Amount!'),
                                                            ),
                                                          );
                                                        }
                                                      }
                                                    },
                                                    decoration: InputDecoration(
                                                      border: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          borderSide:
                                                              BorderSide(
                                                                  color:
                                                                      first)),
                                                      contentPadding:
                                                          const EdgeInsets.only(
                                                              left: 10),
                                                      // fillColor: first,
                                                      // filled: true
                                                    ),
                                                    keyboardType:
                                                        TextInputType.number,
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: size.height * 0.01,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                SizedBox(
                                                  width: size.width * 0.25,
                                                  child: Text(
                                                    "Per Day EMI : ${FinanceLoan[CollectionArea["Area"].toString()][0][indexs]["Emi"]}",
                                                    style: c_text,
                                                  ),
                                                ),
                                                SizedBox(
                                                    height: size.height * 0.035,
                                                    width: size.width * 0.25,
                                                    child: ElevatedButton(
                                                      style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all(first)),
                                                      onPressed: () {
                                                        // share_text(
                                                        //     "Rs. 100 Paid");
                                                      },
                                                      child: Row(
                                                        children: const [
                                                          Icon(
                                                            Icons.share,
                                                            size: 15,
                                                          ),
                                                          SizedBox(
                                                            width: 2,
                                                          ),
                                                          Text("Share"),
                                                        ],
                                                      ),
                                                    )),
                                                SizedBox(
                                                  width: size.width * 0.06,
                                                ),
                                                SizedBox(
                                                    height: size.height * 0.035,
                                                    width: size.width * 0.22,
                                                    child: ElevatedButton(
                                                      style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all(first)),
                                                      onPressed: () {
                                                        // FocusScope.of(context)
                                                        //     .unfocus();
                                                        // FocusScopeNode
                                                        //     currentFocus =
                                                        //     FocusScope.of(
                                                        //         context);
                                                        // if (!currentFocus
                                                        //     .hasPrimaryFocus) {
                                                        //   currentFocus
                                                        //       .focusedChild
                                                        //       ?.unfocus();
                                                        // }

                                                        if (kDebugMode) {
                                                          print(
                                                              "${FinanceLoan[CollectionArea["Area"].toString()][0][indexs]["Lcode"]}");
                                                        }
                                                        if (pay.text != "") {
                                                          var loancode = FinanceLoan[
                                                                  CollectionArea[
                                                                          "Area"]
                                                                      .toString()]
                                                              [
                                                              0][indexs]["Lcode"];
                                                          LoanPayAmount(
                                                            loancode,
                                                            pay.text
                                                                .toString()
                                                                .trim(),
                                                            store
                                                                .read("id")
                                                                .toString(),
                                                          ).whenComplete(() {
                                                            showDialogue(
                                                                context,
                                                                "Paid Successful",
                                                                "${"Paid Amount : " + pay.text + ".00" + "\nPaid by : " + FinanceLoan[CollectionArea["Area"].toString()][0][indexs]["Name"]}\nAmount collected by : " +
                                                                    store.read(
                                                                        "Name"));

                                                            this.setState(() {
                                                              // GetArea();

                                                              GetLoanDetail(
                                                                  CollectionArea[
                                                                          "Area"]
                                                                      .toString(),
                                                                  widget
                                                                      .loanformate);
                                                            });
                                                            setState(() {
                                                              // GetArea();
                                                              GetLoanDetail(
                                                                  CollectionArea[
                                                                          "Area"]
                                                                      .toString(),
                                                                  widget
                                                                      .loanformate);
                                                            });

                                                            pay.clear();
                                                          });
                                                          if (kDebugMode) {
                                                            print(
                                                                "AreaData:${CollectionArea["Area"].toString()}");
                                                          }
                                                        } else {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            const SnackBar(
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .vertical(
                                                                  top: Radius
                                                                      .circular(
                                                                          10.0),
                                                                ),
                                                              ),
                                                              content: Text(
                                                                  'Please Enter Amount!'),
                                                            ),
                                                          );
                                                        }
                                                      },
                                                      child: const Text("Pay"),
                                                    )),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
