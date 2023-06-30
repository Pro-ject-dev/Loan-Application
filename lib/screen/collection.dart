import 'dart:async';
import 'package:finance_user/color_and_styles.dart';
import 'package:finance_user/functions/variables.dart';
import 'package:finance_user/screen/collectionwidget.dart';
import 'package:finance_user/screen/constantapi.dart';
import 'package:finance_user/screen/drawer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'borrower.dart';
import 'loan.dart';
import 'report.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class collection extends StatefulWidget {
  const collection({super.key});

  @override
  State<collection> createState() => _collectionState();
}

// ignore: camel_case_types
class _collectionState extends State<collection> {
  var user = "Hello";
  var c_type = "Daily";
  bool collectionccheck = true;
  List<dynamic> LoanTotalEmi = [];
  List<dynamic> LoanTotalAmount = [];
  TextEditingController filter = TextEditingController(text: "Today");
  var TotalAmount = "0";
  var TotalEmi = "0";
  late Timer _timer;

  GetLoanTotalEmi() async {
    final http.Response response = await http.post(
      Uri.parse('$ip/collection/GetLoanTotalEmi'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'Type': c_type,
        },
      ),
    );
    if (response.statusCode == 200) {
      if (mounted) {
        setState(() {
          LoanTotalEmi = jsonDecode(response.body);
          // if (kDebugMode) {
          //   print(LoanTotalEmi[0][0]["Emi"]);
          // }
          if (LoanTotalEmi[0][0]["Emi"] == "" ||
              LoanTotalEmi[0][0]["Emi"] == "0" ||
              LoanTotalEmi[0][0]["Emi"] == "null" ||
              LoanTotalEmi[0][0]["Emi"] == null) {
            TotalEmi = "0";
          } else {
            TotalEmi = LoanTotalEmi[0][0]["Emi"].toString();
          }
        });
      }
      if (kDebugMode) {
        // print("LoanTotalEmi:$LoanTotalEmi");
      }
    }
  }

  GetLoanTotalAmount() async {
    final http.Response response = await http.post(
      Uri.parse('$ip/collection/GetLoanTotalPaidAmount'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'Type': c_type,
        },
      ),
    );
    if (response.statusCode == 200) {
      if (mounted) {
        setState(() {
          LoanTotalAmount = jsonDecode(response.body);
          // if (kDebugMode) {
          //   print(LoanTotalAmount[0][0]["Amount"]);
          // }
          if (LoanTotalAmount[0][0]["Amount"] == "" ||
              LoanTotalAmount[0][0]["Amount"] == "0" ||
              LoanTotalAmount[0][0]["Amount"] == "null" ||
              LoanTotalAmount[0][0]["Amount"] == null) {
            TotalAmount = "0";
          } else {
            TotalAmount = LoanTotalAmount[0][0]["Amount"].toString();
          }
        });
      }
      if (kDebugMode) {
        // print("LoanTotalAmount:$LoanTotalAmount");
      }
    }
  }

  @override
  void initState() {
    _timer = Timer.periodic(
        const Duration(seconds: 3), (timer) => GetLoanTotalEmi());

    _timer = Timer.periodic(
        const Duration(seconds: 3), (timer) => GetLoanTotalAmount());
    super.initState();
  }

  @override
  void dispose() {
    if (_timer.isActive) _timer.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: first),
        elevation: 1,
        title: Text(
          "Collection",
          style: TextStyle(color: first),
        ),
        // centerTitle: true,
        backgroundColor: second,
      ),
      drawer: drawer(),
      body: Scrollbar(
        interactive: true,
        thickness: 8.0,
        child: SingleChildScrollView(
          child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  SizedBox(
                    width: size.width * 0.9,
                    height: size.height * 0.05,
                    child: TextFormField(
                      readOnly: true,
                      cursorColor: first,
                      controller: filter,
                      decoration: InputDecoration(
                          hintText: "Pick a Date",
                          prefixIcon: const Icon(Icons.tune),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () {},
                          ),
                          contentPadding: const EdgeInsets.only(left: 10),
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: first),
                            borderRadius: BorderRadius.circular(10),
                          )),
                      keyboardType: TextInputType.datetime,
                      onTap: () async {
                        DateTime? d_pick = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(
                                  primary: first,
                                  onPrimary: Colors.white,
                                  onSurface: Colors.black,
                                ),
                                textButtonTheme: TextButtonThemeData(
                                  style: TextButton.styleFrom(
                                    primary: first,
                                  ),
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        var date = DateTime.parse(d_pick.toString());
                        var correct_format =
                            "${date.day}-${date.month}-${date.year}";

                        filter.text = correct_format;
                      },
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: size.height * 0.05,
                        width: size.width * 0.5,
                        child: RadioListTile(
                            activeColor: first,
                            value: "Daily",
                            title: const Text("Daily"),
                            groupValue: c_type,
                            onChanged: (select) {
                              setState(() {
                                if (c_type == 'Weekly') {
                                  collectionccheck = true;
                                }
                                if (kDebugMode) {
                                  print("Daily:$collectionccheck");
                                }
                                c_type = select!;
                                if (kDebugMode) {
                                  print(c_type);
                                }
                              });
                            }),
                      ),
                      SizedBox(
                        height: size.height * 0.05,
                        width: size.width * 0.5,
                        child: RadioListTile(
                            activeColor: first,
                            value: "Weekly",
                            title: const Text("weekly"),
                            groupValue: c_type,
                            onChanged: (select) {
                              setState(() {
                                if (c_type == 'Daily') {
                                  collectionccheck = false;
                                }
                                if (kDebugMode) {
                                  print("weekly:$collectionccheck");
                                }
                                c_type = select!;
                                if (kDebugMode) {
                                  print(c_type);
                                }
                              });
                            }),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Visibility(
                    visible: collectionccheck,
                    child: const collectionwidget(
                      loanformate: "Daily",
                    ),
                  ),
                  Visibility(
                    visible: !collectionccheck,
                    child: const collectionwidget(loanformate: "Weekly"),
                  ),
                  const SizedBox(
                    height: 2,
                  )
                ],
              )),
        ),
      ),
      bottomNavigationBar: Card(
          child: SizedBox(
        height: size.height * 0.07,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: size.width * 0.4,
              child: Text(
                "Total Target :  $TotalEmi",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: size.width * 0.4,
              child: Text(
                "Total Collection : $TotalAmount",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      )),
      floatingActionButton: ElevatedButton(
        onPressed: () async {
          await constantapi.CompleteCollection(TotalAmount).whenComplete(() {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => const borrower()));
          });
        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(first),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)))),
        child: const Text("Collection Complete"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

share_text(var s_text) async {
  // await Share.share("Hello, Welcome to Daily Thundal, $s_text");
}
