import 'dart:async';
import 'dart:math';

import 'package:finance_user/screen/borrower.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';

List? datas;
List? datas1;

var store = GetStorage();

List actual_dt = [];
List? dates;
List alldates = [];
List Amt = [];

List b_list = [];
List l_list = [];

List bid_list = [];

List user_details = [];

List<List<dynamic>> report_data = [];
List<List<dynamic>> data_report = [];

var ip = "https://finan.com";

var duplicate;
insert_Borrow(
    String name, String area, String refer_by, String id, String mob_no) async {
  DateTime currentDate = DateTime.now();
  String formattedDate = DateFormat('dd-MM-yyyy').format(currentDate);
  http.Response res = await http.post(
    Uri.parse('$ip/AddBorrower'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(
      {
        "borrowerName": name,
        "borrowerCode": "1234",
        "area": area,
        "referredBy": refer_by,
        "IdProof": id,
        "mobileNumber": mob_no,
        "isActive": true,
        "createdBy": "1234",
      },
    ),
  );
  if (res.body == "Already Exist") {
    duplicate = "YES";
  } else {
    duplicate = "NO";
  }
}

Future fetch_borrower() async {
  final response = await http.get(Uri.parse('$ip/Borrower'));
  if (response.statusCode == 200) {
    datas = jsonDecode(response.body);
    print(datas);
  } else {
    throw Exception('Failed to load data');
  }
}

insert_Loan(
    String borrower_name,
    String borrower_id,
    String loan_amt,
    String start_dt,
    String end_dt,
    String type_loan,
    String Loanid,
    String del_amt) async {
  print(loan_amt);
  http.Response res = await http.post(
    Uri.parse('$ip/AddLoan'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(
      {
        "loanId": Loanid,
        "borrowerName": borrower_name,
        "borrowerID": borrower_id,
        "loanAmount": int.parse(loan_amt),
        "del_amt": int.parse(del_amt),
        "startDt": start_dt.toString(),
        "endDt": end_dt.toString(),
        "loanType": type_loan.toString(),
        "loanEMI": 0,
        "isActive": true,
        "createdBy": 123,
      },
    ),
  );
}

Future fetch_loan() async {
  final response = await http.get(Uri.parse('$ip/loan'));
  if (response.statusCode == 200) {
    datas1 = jsonDecode(response.body);
    print(datas1);
  } else {
    throw Exception('Failed to load data');
  }
}

Future getdate(String Loanid) async {
  http.Response res = await http.post(
    Uri.parse('$ip/getDate'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(
      {
        "loancode": Loanid,
      },
    ),
  );
  if (res.statusCode == 200) {
    actual_dt = [];
    dates = jsonDecode(res.body);
    for (var i = 0; i < dates!.length; i++) [actual_dt.add(dates![i]["Date"])];
    print(actual_dt);
  } else {
    throw Exception('Failed to load data');
  }
}

Future getAmt(String date, loanid) async {
  http.Response res = await http.post(
    Uri.parse('i$ip/getAmt'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(
      {
        "dt": date,
        "code": loanid,
      },
    ),
  );
  if (res.statusCode == 200) {
    Amt.add(jsonDecode(res.body));
  } else {
    throw Exception('Failed to load data');
  }
}

String generateCustomId() {
  var random = Random.secure();
  var id = '${random.nextInt(900000) + 100000}';
  return id;
}

Future pdf_report(date) async {
  http.Response res = await http.post(
    Uri.parse('$ip/report'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(
      {"today": date},
    ),
  );
  if (res.statusCode == 200) {
    report_data = [];
    data_report = [];
    report_data.add(jsonDecode(res.body));
    for (var i = 0; i < report_data[0].length; i++) {
      data_report.add(report_data[0][i]);
    }
    print(data_report);
  } else {
    throw Exception('Failed to load data');
  }
}

check_user(username) async {
  user_details = [];
  http.Response res = await http.post(
    Uri.parse('$ip/login'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(
      {"username": username},
    ),
  );
  if (res.body != "invalid") {
    user_details = jsonDecode(res.body);
  } else {}
}

String generateUniqueId() {
  DateTime now = DateTime.now();
  String formattedDate =
      '${now.year}${_twoDigits(now.month)}${_twoDigits(now.day)}${_twoDigits(now.hour)}${_twoDigits(now.minute)}${_twoDigits(now.second)}';
  return formattedDate;
}

String _twoDigits(int n) {
  if (n >= 10) return "$n";
  return "0$n";
}
