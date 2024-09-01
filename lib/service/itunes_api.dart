import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:itunes/models/itunes_model.dart';
import 'package:itunes/service/httpurls.dart';
import 'package:riverpod/riverpod.dart';

class ItunesApiServices {
  final http.Client client;

  ItunesApiServices({http.Client? client}) : client = client ?? http.Client();

  Future<SecurityContext> get globalContext async {
    final sslCert = await rootBundle.load('assets/ssl/itunes_cert.pem');
    SecurityContext securityContext = SecurityContext(withTrustedRoots: false);
    securityContext.setTrustedCertificatesBytes(sslCert.buffer.asInt8List());
    return securityContext;
  }

  Future<http.Client> getSSLPinningClient() async {
    HttpClient ioClient = HttpClient(context: await globalContext);
    ioClient.badCertificateCallback =
        (X509Certificate cert, String host, int port) => false;
    return IOClient(ioClient);
  }

  Future<ItunesModel> getItunesData(String searchTerm) async {
    final response = await client.get(Uri.parse(HttpUrl.baseUrl + searchTerm));
    if (response.statusCode == 200) {
      return ItunesModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.reasonPhrase);
    }
  }
}

final itunesApiProvider =
    Provider<ItunesApiServices>((ref) => ItunesApiServices());
