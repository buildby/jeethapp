class Doc {
  final int id;
  String type;
  String filename;
  String url;

  Doc({
    required this.id,
    required this.type,
    required this.filename,
    required this.url,
  });

  static Doc jsonToDoc(Map document) => Doc(
        id: document['id'],
        type: document['type'] ?? '',
        filename: document['filename'] ?? '',
        url: document['url'] ?? '',
      );
}
