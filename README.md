# Markdown + metadata

A library for Dart developers.


# license

CC0

https://creativecommons.org/share-your-work/public-domain/cc0/


## Usage

```
import 'package:markdown_with_metadata/markdown.dart';

void main() {
    HtmlAndMetadata data = await createHtml(
      "---\r\n"
      "a:b\r\n"
      "test:test\r\n"
      "---\r\n"
      "# test\r\n"
      "Game programming\r\n");
    data.
}
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: http://example.com/issues/replaceme
