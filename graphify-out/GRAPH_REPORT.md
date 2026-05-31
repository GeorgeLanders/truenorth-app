# Graph Report - truenorth_app  (2026-05-31)

## Corpus Check
- 67 files · ~56,681 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 501 nodes · 476 edges · 51 communities (39 shown, 12 thin omitted)
- Extraction: 98% EXTRACTED · 2% INFERRED · 0% AMBIGUOUS · INFERRED: 8 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `84d99c46`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- [[_COMMUNITY_Community 0|Community 0]]
- [[_COMMUNITY_Community 1|Community 1]]
- [[_COMMUNITY_Community 2|Community 2]]
- [[_COMMUNITY_Community 3|Community 3]]
- [[_COMMUNITY_Community 4|Community 4]]
- [[_COMMUNITY_Community 5|Community 5]]
- [[_COMMUNITY_Community 6|Community 6]]
- [[_COMMUNITY_Community 7|Community 7]]
- [[_COMMUNITY_Community 8|Community 8]]
- [[_COMMUNITY_Community 9|Community 9]]
- [[_COMMUNITY_Community 10|Community 10]]
- [[_COMMUNITY_Community 11|Community 11]]
- [[_COMMUNITY_Community 12|Community 12]]
- [[_COMMUNITY_Community 13|Community 13]]
- [[_COMMUNITY_Community 14|Community 14]]
- [[_COMMUNITY_Community 15|Community 15]]
- [[_COMMUNITY_Community 16|Community 16]]
- [[_COMMUNITY_Community 17|Community 17]]
- [[_COMMUNITY_Community 18|Community 18]]
- [[_COMMUNITY_Community 19|Community 19]]
- [[_COMMUNITY_Community 20|Community 20]]
- [[_COMMUNITY_Community 21|Community 21]]
- [[_COMMUNITY_Community 22|Community 22]]
- [[_COMMUNITY_Community 23|Community 23]]
- [[_COMMUNITY_Community 24|Community 24]]
- [[_COMMUNITY_Community 25|Community 25]]
- [[_COMMUNITY_Community 26|Community 26]]
- [[_COMMUNITY_Community 27|Community 27]]
- [[_COMMUNITY_Community 28|Community 28]]
- [[_COMMUNITY_Community 29|Community 29]]
- [[_COMMUNITY_Community 30|Community 30]]
- [[_COMMUNITY_Community 31|Community 31]]
- [[_COMMUNITY_Community 32|Community 32]]
- [[_COMMUNITY_Community 33|Community 33]]
- [[_COMMUNITY_Community 34|Community 34]]
- [[_COMMUNITY_Community 35|Community 35]]
- [[_COMMUNITY_Community 36|Community 36]]
- [[_COMMUNITY_Community 37|Community 37]]
- [[_COMMUNITY_Community 38|Community 38]]
- [[_COMMUNITY_Community 39|Community 39]]
- [[_COMMUNITY_Community 40|Community 40]]
- [[_COMMUNITY_Community 41|Community 41]]
- [[_COMMUNITY_Community 42|Community 42]]
- [[_COMMUNITY_Community 43|Community 43]]
- [[_COMMUNITY_Community 44|Community 44]]

## God Nodes (most connected - your core abstractions)
1. `TrueNorth Privacy Policy` - 11 edges
2. `TrueNorth - Play Store Listing` - 8 edges
3. `WindowClassRegistrar` - 7 edges
4. `Create()` - 7 edges
5. `Destroy()` - 7 edges
6. `AppDelegate` - 5 edges
7. `MessageHandler()` - 5 edges
8. `Deploy on Render.com via GitHub` - 5 edges
9. `Full Description` - 5 edges
10. `AppDelegate` - 4 edges

## Surprising Connections (you probably didn't know these)
- `my_application_activate()` --calls--> `fl_register_plugins()`  [INFERRED]
  linux/runner/my_application.cc → linux/flutter/generated_plugin_registrant.cc
- `main()` --calls--> `my_application_new()`  [INFERRED]
  linux/runner/main.cc → linux/runner/my_application.cc
- `OnCreate()` --calls--> `RegisterPlugins()`  [INFERRED]
  windows/runner/flutter_window.cpp → windows/flutter/generated_plugin_registrant.cc
- `OnCreate()` --calls--> `GetClientArea()`  [INFERRED]
  windows/runner/flutter_window.cpp → windows/runner/win32_window.cpp
- `OnCreate()` --calls--> `SetChildContent()`  [INFERRED]
  windows/runner/flutter_window.cpp → windows/runner/win32_window.cpp

## Communities (51 total, 12 thin omitted)

### Community 0 - "Community 0"
Cohesion: 0.10
Nodes (22): RegisterPlugins(), OnCreate(), Create(), Destroy(), EnableFullDpiSupportIfAvailable(), GetClientArea(), GetThisFromHandle(), GetWindowClass() (+14 more)

### Community 1 - "Community 1"
Cohesion: 0.07
Nodes (29): _breathIndicator, BreathingExercise, _BreathingExerciseState, build, _buildBreathing, _buildGrounding, _buildResources, Center (+21 more)

### Community 2 - "Community 2"
Cohesion: 0.08
Nodes (25): build, DashboardScreen, _DashboardScreenState, GestureDetector, _getDailyAffirmation, _getTimeGreeting, GlassCard, Icon (+17 more)

### Community 3 - "Community 3"
Cohesion: 0.08
Nodes (23): build, _buildCategory, Center, dispose, GestureDetector, Icon, initState, MovementLibraryScreen (+15 more)

### Community 4 - "Community 4"
Cohesion: 0.08
Nodes (23): AnimatedContainer, build, _buildGoalsPage, _buildMobilityPage, _buildPromisePage, _buildWelcomePage, dispose, _finishOnboarding (+15 more)

### Community 5 - "Community 5"
Cohesion: 0.08
Nodes (23): AppNavShell, _AppNavShellState, build, DashboardScreen, initState, ListTile, _loadUserName, MovementLibraryScreen (+15 more)

### Community 6 - "Community 6"
Cohesion: 0.09
Nodes (22): _AllEntriesPage, build, dispose, GestureDetector, initState, JournalScreen, _JournalScreenState, _loadEntries (+14 more)

### Community 7 - "Community 7"
Cohesion: 0.09
Nodes (21): build, dispose, GestureDetector, Icon, initState, _loadData, _mealTypeChip, NourishScreen (+13 more)

### Community 8 - "Community 8"
Cohesion: 0.10
Nodes (20): AICoachScreen, _AICoachScreenState, Align, build, _buildLoadingBubble, _buildMessageBubble, _ChatMessage, Container (+12 more)

### Community 9 - "Community 9"
Cohesion: 0.10
Nodes (19): build, _dataButton, dispose, Divider, initState, ListTile, _loadData, ProfileScreen (+11 more)

### Community 10 - "Community 10"
Cohesion: 0.11
Nodes (7): fl_register_plugins(), main(), my_application_activate(), my_application_new(), _MyApplication, dart_entrypoint_arguments, parent_instance

### Community 11 - "Community 11"
Cohesion: 0.12
Nodes (15): AppNavShell, AppShell, build, _finishOnboarding, initState, MaterialApp, TrueNorthApp, _TrueNorthAppState (+7 more)

### Community 12 - "Community 12"
Cohesion: 0.13
Nodes (14): AnimatedBackground, _AnimatedBackgroundState, AnimatedBuilder, build, _buildBlob, _buildTwinkle, dispose, initState (+6 more)

### Community 13 - "Community 13"
Cohesion: 0.14
Nodes (13): daily_logs, _initDatabase, journal_entries, loadUserData, meal_logs, saveUserData, StorageService, dart:convert (+5 more)

### Community 14 - "Community 14"
Cohesion: 0.18
Nodes (4): wWinMain(), CreateAndAttachConsole(), GetCommandLineArguments(), Utf8FromUtf16()

### Community 15 - "Community 15"
Cohesion: 0.14
Nodes (13): Automatically Collected, Changes to This Policy, Children's Privacy, Contact, Data Deletion, Data Storage, How We Use Your Data, Information We Collect (+5 more)

### Community 16 - "Community 16"
Cohesion: 0.15
Nodes (12): App Name, Category, Coming Soon:, Content Rating, Features:, Full Description, Keywords, Short Description (80 chars) (+4 more)

### Community 17 - "Community 17"
Cohesion: 0.17
Nodes (11): addToHistory, AICoachService, _buildSystemPrompt, clearHistory, configure, getJournalPrompt, _getLocalResponse, setUserName (+3 more)

### Community 18 - "Community 18"
Cohesion: 0.17
Nodes (11): API Endpoints, code:bash (cd server), code:json ({), code:json ({), Deploy on Render.com via GitHub, Deploy to Render.com, GET /health, Local Development (+3 more)

### Community 19 - "Community 19"
Cohesion: 0.18
Nodes (10): background_color, description, display, icons, name, orientation, prefer_related_applications, short_name (+2 more)

### Community 20 - "Community 20"
Cohesion: 0.20
Nodes (4): FlutterAppDelegate, FlutterImplicitEngineDelegate, AppDelegate, AppDelegate

### Community 21 - "Community 21"
Cohesion: 0.29
Nodes (6): build, Container, GlassCard, dart:ui, package:flutter/material.dart, ../theme/app_theme.dart

### Community 22 - "Community 22"
Cohesion: 0.29
Nodes (3): RunnerTests, RunnerTests, XCTestCase

### Community 23 - "Community 23"
Cohesion: 0.29
Nodes (3): draw_phone_bg(), Generate TrueNorth Play Store screenshots (phone mockups of app screens)., Draw dark gradient background for phone screen

### Community 24 - "Community 24"
Cohesion: 0.38
Nodes (4): BaseModel, chat(), ChatRequest, ChatResponse

### Community 25 - "Community 25"
Cohesion: 0.33
Nodes (5): app.dart, main, StorageService, package:flutter/material.dart, services/storage_service.dart

### Community 26 - "Community 26"
Cohesion: 0.33
Nodes (3): RegisterGeneratedPlugins(), NSWindow, MainFlutterWindow

### Community 27 - "Community 27"
Cohesion: 0.40
Nodes (4): images, info, author, version

### Community 28 - "Community 28"
Cohesion: 0.40
Nodes (4): images, info, author, version

### Community 29 - "Community 29"
Cohesion: 0.40
Nodes (4): images, info, author, version

### Community 30 - "Community 30"
Cohesion: 0.50
Nodes (3): JournalEntry, MealLog, package:intl/intl.dart

### Community 31 - "Community 31"
Cohesion: 0.50
Nodes (3): AppTheme, ThemeData, package:flutter/material.dart

### Community 32 - "Community 32"
Cohesion: 0.50
Nodes (3): main, package:flutter_test/flutter_test.dart, package:truenorth_app/app.dart

## Knowledge Gaps
- **340 isolated node(s):** `MainActivity`, `MainActivity`, `flutter_export_environment.sh script`, `-registerWithRegistry`, `images` (+335 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **12 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `OnCreate()` connect `Community 0` to `Community 14`?**
  _High betweenness centrality (0.002) - this node is a cross-community bridge._
- **What connects `MainActivity`, `MainActivity`, `flutter_export_environment.sh script` to the rest of the system?**
  _344 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Community 0` be split into smaller, more focused modules?**
  _Cohesion score 0.1032258064516129 - nodes in this community are weakly interconnected._
- **Should `Community 1` be split into smaller, more focused modules?**
  _Cohesion score 0.06666666666666667 - nodes in this community are weakly interconnected._
- **Should `Community 2` be split into smaller, more focused modules?**
  _Cohesion score 0.07692307692307693 - nodes in this community are weakly interconnected._
- **Should `Community 3` be split into smaller, more focused modules?**
  _Cohesion score 0.08333333333333333 - nodes in this community are weakly interconnected._
- **Should `Community 4` be split into smaller, more focused modules?**
  _Cohesion score 0.08333333333333333 - nodes in this community are weakly interconnected._