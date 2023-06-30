import 'dart:async';
import 'dart:convert';
import 'package:finance_user/functions/variables.dart';
import 'package:finance_user/screen/drawer.dart';
import 'package:finance_user/screen/report.dart';
import 'package:flutter/material.dart';
import 'package:finance_user/color_and_styles.dart';
import 'package:lottie/lottie.dart';
import 'b_details.dart';
import 'collection.dart';
import 'loan.dart';
import 'package:http/http.dart' as http;
import 'l_detail.dart';

class borrower extends StatefulWidget {
  const borrower({super.key});

  @override
  State<borrower> createState() => _borrowerState();
}

class _borrowerState extends State<borrower> {
  bool _isLoading = true;
  bool show_img = true;

  @override
  void initState() {
    fetch_borrower().whenComplete(() {
      setState(() {
        Timer(Duration(seconds: 1), () {
          setState(() {
            _isLoading = false;
          });
          setState(() {
            if (datas!.length == 0) {
              show_img = true;
            } else {
              show_img = false;
            }
            print(datas!.length);
          });
        });
      });
    });
    super.initState();
  }

  Future<void> refresh() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {});
  }

  var user = "Hello";
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Borrower"),
          // centerTitle: true,
          backgroundColor: first,
        ),
        drawer: drawer(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: first,
          child: const Icon(
            Icons.add_box,
            size: 30,
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => b_detail(),
                ));
          },
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(color: first),
              )
            : show_img
                ? Center(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'Assets/not_found.json',
                        width: 300,
                        height: 300,
                        fit: BoxFit.cover,
                      ),
                      Text(
                        "No Borrower's Found!",
                        style: TextStyle(
                            fontSize: 17,
                            color: first,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ))
                : Center(
                    child: SizedBox(
                        width: size.width * 0.9,
                        child: RefreshIndicator(
                          color: first,
                          onRefresh: ((() => refresh())),
                          child: ListView.builder(
                              itemCount: datas!.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    SizedBox(height: size.height * 0.02),
                                    Card(
                                      elevation: 5,
                                      child: Container(
                                        padding:
                                            EdgeInsets.all(size.width * 0.025),
                                        color: Colors.grey[300],
                                        child: Column(children: [
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: size.width * 0.4,
                                                child: Text(
                                                    "Name : " +
                                                        datas![index]
                                                            ['borrowerName'],
                                                    style: loan_details_design),
                                              ),
                                              SizedBox(
                                                width: size.width * 0.4,
                                                child: Text(
                                                    "Area : " +
                                                        datas![index]['area']
                                                            .toString(),
                                                    style: loan_details_design),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: size.height * 0.01,
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: size.width * 0.4,
                                                child: Text(
                                                    "Refer By : " +
                                                        datas![index]
                                                                ['referredBy']
                                                            .toString(),
                                                    style: loan_details_design),
                                              ),
                                              SizedBox(
                                                width: size.width * 0.4,
                                                child: Text(
                                                    "ID Proof: " +
                                                        datas![index]['IdProof']
                                                            .toString(),
                                                    style: loan_details_design),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: size.height * 0.01,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                child: Text(
                                                    "Mobile : " +
                                                        datas![index]
                                                                ['mobileNumber']
                                                            .toString(),
                                                    style: loan_details_design),
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
                                              CircleAvatar(
                                                  radius: size.width * 0.08,
                                                  backgroundColor:
                                                      Colors.green[400],
                                                  child: Icon(Icons.person)),
                                              CircleAvatar(
                                                radius: size.width * 0.08,
                                                backgroundColor:
                                                    Colors.green[400],
                                                child: Icon(Icons.person),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: size.height * 0.01,
                                          ),
                                        ]),
                                      ),
                                    )
                                  ],
                                );
                              }),
                        ))));
  }
}
