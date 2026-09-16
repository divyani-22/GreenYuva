import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/case.dart';
import '../utils/env_config.dart';
import '../utils/firebase_setup.dart';
import '../utils/populate_cases.dart';

class CaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const List<String> _climateKeywords = [
    'flood victim', 'drought victim', 'wildfire victim', 'hurricane victim',
    'landslide victim', 'tsunami victim', 'extreme weather victim',
    'climate refugee', 'environmental refugee', 'disaster victim',
    'lost home flood', 'lost home wildfire', 'lost home hurricane',
    'displaced by climate', 'climate migration', 'climate displacement'
  ];

  static const List<String> _excludeKeywords = [
    'climate policy', 'climate summit', 'climate agreement', 'climate conference',
    'climate scientist', 'climate research', 'climate study', 'climate report',
    'climate data', 'climate model', 'climate prediction', 'climate forecast'
  ];

  static Future<List<Case>> getCases() async {
    try {
      print('📰 CaseService: Fetching cases from Firebase...');
      final snapshot = await _firestore.collection('cases')
          .orderBy('date', descending: true)
          .limit(50)
          .get();

      final cases = snapshot.docs.map((doc) {
        final data = doc.data();
        return Case.fromJson({...data, 'id': doc.id});
      }).toList();

      print('✅ CaseService: Loaded ${cases.length} cases from Firebase');
      return cases;
    } catch (e) {
      print('❌ CaseService: Error fetching cases: $e');
      return [];
    }
  }

  static Future<List<Case>> getCasesWithFallback() async {
    try {
      print('📰 CaseService: Fetching cases with API fallback...');

      print('🔍 CaseService: Trying APIs first...');
      try {
        final newsApiCases = await _fetchFromNewsAPI();
        if (newsApiCases.isNotEmpty) {
          print('✅ CaseService: Fetched ${newsApiCases.length} cases from NewsAPI');

          for (final caseData in newsApiCases) {
            await _saveCaseToFirebase(caseData);
          }
          return newsApiCases;
        }
      } catch (e) {
        print('❌ CaseService: NewsAPI error: $e');
      }

      try {
        final gNewsCases = await _fetchFromGNews();
        if (gNewsCases.isNotEmpty) {
          print('✅ CaseService: Fetched ${gNewsCases.length} cases from GNews');

          for (final caseData in gNewsCases) {
            await _saveCaseToFirebase(caseData);
          }
          return gNewsCases;
        }
      } catch (e) {
        print('❌ CaseService: GNews error: $e');
      }

      print('⚠️ CaseService: APIs failed, trying Firebase...');
      final firebaseCases = await getCases();
      if (firebaseCases.isNotEmpty) {
        print('✅ CaseService: Found ${firebaseCases.length} cases in Firebase');
        return firebaseCases;
      }

      print('⚠️ CaseService: All sources failed, populating Firebase with sample data...');
      await populateFirebaseWithSampleCases();
      return await getCases();

    } catch (e) {
      print('❌ CaseService: Error in getCasesWithFallback: $e');
      return _createSampleCases();
    }
  }

  static Future<void> populateFirebaseWithSampleCases() async {
    try {
      print('🔥 CaseService: Populating Firebase with sample cases...');
      await PopulateCases.populateWithSampleCases();
      print('✅ CaseService: Successfully populated Firebase with sample cases');
    } catch (e) {
      print('❌ CaseService: Error populating Firebase: $e');
    }
  }

  static Future<void> addCaseToFirebase(Case caseData) async {
    try {
      await _firestore.collection('cases').add(caseData.toJson());
      print('✅ CaseService: Added case to Firebase: ${caseData.personName}');
    } catch (e) {
      print('❌ CaseService: Error adding case to Firebase: $e');
    }
  }

  static Future<void> fetchAndProcessNews() async {
    try {
      print('🔄 CaseService: Fetching climate victim news from APIs...');

      final cases = await _fetchFromNewsAPI();

      for (final caseData in cases) {
        await _saveCaseToFirebase(caseData);
      }

      print('✅ CaseService: Processed and saved ${cases.length} cases from API');
    } catch (e) {
      print('❌ CaseService: Error fetching news: $e');
    }
  }

    static List<Case> _createSampleCases() {
    return [
      Case(
        id: 'case_1',
        personName: 'Dr. Roxy Mathew Koll',
        story: 'Indian Ocean warming, marine heatwaves, and changing monsoon rainfall extremes',
        climateEvent: 'Ocean Warming & Cyclone Dynamics',
        location: 'Pune, Maharashtra, India',
        impact: 'IPCC Lead Author',
        date: DateTime.now().subtract(const Duration(days: 1)),
        sourceUrl: 'https://rocksea.org/',
        imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=600&q=80',
        severity: 'high',
        source: 'IITM Pune',
        isReviewed: true,
        description: 'Climate scientist at the Indian Institute of Tropical Meteorology (IITM) Pune, leading pioneering studies on Indian Ocean surface temperature rise and supercharged cyclone forecasting.',
      ),
      Case(
        id: 'case_2',
        personName: 'Dr. Sunita Narain',
        story: 'Pioneering clean air monitoring, water harvesting, and climate justice advocacy',
        climateEvent: 'Air Quality & Water Governance',
        location: 'New Delhi, India',
        impact: 'Padma Shri Awardee',
        date: DateTime.now().subtract(const Duration(days: 2)),
        sourceUrl: 'https://www.cseindia.org/page/sunita-narain',
        imageUrl: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&w=600&q=80',
        severity: 'high',
        source: 'Centre for Science and Environment',
        isReviewed: true,
        description: 'Director General of CSE and editor of Down To Earth magazine, championing grassroots decentralised rainwater harvesting and public transit emission policy.',
      ),
      Case(
        id: 'case_3',
        personName: 'Prof. Navroz K. Dubash',
        story: 'India decarbonisation pathways, power sector reforms, and climate policy architecture',
        climateEvent: 'Climate Policy & Energy Transition',
        location: 'New Delhi, India',
        impact: 'IPCC Coordinating Lead Author',
        date: DateTime.now().subtract(const Duration(days: 3)),
        sourceUrl: 'https://sustainablefutures.org/',
        imageUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=600&q=80',
        severity: 'medium',
        source: 'Sustainable Futures Collaborative',
        isReviewed: true,
        description: 'Senior Fellow at Sustainable Futures Collaborative and former CPR Professor, focusing on institutional frameworks for climate governance and green energy transitions.',
      ),
      Case(
        id: 'case_4',
        personName: 'Dr. Chirag Dhara',
        story: 'Compound extreme weather analysis, wet-bulb heat thresholds, and regional climate modeling',
        climateEvent: 'Heatwaves & Atmospheric Thermodynamics',
        location: 'Sri City, Andhra Pradesh, India',
        impact: 'MoES Assessment Author',
        date: DateTime.now().subtract(const Duration(days: 4)),
        sourceUrl: 'https://krea.edu.in/faculty/chirag-dhara/',
        imageUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=600&q=80',
        severity: 'high',
        source: 'Krea University',
        isReviewed: true,
        description: 'Climate physicist at Krea University and key author of India\'s first national climate assessment published by the Ministry of Earth Sciences (MoES).',
      ),
      Case(
        id: 'case_5',
        personName: 'Dr. Jagdish Krishnaswamy',
        story: 'Western Ghats watershed ecohydrology, river basin dynamics, and tropical forest resilience',
        climateEvent: 'Ecohydrology & Forest Catchments',
        location: 'Bengaluru, Karnataka, India',
        impact: 'IPCC Lead Author',
        date: DateTime.now().subtract(const Duration(days: 5)),
        sourceUrl: 'https://iihs.co.in/',
        imageUrl: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=600&q=80',
        severity: 'medium',
        source: 'IIHS Bangalore',
        isReviewed: true,
        description: 'Dean of the School of Environment and Sustainability at IIHS Bangalore, analyzing hydrological changes in Western Ghats catchments and tropical riparian zones.',
      ),
      Case(
        id: 'case_6',
        personName: 'Dr. Priyadarsanan Dharma Rajan',
        story: 'Ecosystem services, pollinator decline, and biodiversity conservation in fragile agricultural belts',
        climateEvent: 'Biodiversity & Agro-Ecosystems',
        location: 'Bengaluru, Karnataka, India',
        impact: 'ATREE Senior Fellow',
        date: DateTime.now().subtract(const Duration(days: 6)),
        sourceUrl: 'https://www.atree.org/',
        imageUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&w=600&q=80',
        severity: 'medium',
        source: 'ATREE India',
        isReviewed: true,
        description: 'Senior Fellow at ATREE, investigating pollinator declines, insect conservation, and canopy arthropods under changing regional microclimates.',
      ),
    ];
  }

  static Future<List<Case>> _fetchFromNewsAPI() async {
    try {
      final apiKey = EnvConfig.newsApiKey;
      if (apiKey.isEmpty) return [];

      final keyword = 'climate refugee';
      final url = 'https://newsapi.org/v2/everything?'
          'q=$keyword&'
          'language=en&'
          'sortBy=publishedAt&'
          'pageSize=5&'
          'apiKey=$apiKey';

      print('📡 CaseService: Fetching from NewsAPI with keyword: $keyword');

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return _processNewsAPIResponse(data);
      } else {
        print('❌ CaseService: NewsAPI error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('❌ CaseService: NewsAPI error: $e');
    }
    return [];
  }

  static Future<List<Case>> _fetchFromGNews() async {
    try {
      final apiKey = EnvConfig.gNewsApiKey;
      if (apiKey.isEmpty) return [];

      final effectiveKeywords = [
        'climate refugee', 'disaster victim', 'flood victim'
      ];

      final keywords = effectiveKeywords.join(' ');
      final url = 'https://gnews.io/api/v4/search?'
          'q=$keywords&'
          'lang=en&'
          'country=us&'
          'max=10&'
          'apikey=$apiKey';

      print('📡 CaseService: Fetching from GNews with keywords: $keywords');

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return _processGNewsResponse(data);
      } else {
        print('❌ CaseService: GNews error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('❌ CaseService: GNews error: $e');
    }
    return [];
  }

  static List<Case> _processNewsAPIResponse(Map<String, dynamic> data) {
    final cases = <Case>[];
    final articles = data['articles'] as List? ?? [];

    for (final article in articles) {
      if (_isValidClimateStory(article['title'] ?? '', article['description'] ?? '')) {
        final caseData = _extractCaseFromArticle(article, 'NewsAPI');
        if (caseData != null) {
          cases.add(caseData);
        }
      }
    }
    return cases;
  }

  static List<Case> _processGNewsResponse(Map<String, dynamic> data) {
    final cases = <Case>[];
    final articles = data['articles'] as List? ?? [];

    for (final article in articles) {
      if (_isValidClimateStory(article['title'] ?? '', article['content'] ?? '')) {
        final caseData = _extractCaseFromArticle(article, 'GNews');
        if (caseData != null) {
          cases.add(caseData);
        }
      }
    }
    return cases;
  }

  static bool _isValidClimateStory(String title, String content) {
    final text = '${title.toLowerCase()} ${content.toLowerCase()}';

    final hasClimateKeyword = _climateKeywords.any((keyword) =>
        text.contains(keyword.toLowerCase()));

    final hasExcludeKeyword = _excludeKeywords.any((keyword) =>
        text.contains(keyword.toLowerCase()));

    return hasClimateKeyword && !hasExcludeKeyword;
  }

  static Case? _extractCaseFromArticle(Map<String, dynamic> article, String source) {
    try {
      final title = article['title'] ?? '';
      final content = article['content'] ?? article['description'] ?? '';
      final url = article['url'] ?? '';
      final publishedAt = article['publishedAt'] ?? '';
      final imageUrl = article['urlToImage'];

      final personName = _extractPersonName(title, content);

      final climateEvent = _extractClimateEvent(title, content);

      final location = _extractLocation(title, content);

      final impact = _extractImpact(title, content);

      if (personName.isNotEmpty && climateEvent.isNotEmpty) {
        return Case(
          id: '',
          personName: personName,
          story: title,
          climateEvent: climateEvent,
          location: location,
          impact: impact,
          date: DateTime.parse(publishedAt),
          sourceUrl: url,
          imageUrl: imageUrl,
          severity: _determineSeverity(title, content),
          source: source,
        );
      }
    } catch (e) {
      print('❌ CaseService: Error extracting case: $e');
    }
    return null;
  }

  static String _extractPersonName(String title, String content) {

    final namePattern = RegExp(r'\b[A-Z][a-z]+ [A-Z][a-z]+\b');
    final matches = namePattern.allMatches('$title $content');
    return matches.isNotEmpty ? matches.first.group(0) ?? '' : '';
  }

  static String _extractClimateEvent(String title, String content) {
    final climateEvents = [
      'flooding', 'drought', 'wildfire', 'hurricane', 'typhoon',
      'sea level rise', 'extreme heat', 'climate change', 'global warming',
      'extreme weather', 'climate disaster', 'environmental disaster'
    ];

    final text = '$title $content'.toLowerCase();
    for (final event in climateEvents) {
      if (text.contains(event)) {
        return event.split(' ').map((word) => word[0].toUpperCase() + word.substring(1)).join(' ');
      }
    }
    return 'Climate Event';
  }

  static String _extractLocation(String title, String content) {

    final locationPattern = RegExp(r'\b[A-Z][a-z]+(?: [A-Z][a-z]+)*,? [A-Z]{2}\b');
    final matches = locationPattern.allMatches('$title $content');
    return matches.isNotEmpty ? matches.first.group(0) ?? '' : 'Unknown Location';
  }

  static String _extractImpact(String title, String content) {
    final impacts = [
      'lost home', 'displaced', 'injured', 'missing', 'died',
      'lost livelihood', 'forced to move', 'evacuated', 'homeless'
    ];

    final text = '$title $content'.toLowerCase();
    for (final impact in impacts) {
      if (text.contains(impact)) {
        return impact.split(' ').map((word) => word[0].toUpperCase() + word.substring(1)).join(' ');
      }
    }
    return 'Affected by Climate Event';
  }

  static String _determineSeverity(String title, String content) {
    final text = '$title $content'.toLowerCase();
    final highSeverityWords = ['died', 'death', 'fatal', 'killed', 'dead'];
    final mediumSeverityWords = ['injured', 'hospitalized', 'serious', 'critical'];

    if (highSeverityWords.any((word) => text.contains(word))) {
      return 'high';
    } else if (mediumSeverityWords.any((word) => text.contains(word))) {
      return 'medium';
    }
    return 'low';
  }

  static List<Case> _removeDuplicates(List<Case> cases) {
    final uniqueCases = <String, Case>{};
    for (final caseData in cases) {
      final key = '${caseData.personName}_${caseData.climateEvent}_${caseData.date.toIso8601String()}';
      if (!uniqueCases.containsKey(key)) {
        uniqueCases[key] = caseData;
      }
    }
    return uniqueCases.values.toList();
  }

  static Future<void> _saveCaseToFirebase(Case caseData) async {
    try {

      final existing = await _firestore.collection('cases')
          .where('personName', isEqualTo: caseData.personName)
          .where('climateEvent', isEqualTo: caseData.climateEvent)
          .where('date', isEqualTo: Timestamp.fromDate(caseData.date))
          .get();

      if (existing.docs.isEmpty) {
        await _firestore.collection('cases').add(caseData.toJson());
        print('✅ CaseService: Saved new case: ${caseData.personName}');
      }
    } catch (e) {
      print('❌ CaseService: Error saving case: $e');
    }
  }

  static Future<void> markCaseAsReviewed(String caseId, String userId) async {
    try {
      await _firestore.collection('cases').doc(caseId).update({
        'isReviewed': true,
        'reviewedBy': userId,
        'reviewedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('❌ CaseService: Error marking case as reviewed: $e');
    }
  }
}