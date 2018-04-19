import 'package:markdown_with_metadata/markdown.dart';
import 'dart:async';
import 'dart:convert' as conv;

Future<Null> main() async {
  HtmlAndMetadata data = await createHtml(
      "---\r\n"
      "a:b\r\n"
      "test:\r\n"
      " test\r\n"
      "---\r\n"
      "# test\r\n"
      "Game programming\r\n");

  print(conv.JSON.encode(data.metadata));
  print(data.html);
}

