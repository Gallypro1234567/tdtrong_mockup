import 'package:http/http.dart' as http;

class Connector {
  static String soapEndpoint =
      'http://197.218.5.3:8520/BCCSGateway/BCCSGateway?wsdl';
  static String soapAction = '';
  static String strSOAP(String base64, String fileName) {
    return '''
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:web="http://webservice.bccsgw.viettel.com/">
      <soapenv:Header/>
      <soapenv:Body>
      <web:gwOperation>
      <Input>
      <wscode>uploadImageByString</wscode>
      <username>d609baa5ba374a7e89f74f99c33ad761</username>
      <password>09671efad19a4d85f2960fde2812339e</password>
      <param name="location" value="en_US"/>
      <rawData><![CDATA[<ws:uploadImageByString>
      <image>$base64</image>
      <lv1Dir>FingerPrint</lv1Dir>
      <folderName>BACKUP</folderName>
      <fileName>$fileName.wsq</fileName>
      </ws:uploadImageByString>
      ]]></rawData>
      </Input>
      </web:gwOperation>
      </soapenv:Body>
      </soapenv:Envelope>
  ''';
  }

  static Future<Result<bool>> post(
      {required String imageBase64, required String fileName}) async {
    try {
      final response = await http.post(
        Uri.parse(soapEndpoint),
        headers: {
          'Content-Type': 'application/soap+xml',
          //'SOAPAction': soapAction,
        },
        body: strSOAP(imageBase64, fileName),
      );

      if (response.statusCode == 200) {
        return Result(
            result: response.body.contains('<errorCode>0</errorCode>'));
      } else {
        return Result(httpMessage: 'Đã xảy ra lỗi: ${response.statusCode}');
      }
    } on Exception catch (e) {
      return Result(httpMessage: e.toString());
    }
  }
}

class Result<T> {
  Result({this.httpMessage, this.result, this.header});
  final T? result;
  bool get success => result != null;
  final dynamic httpMessage;
  final Map<String, dynamic>? header;
  String get message {
    try {
      if (httpMessage is List) {
        return httpMessage.first;
      }
      return httpMessage ?? (result != null ? '' : 'Unknown error');
    } catch (e) {
      return httpMessage.toString();
    }
  }
}
