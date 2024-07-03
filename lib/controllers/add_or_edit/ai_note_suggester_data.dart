import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inkwell/localization/local.dart';

import '../../models/category.dart';
import '../../services/ai_suggest.dart';

/// مزيج يقدم اقتراحات تعتمد على الذكاء الاصطناعي لفئات العناوين والملاحظات.
mixin AiNoteSuggesterData {
  /// خدمة تقديم الاقتراحات من الذكاء الاصطناعي.
  final AiSuggesterService aiSuggesterService = AiSuggesterService();

  /// ذاكرة تخزين مؤقتة لنتائج استفسارات الذكاء الاصطناعي.
  final Map<String, String> _cache = {};

  /// استرجاع نص مترجم مع معلمات اختيارية.
  String _getLocalizedString(String key, [Map<String, String>? params]) {
    String translated = key.tr;
    if (params != null) {
      params.forEach((paramKey, paramValue) {
        translated = translated.replaceAll('{$paramKey}', paramValue);
      });
    }
    return translated;
  }

  /// بناء استفسار الذكاء الاصطناعي للاقتراحات الفئوية.
  String _constructCategoryAIQuery(
      String aiSuggestItem, RxList<Category> categories) {
    final categoryJson = categories.value
        .map((category) => '${category.name}: ${category.toJson()}')
        .join('\n');
    return _getLocalizedString('categoryPrompt',
        {'categoryJson': categoryJson, 'aiSuggestItem': aiSuggestItem});
  }

  /// الحصول على استجابة الذكاء الاصطناعي للاقتراحات الفئوية.
  Future<String> getAICategoryResponse(
      String aiResponse, RxList<Category> categories) async {
    final categoryQuery = _constructCategoryAIQuery(aiResponse, categories);
    return _handleTheSuggester(await _getCachedResponse(categoryQuery));
  }

  /// بناء استفسار الذكاء الاصطناعي للاقتراحات العنوانية.
  String _constructTitleAIQuery(String aiResponse) {
    return _getLocalizedString('titlePrompt', {'aiResponse': aiResponse});
  }

  /// الحصول على استجابة الذكاء الاصطناعي للاقتراحات العنوانية.
  Future<String> getAITitleResponse(String aiResponse) async {
    final titleQuery = _constructTitleAIQuery(aiResponse);
    return _handleTheSuggester(await _getCachedResponse(titleQuery));
  }

  /// بناء استفسار الذكاء الاصطناعي للاقتراحات المحتوى.
  String _constructAIQuery(TextEditingController titleController) {
    return _getLocalizedString(
        'aiQueryPrompt', {'titleControllerText': titleController.text});
  }

  /// الحصول على استجابة الذكاء الاصطناعي للاقتراحات المحتوى.
  Future<String> getAIContentResponse(
      TextEditingController titleController) async {
    final aiQuery = _constructAIQuery(titleController);
    return _handleTheSuggester(await _getCachedResponse(aiQuery));
  }

  /// بناء استفسار الذكاء الاصطناعي للاقتراحات الكلمات المفتاحية.
  String _constructKeywordsAIQuery(String aiResponse) {
    return '''
    Based on the following content:
    "$aiResponse"

    Please generate a set of up to 10 relevant keywords. These keywords should capture the main ideas and themes of the content.

    Return only the keywords, separated by commas, without any additional text or explanation.
    ''';
  }

  /// الحصول على استجابة الذكاء الاصطناعي للاقتراحات الكلمات المفتاحية.
  Future<String> getAIKeywordsResponse(String aiResponse) async {
    final keywordsQuery = _constructKeywordsAIQuery(aiResponse);
    return _handleTheSuggester(await _getCachedResponse(keywordsQuery));
  }

  /// بناء استفسار الذكاء الاصطناعي للاقتراحات التلميحات.
  String _constructHintAIQuery(String aiResponse) {
    return '''
    Based on the following content:
    "$aiResponse"

    Please generate a helpful hint or insight that would be useful to someone reading this content. The hint should:
    1. Be no longer than 20 words
    2. Provide a valuable takeaway or tip
    3. Be directly related to the content

    Return only the hint, without any additional text or explanation.
    ''';
  }

  /// الحصول على استجابة الذكاء الاصطناعي للاقتراحات التلميحات.
  Future<String> getAIHintResponse(String aiResponse) async {
    final hintQuery = _constructHintAIQuery(aiResponse);
    return _handleTheSuggester(await _getCachedResponse(hintQuery));
  }

  /// الحصول على استجابة الذكاء الاصطناعي للاقتراحات علامات العنوان.
  Future<String> getAITitleTagResponse(String aiResponse) async {
    final titleTagQuery = _constructTitleAIQuery(aiResponse);
    return _handleTheSuggester(await _getCachedResponse(titleTagQuery));
  }

  /// الحصول على الاستجابة المؤقتة لاستفسار معين، أو طلب جديد إذا لم يكن مخزناً مؤقتاً.
  Future<String> _getCachedResponse(String query) async {
    if (_cache.containsKey(query)) {
      return _cache[query]!;
    }
    final response = await aiSuggesterService.suggestItems(query, []);
    _cache[query] = response;
    return response;
  }

  /// الحصول على استجابة الذكاء الاصطناعي للاقتراحات الخلفية.
  Future<String> getAIBackgroundResponse(String aiResponse) async {
    final backgroundQuery = _constructBackgroundAIQuery(aiResponse);
    final responseTitle =
        await aiSuggesterService.suggestItems(backgroundQuery, []);
    return _handleTheSuggester(responseTitle.toString().trim());
  }

  /// معالجة استجابة مقترح الذكاء الاصطناعي لتنظيف الأحرف غير المرغوب فيها.
  String _handleTheSuggester(String suggester) {
    return suggester
        .replaceAll('json', '')
        .replaceAll('```', '')
        .replaceAll('##', '')
        .replaceAll('**', '');
  }

  /// بناء استفسار الذكاء الاصطناعي للاقتراحات الخلفية.
  String _constructBackgroundAIQuery(String aiResponse) {
    return _getLocalizedString('backgroundPrompt', {'aiResponse': aiResponse});
  }

  /// بناء استفسار الذكاء الاصطناعي للاقتراحات قائمة المراجعة.
  String _constructCheckListAIQuery(String aiResponse) {
    String checkListPrompt =
        _getLocalizedString(L10n.checklistPrompt, {'aiResponse': aiResponse});
    print('this is the check list message : ${checkListPrompt}');
    return checkListPrompt;
  }

  /// الحصول على استجابة الذكاء الاصطناعي للاقتراحات قائمة المراجعة.
  Future<List<String>> getAICheckListResponse(String aiResponse) async {
    final checkListQuery = _constructCheckListAIQuery(aiResponse);
    print('هذه هي الاستجابة القائمة: $checkListQuery');
    return List<String>.from(jsonDecode(checkListQuery));
  }
}
