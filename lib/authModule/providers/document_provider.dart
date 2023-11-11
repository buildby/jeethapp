import 'package:flutter/material.dart';
import 'package:jeeth_app/api.dart';
import 'package:jeeth_app/authModule/models/document_model.dart';
import 'package:jeeth_app/http_helper.dart';

class DocumentProvider extends ChangeNotifier {
  List<Doc> _documents = [];

  List<Doc> get documents => [..._documents];

  Future updateDriverDocuments({
    required int doc_id,
    required int driver_id,
    required Map body,
  }) async {
    try {
      final url =
          '${webApi['domain']}${endPoint['updateDriverDocument']}/$doc_id/$driver_id';
      final response =
          await RemoteServices.httpRequest(method: 'PUT', url: url, body: body);

      if (response['result'] == 'success') {
        if (doc_id == 0) {
          _documents.add(Doc(
              id: response['data']['id'],
              type: body['type'],
              filename: body['filename'],
              url: body['url']));
        } else {
          int i = _documents.indexWhere((element) => element.id == doc_id);
          if (i != -1) {
            _documents[i].url = body['url'];
            _documents[i].type = body['type'];
          }
        }
      }
      notifyListeners();
      return response;
    } catch (error) {
      return {'result': 'failure', 'message': 'failedToGetSignedUrl'};
    }
  }

  getDriverDocuments({required String driver_id}) async {
    try {
      final url =
          '${webApi['domain']}${endPoint['getDriverDocuments']}/$driver_id';
      final response =
          await RemoteServices.httpRequest(method: 'GET', url: url);

      if (response['result'] == 'success') {
        List<Doc> fetchedDocs = (response['data'] as List)
            .map((document) => Doc.jsonToDoc(document))
            .toList();
        _documents = fetchedDocs;
        notifyListeners();
      }
      return response;
    } catch (error) {
      return {
        'result': 'failure',
        'message': 'Failed to get driver documents',
      };
    }
  }
}
