import 'package:markdown_with_metadata/markdown.dart' as markd;
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {

    setUp(() {
    });
    test('meta data1', () async {
      markd.HtmlAndMetadata markdownData = await markd.createHtml(
          "---\r\n" // 0-5
          "a: b\r\n"  // 5-10
          "test:test\r\n" // 11-22
          "---\r\n"
          "# test\r\n"
          "Game programming\r\n");
      expect(markdownData.metadata["a"], "b");
      expect(markdownData.metadata["test"], "test");
      print(markdownData.html);
    });

    test('meta data2', () async {
      markd.HtmlAndMetadata markdownData = await markd.createHtml(
          "---\r\n" // 0-5
              "a:b\r\n"  // 5-10
              "test:test\r\n asdfasdf\r\n" // 11-22
              "---\r\n"
              "# test\r\n"
              "Game programming\r\n");
      expect(markdownData.metadata["a"], "b");
      expect(markdownData.metadata["test"], "test\r\nasdfasdf");
      print(markdownData.html);
    });
  });
}
