# Markdown + metadata

A library for Dart developers.


# license

CC0

https://creativecommons.org/share-your-work/public-domain/cc0/


## Usage

```
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

```

```
{"title":"The Game of life","author":"Yamada tarou","about":"\r\nHello, World!!\r\nYou can write multiple line in metadata"}
<h1>test</h1>
<p>Game programming</p>
```

