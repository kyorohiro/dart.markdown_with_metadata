import 'package:markdown_with_metadata/markdown.dart';
import 'dart:async';
import 'dart:convert' as conv;

Future<Null> main() async {
  HtmlAndMetadata data = await createHtml(
      "---\r\n"
      "title : The Game of life\r\n"
      "author : Yamada tarou\r\n"
      "about :\r\n"
      " Hello, World!!\r\n"
      " You can write multiple line in metadata\r\n"
      "---\r\n"
      "# test\r\n"
      "Game programming\r\n");

  print(conv.JSON.encode(data.metadata));
  print(data.html);
}
