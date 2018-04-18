library markd;
import 'package:markdown/markdown.dart' as markd;
import 'package:tiny_parser/parser.dart' as pars;
import 'package:tiny_parser/regex.dart' as reg;

import 'dart:convert' as conv;
import 'dart:async';

Future<HtmlAndMetadata> createHtml(String markdownSrc, {
    Iterable<markd.BlockSyntax> blockSyntaxes,
    Iterable<markd.InlineSyntax> inlineSyntaxes,
    markd.ExtensionSet extensionSet,
    markd.Resolver linkResolver,
    markd.Resolver imageLinkResolver,
    bool inlineOnly: false}) async {

  //
  //
  HtmlAndMetadata markdownData = new HtmlAndMetadata();
  markdownData.src = markdownSrc;

  Metadata meta = await Metadata.create(markdownSrc);
  markdownData.metadata = meta.metadata;

  //
  //
  markdownData.html = markd.markdownToHtml(meta.content,
    blockSyntaxes: blockSyntaxes,
    inlineSyntaxes: inlineSyntaxes,
    extensionSet: extensionSet,
    linkResolver: linkResolver,
    imageLinkResolver: imageLinkResolver,
    inlineOnly: inlineOnly
  );
  return markdownData;
}

class HtmlAndMetadata {
  String src;
  String html;
  Map<String, String> metadata;
}

class Metadata {
  pars.ParserByteBuffer reader;
  pars.TinyParser parser;
  Map<String,String> metadata = {};
  String content = "";
  reg.RegexParser regexParser = new reg.RegexParser();
  reg.RegexVM spaceVM = new reg.RegexVM.createFromPattern("( )*|(\t)*");
  reg.RegexVM crlfVM = new reg.RegexVM.createFromPattern("(\r\n)|(\n)");

  static Future<Metadata> create(String source) async{
    Metadata metadata = new Metadata();
    await metadata.parse(source);
    return metadata;
  }

  Future<int> parse(String source) async {
    content = source;
    reader = new pars.ParserByteBuffer();
    parser = new pars.TinyParser(reader);
    reader.addBytes(conv.UTF8.encode(source));
    reader.loadCompleted = true;
    int ret = await eMetadata(parser);
    content = source.substring(ret);
    return ret;
  }

  Future<int> eMetadata(pars.TinyParser parser) async {
    try {
      parser.push();

      //
      // --- (space) crlf
      await parser.nextString("---");await eSpace(parser);await eCrlf(parser);
      //
      do{
        // <xxx> (space) : (space) <yyy> crlf
        await eKeyValue(parser);
      } while(0 == await parser.checkString("---"));

      //
      // --- (space) crlf
      await parser.nextString("---");await eSpace(parser);await eCrlf(parser);

      parser.pop();
      return parser.index;
    } catch(e) {
      parser.back();
      parser.pop();
      return parser.index;
    }
  }

  Future<bool> eKeyValue(pars.TinyParser parser) async {
    String k = await eKey(parser);
    await parser.nextString(":");await eSpace(parser);
    var v = await eValue(parser);
    await eSpace(parser);
    await eCrlf(parser);
    metadata[k.trim()] = v;
  }

  Future<String> eKey(pars.TinyParser parser) async {
    int start = parser.index;
    int end = parser.index;
    if(0!=await parser.checkString(" ")) {
      throw "";
    }
    List<int> v = await parser.matchBytesFromBytes(conv.UTF8.encode(":\n"), expectedMatcherResult: false);
    return conv.UTF8.decode(v, allowMalformed: true);
  }

  Future<String> eValue(pars.TinyParser parser) async {
    List<int> v = await parser.matchBytesFromBytes(conv.UTF8.encode("\r\n"), expectedMatcherResult: false);
    String ret = conv.UTF8.decode(v);

    if((0 != await parser.checkString("\r\n ") || 0 != await parser.checkString("\r\n\t"))) {
      return ret + await eCrlf(parser) + (await eSpace(parser)?"":"") + await eValue(parser);
    }
    else {
      return ret;
    }
  }

  Future<String> eCrlf(pars.TinyParser parser) async {
    List<List<int>> ret =  await crlfVM.lookingAtFromEasyParser(parser);
    return (ret[0].length == 1 ? "\n" : "\r\n");
  }

  Future<bool> eSpace(pars.TinyParser parser) async {
    try {
      await spaceVM.lookingAtFromEasyParser(parser);
      return true;
    } catch(e) {
      return false;
    }
  }
}