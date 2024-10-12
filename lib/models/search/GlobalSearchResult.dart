import 'AuthorData.dart';
import 'CollectionData.dart';
import 'PoemData.dart';
import 'SentenceData.dart';

class GlobalSearchResult {
  String type; // 'author', 'poem', 'collection', 'sentence'
  AuthorData? authorData;
  PoemData? poemData;
  CollectionData? collectionData;
  SentenceData? sentenceData;

  GlobalSearchResult.author(this.authorData) : type = 'author';
  GlobalSearchResult.poem(this.poemData) : type = 'poem';
  GlobalSearchResult.collection(this.collectionData) : type = 'collection';
  GlobalSearchResult.sentence(this.sentenceData) : type = 'sentence';
}
