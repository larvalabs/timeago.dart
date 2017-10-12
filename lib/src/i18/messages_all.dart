library messages_all;

import 'dart:async';
import 'package:intl/message_lookup_by_library.dart';
import 'package:intl/src/intl_helpers.dart';
import 'package:intl/intl.dart';

import 'en_short_messages.dart' as en_short;
import 'es_messages.dart' as es;
import 'es_short_messages.dart' as es_short;
import 'fr_messages.dart' as fr;
import 'ja_messages.dart' as ja;
import 'zh_CN_messages.dart' as zh_cn;
import 'zh_messages.dart' as zh;

Map<String, Function> _deferredLibraries = {
  'en_short': () => en_short.loadLibrary(),
  'es': () => es.loadLibrary(),
  'es_short': () => es_short.loadLibrary(),
  'fr': () => fr.loadLibrary(),
  'ja': () => ja.loadLibrary(),
  'zh_CN': () => zh_cn.loadLibrary(),
  'zh': () => zh.loadLibrary()
};

MessageLookupByLibrary _findExact(localeName) {
  switch (localeName) {
    case 'en_short':
      return en_short.messages;
    case 'es':
      return es.messages;
    case 'es_short':
      return es_short.messages;
    case 'fr':
      return fr.messages;
    case 'ja':
      return ja.messages;
    case 'zh_CN':
      return zh_cn.messages;
    case 'zh':
    case 'zh_TW':
    case 'zh_HK':
      return zh.messages;
    default:
      return null;
  }
}

/// User programs should call this before using [localeName] for messages.
Future initializeMessages(String localeName) {
  initializeInternalMessageLookup(() => new CompositeMessageLookup());
  var canonicalizedLocale = Intl.canonicalizedLocale(localeName);
  var lib = _deferredLibraries[canonicalizedLocale];
  var load = lib == null ? new Future.value(false) : lib();

  return load.then(
      (_) => messageLookup.addLocale(localeName, _findGeneratedMessagesFor));
}

MessageLookupByLibrary _findGeneratedMessagesFor(locale) {
  var actualLocale = Intl.verifiedLocale(locale, (x) => _findExact(x) != null,
      onFailure: (_) => null);
  if (actualLocale == null) return null;
  return _findExact(actualLocale);
}
