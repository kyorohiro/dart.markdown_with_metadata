import 'package:markdown_with_metadata/markdown.dart';
import 'dart:async';

Future<Null> main() async {
  HtmlAndMetadata data = await createHtml(
      "---\r\n"
          "a:b\r\n"
          "test:test\r\n"
          "---\r\n"
          "# test\r\n"
          "Game programming\r\n");
  for(String k in data.metadata.keys) {
    print("${k} : ${data.metadata[k]}");
  }
  print(data.html);
}
