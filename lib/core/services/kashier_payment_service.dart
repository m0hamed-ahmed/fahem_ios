import 'dart:convert';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/core/utils/dialogs.dart';
import 'package:fahem/presentation/features/kashier_payment_webview.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:http/http.dart' as http;

class KashierPaymentService {
  static const bool _isLive = true;

  // Test
  static const String _testBaseUrl = 'https://test-api.kashier.io/';
  static const String _testMerchantId = 'MID-21812-892';
  static const String _testSecretKey = '7e9ce3275eed1c27bca7fc3102ba30f1\$fffca3081e859680a34e10c2968ce2740a5c9ebab12471ca55a93bf9aea5e3acbda5210e76437deb8f054ed8e2f9ae62';
  static String testKashierPaymentPageUrl({required String paymentRequestId}) => 'https://merchant.kashier.io/en/prepay/$paymentRequestId?mode=test';
  static const String _testPaymentRequestEndPoint = '${_testBaseUrl}paymentRequest?currency=EGP';
  static String _testGetInvoiceEndPoint({required String paymentRequestId}) => '${_testBaseUrl}paymentRequest/$paymentRequestId?currency=EGP';
  static String _testDeleteInvoiceEndPoint({required String paymentRequestId}) => '${_testBaseUrl}paymentRequest/$_testMerchantId/$paymentRequestId';

  // Live
  static const String _liveBaseUrl = 'https://api.kashier.io/';
  static const String _liveMerchantId = 'MID-21290-325';
  static const String _liveSecretKey = 'e0bddc045105839bab7c8c4e80fefc38\$6d4dd4c042f2844ed1f97241f74e85c57c96a9a18eb2d044e8d02ccf083d30ce21285dcbf0914573e0e680e5d2a1e6b6';
  static String liveKashierPaymentPageUrl({required String paymentRequestId}) => 'https://merchant.kashier.io/en/prepay/$paymentRequestId?mode=live';
  static const String _livePaymentRequestEndPoint = '${_liveBaseUrl}paymentRequest?currency=EGP';
  static String _liveGetInvoiceEndPoint({required String paymentRequestId}) => '${_liveBaseUrl}paymentRequest/$paymentRequestId?currency=EGP';
  static String _liveDeleteInvoiceEndPoint({required String paymentRequestId}) => '${_liveBaseUrl}paymentRequest/$_liveMerchantId/$paymentRequestId';

  static Future<String?> createInvoice({required String customerName, required int totalAmount}) async {
    String? result;
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': _isLive ? _liveSecretKey : _testSecretKey,
      };
      Map<String, dynamic> body = {
        'paymentType': 'simple',
        'customerName': customerName,
        'totalAmount': totalAmount,
      };

      final http.Response response = await http.post(
        Uri.parse(_isLive ? _livePaymentRequestEndPoint : _testPaymentRequestEndPoint),
        headers: headers,
        body: json.encode(body),
      );

      Map<String, dynamic> jsonData = json.decode(response.body);
      if(response.statusCode == 200) {
        String paymentRequestId = jsonData['response']['paymentRequestId'];
        debugPrint('Create Invoice: $paymentRequestId');
        result = paymentRequestId;
      }
      else {
        debugPrint('createInvoiceError: ${response.statusCode} / ${response.reasonPhrase}');
      }
    }
    catch(error) {
      debugPrint('createInvoiceCatchError: ${error.toString()}');
    }
    return result;
  }

  static Future<bool> isPaymentStatusPaid({required String paymentRequestId}) async {
    bool isSuccessPaid = false;
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': _isLive ? _liveSecretKey : _testSecretKey,
      };

      final http.Response response = await http.get(
        Uri.parse(_isLive ? _liveGetInvoiceEndPoint(paymentRequestId: paymentRequestId) : _testGetInvoiceEndPoint(paymentRequestId: paymentRequestId)),
        headers: headers,
      );

      Map<String, dynamic> jsonData = json.decode(response.body);
      if(response.statusCode == 200) {
        String paymentStatus = jsonData['response']['data'][0]['paymentStatus'];
        debugPrint('Payment Status: $paymentStatus');
        isSuccessPaid = paymentStatus == 'paid';
      }
      else {
        debugPrint('isPaymentStatusPaidError: ${response.statusCode} / ${response.reasonPhrase}');
      }
    }
    catch(error) {
      debugPrint('isPaymentStatusPaidCatchError: ${error.toString()}');
    }
    return isSuccessPaid;
  }

  static Future<bool> deleteInvoiceUnPaid({required String paymentRequestId}) async {
    bool isSuccessDelete = false;
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': _isLive ? _liveSecretKey : _testSecretKey,
      };

      final http.Response response = await http.delete(
        Uri.parse(_isLive ? _liveDeleteInvoiceEndPoint(paymentRequestId: paymentRequestId) : _testDeleteInvoiceEndPoint(paymentRequestId: paymentRequestId)),
        headers: headers,
      );

      Map<String, dynamic> jsonData = json.decode(response.body);
      if(response.statusCode == 200) {
        debugPrint('Delete Invoice');
        isSuccessDelete = jsonData['status'] == 'SUCCESS';
      }
      else {
        debugPrint('deleteInvoiceUnPaidError: ${response.statusCode} / ${response.reasonPhrase}');
      }
    }
    catch(error) {
      debugPrint('deleteInvoiceUnPaidCatchError: ${error.toString()}');
    }
    return isSuccessDelete;
  }

  static Future<void> chargeWallet({
    required BuildContext context,
    required String customerName,
    required int totalAmount,
    required Function onPaymentStatusPaid,
  }) async {
    await InternetConnectionChecker().hasConnection.then((hasConnection) async {
      if(hasConnection) {
        await createInvoice(customerName: customerName, totalAmount: totalAmount).then((paymentRequestId) {
          if(paymentRequestId != null) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => KashierPaymentScreen(
              pageLink: _isLive ? liveKashierPaymentPageUrl(paymentRequestId: paymentRequestId) : testKashierPaymentPageUrl(paymentRequestId: paymentRequestId),
            ))).then((value) async {
              await isPaymentStatusPaid(paymentRequestId: paymentRequestId).then((isSuccessPaid) async {
                if(isSuccessPaid) {
                  onPaymentStatusPaid();
                }
                else {
                  await deleteInvoiceUnPaid(paymentRequestId: paymentRequestId);
                }
              });
            });
          }
        });
      }
      else {
        Dialogs.failureOccurred(context, LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
      }
    });
  }
}