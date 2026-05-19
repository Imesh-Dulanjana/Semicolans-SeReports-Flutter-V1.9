import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';
import 'package:sereports/constants.dart';
import 'package:sereports/utils/interceptor.dart';

class ApiException implements Exception {
  ApiException(this.errorMessage);

  String errorMessage;

  @override
  String toString() => errorMessage;
}

class LoginResult {
  final bool success;
  final String? token;
  final String? errorMessage;

  const LoginResult({
    required this.success,
    this.token,
    this.errorMessage,
  });

  const LoginResult.ok(String token)
      : success = true,
        token = token,
        errorMessage = null;

  const LoginResult.fail(String message)
      : success = false,
        token = null,
        errorMessage = message;
}

class Api {
  // =============================================================
  // AUTH APIs (RAILWAY)
  // =============================================================

  static String loginUrl = "${authBaseUrl}auth/login";
  static String userPermissions = "${authBaseUrl}auth/user-permissions";

  // =============================================================
  // REAL DATA APIs (PRODUCTION DATABASE)
  // =============================================================

  static String companyName = "${dataBaseUrl}user/get-user-details";

  static String getSupplierNameList =
      "${dataBaseUrl}suppliers/get-all-suppliers-name-list";

  static String getSupplierDetails =
      "${dataBaseUrl}suppliers/supplier-details";

  static String getCreditorDetailsList =
      "${dataBaseUrl}suppliers-creditor/get-creditor-details-list";

  static String getSupplierPayableList =
      "${dataBaseUrl}suppliers/payable-details";

  static String getCustomerDetails =
      "${dataBaseUrl}customers/get-customers-details";

  static String getCustomerDebitors =
      "${dataBaseUrl}customers/get-debtor-details";

  static String getCustomerRecivables =
      "${dataBaseUrl}receivables/receivable-details";

  static String getBankNameList =
      "${dataBaseUrl}bank-details/get-all-bank-names";

  static String getBankDetails =
      "${dataBaseUrl}bank-details/get-all-bank-details";

  static String getBankTransactions =
      "${dataBaseUrl}banking/bank-transaction-details";
    return Uri