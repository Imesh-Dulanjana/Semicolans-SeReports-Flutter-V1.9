import 'dart:convert';
import 'dart:io';

import 'package:http_interceptor/http_interceptor.dart';
import 'package:sereports/constants.dart';
import 'package:sereports/utils/interceptor.dart';

class ApiException implements Exception {
  final String errorMessage;

  ApiException(this.errorMessage);

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
  // AUTH SERVER
  static String loginUrl = '${authBaseUrl}auth/login';

  static String userPermissions =
      '${authBaseUrl}auth/user-permissions';

  // DATA SERVER
  static String dashboardSummary =
      '${dataBaseUrl}dashboards/summary';

  static String getProductAll =
      '${dataBaseUrl}products/get-all-product';

  static String getCustomerDetails =
      '${dataBaseUrl}customers/get-customers-details';

  static String getSupplierDetails =
      '${dataBaseUrl}suppliers/supplier-details';

  static String getSalesSummary =
      '${dataBaseUrl}sales-summary/summary-details';

  static String getSalesDetails =
      '${dataBaseUrl}sales/sales-details';

  static String getPurchaseSummary =
      '${dataBaseUrl}purchase-summary/summary-details';

  static String getPurchaseDetails =
      '${dataBaseUrl}purchases/purchase-details';

  static String getIncomeExpensesDetails =
    '${dataBaseUrl}income-expenses/details';

static String companyName =
    '${dataBaseUrl}user/get-user-details';

static String getBankNameList =
    '${dataBaseUrl}bank-details/get-all-bank-names';

static String getBankDetails =
    '${dataBaseUrl}bank-details/get-all-bank-details';

static String getBankTransactions =
    '${dataBaseUrl}banking/bank-transaction-details';

static String getCategoryNameList =
    '${dataBaseUrl}categories/get-all-category-name-list';

static String getSubCategoryNameList =
    '${dataBaseUrl}sub-categories/get-all-sub-category-name-list';

static String getSupplierNameList =
    '${dataBaseUrl}suppliers/get-all-suppliers-name-list';

static String getCreditorDetailsList =
    '${dataBaseUrl}suppliers-creditor/get-creditor-details-list';

static String getSupplierPayableList =
    '${dataBaseUrl}suppliers/payable-details';

static String getCustomerDebitors =
    '${dataBaseUrl}customers/get-debtor-details';

static String getCustomerRecivables =
    '${dataBaseUrl}receivables/receivable-details';

static String lookupItemByBarcode =
    '${dataBaseUrl}invoice/item-lookup';

static String createInvoice =
    '${dataBaseUrl}invoice/create';

static String calculatePrice =
    '${dataBaseUrl}invoice/calculate-price';

static String checkPriceLink =
    '${dataBaseUrl}invoice/check-price-link';

static String lastInvPriceByCustomer =
    '${dataBaseUrl}invoice/last-inv-price-by-customer';

static String lastInvPriceByItem =
    '${dataBaseUrl}invoice/last-inv-price-by-item';

static String searchText = 'searchText';
static String categoryId = 'categoryId';

  static Future<LoginResult> loginCompany(
    String username,
    String password,
    String pinnumber,
  ) async {
    try {
      final response = await post(
        url: loginUrl,
        body: {
          'username': username,
          'password': password,
          'pinnumber': pinnumber,
        },
      );

      final token = response['token']?.toString();

      if (token != null && token.isNotEmpty) {
        return LoginResult.ok(token);
      }

      return const LoginResult.fail('Invalid login');
    } catch (e) {
      return LoginResult.fail(e.toString());
    }
  }

  static Future<Map<String, dynamic>> getUserPermissions() async {
    return await get(
      url: userPermissions,
      parameter: {},
    );
  }

  static Future<Map<String, dynamic>> get({
    required String url,
    required Map<String, dynamic> parameter,
  }) async {
    try {
      final interceptedHttp = InterceptedHttp.build(
        interceptors: [SeReportInterceptor()],
      );

      final response = await interceptedHttp.get(
        Uri.parse(url),
        params: parameter.map(
          (key, value) => MapEntry(key, value.toString()),
        ),
      );

      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(
          jsonDecode(response.body),
        );
      }

      throw ApiException(response.body);
    } on SocketException {
      throw ApiException('No Internet Connection');
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  static Future<Map<String, dynamic>> post({
    required String url,
    required Map<String, dynamic> body,
  }) async {
    try {
      final interceptedHttp = InterceptedHttp.build(
        interceptors: [SeReportInterceptor()],
      );

      final response = await interceptedHttp.post(
        Uri.parse(url),
        body: jsonEncode(body),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        return Map<String, dynamic>.from(
          jsonDecode(response.body),
        );
      }

      throw ApiException(response.body);
    } on SocketException {
      throw ApiException('No Internet Connection');
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}