import 'AuthorData.dart';
import 'CollectionData.dart';
import 'PoemData.dart';
import 'SentenceData.dart';

// GlobalSearchResult.dart
class GlobalSearchResult {
  final String type;
  final AuthorData? authorData;
  final PoemData? poemData;
  final CollectionData? collectionData;
  final SentenceData? sentenceData;

  GlobalSearchResult.author(this.authorData)
      : type = 'author',
        poemData = null,
        collectionData = null,
        sentenceData = null;

  GlobalSearchResult.poem(this.poemData)
      : type = 'poem',
        authorData = null,
        collectionData = null,
        sentenceData = null;
  
  GlobalSearchResult.sentence(this.poemData)
      : type = 'sentence',
        authorData = null,
        collectionData = null,
        sentenceData = null;

  GlobalSearchResult.collection1(this.poemData)
      : type = 'collection1',
        authorData = null,
        collectionData = null,
        sentenceData = null;

  GlobalSearchResult.collection2(this.collectionData)
      : type = 'collection2',
        authorData = null,
        poemData = null,
        sentenceData = null;

  GlobalSearchResult.famousSentence(this.sentenceData)
      : type = 'famous_sentence',
        authorData = null,
        poemData = null,
        collectionData = null;
}
