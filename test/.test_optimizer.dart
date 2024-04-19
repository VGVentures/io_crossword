// GENERATED CODE - DO NOT MODIFY BY HAND
// Consider adding this file to your .gitignore.

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';


import 'bottom_bar/view/bottom_bar_test.dart' as _a;
import 'hint/widgets/hint_text_test.dart' as _b;
import 'hint/widgets/gemini_hint_button_test.dart' as _c;
import 'hint/widgets/gemini_text_field_test.dart' as _d;
import 'hint/widgets/close_hint_button_test.dart' as _e;
import 'hint/bloc/hint_bloc_test.dart' as _f;
import 'hint/bloc/hint_event_test.dart' as _g;
import 'hint/bloc/hint_state_test.dart' as _h;
import 'drawer/view/crossword_drawer_test.dart' as _i;
import 'game_intro/view/game_intro_page_test.dart' as _j;
import 'game_intro/bloc/game_intro_state_test.dart' as _k;
import 'game_intro/bloc/game_intro_event_test.dart' as _l;
import 'game_intro/bloc/game_intro_bloc_test.dart' as _m;
import 'initials/view/initials_page_test.dart' as _n;
import 'initials/widgets/initials_error_text_test.dart' as _o;
import 'initials/widgets/initials_submit_button_test.dart' as _p;
import 'initials/bloc/initials_bloc_test.dart' as _q;
import 'initials/bloc/initials_state_test.dart' as _r;
import 'initials/bloc/initials_event_test.dart' as _s;
import 'app/view/app_test.dart' as _t;
import 'streak/view/streak_at_risk_test.dart' as _u;
import 'crossword/game/crossword_game_test.dart' as _v;
import 'crossword/game/section_component/section_keyboard_handler_test.dart' as _w;
import 'crossword/game/section_component/section_component_test.dart' as _x;
import 'crossword/extensions/word_size_test.dart' as _y;
import 'crossword/view/crossword_page_test.dart' as _z;
import 'crossword/bloc/crossword_bloc_test.dart' as _A;
import 'crossword/bloc/crossword_state_test.dart' as _B;
import 'crossword/bloc/crossword_event_test.dart' as _C;
import 'leaderboard/view/leaderboard_page_test.dart' as _D;
import 'leaderboard/view/leaderboard_success_test.dart' as _E;
import 'leaderboard/bloc/leaderboard_event_test.dart' as _F;
import 'leaderboard/bloc/leaderboard_state_test.dart' as _G;
import 'leaderboard/bloc/leaderboard_bloc_test.dart' as _H;
import 'about/view/about_how_to_play_test.dart' as _I;
import 'about/view/about_project_details_test.dart' as _J;
import 'about/view/about_view_test.dart' as _K;
import 'welcome/view/welcome_page_test.dart' as _L;
import 'welcome/widgets/welcome_header_image_test.dart' as _M;
import 'welcome/widgets/challenge_progress_test.dart' as _N;
import 'extensions/number_ext_test.dart' as _O;
import 'extensions/mascot_color_test.dart' as _P;
import 'crossword2/view/crossword2_view_test.dart' as _Q;
import 'crossword2/widgets/crossword_chunk_test.dart' as _R;
import 'crossword2/widgets/crossword_configuration_test.dart' as _S;
import 'crossword2/widgets/crossword_layout_data_test.dart' as _T;
import 'crossword2/widgets/crossword_interactive_viewer_test.dart' as _U;
import 'crossword2/widgets/quad_scope_test.dart' as _V;
import 'team_selection/cubit/team_selection_cubit_test.dart' as _W;
import 'team_selection/cubit/team_selection_state_test.dart' as _X;
import 'team_selection/view/team_selection_page_test.dart' as _Y;
import 'team_selection/teams/dino_team_test.dart' as _Z;
import 'team_selection/teams/android_team_test.dart' as _aa;
import 'team_selection/teams/sparky_team_test.dart' as _ba;
import 'team_selection/teams/sprite_information_test.dart' as _ca;
import 'team_selection/teams/dash_team_test.dart' as _da;
import 'team_selection/widgets/team_selection_mascot_platform_test.dart' as _ea;
import 'team_selection/widgets/team_selection_mascot_test.dart' as _fa;
import 'word_selection/widgets/close_word_selection_icon_button_test.dart' as _ga;
import 'word_focused/view/word_success_view_test.dart' as _ha;
import 'word_focused/view/word_solving_view_test.dart' as _ia;
import 'word_focused/view/word_selection_page_test.dart' as _ja;
import 'word_focused/view/word_pre_solving_view_test.dart' as _ka;
import 'word_focused/view/word_selection_view_test.dart' as _la;
import 'word_focused/widgets/word_selection_top_bar_test.dart' as _ma;
import 'word_focused/bloc/word_selection_bloc_test.dart' as _na;
import 'word_focused/bloc/word_selection_event_test.dart' as _oa;
import 'word_focused/bloc/word_selection_state_test.dart' as _pa;
import 'challenge/bloc/challenge_state_test.dart' as _qa;
import 'challenge/bloc/challenge_bloc_test.dart' as _ra;
import 'challenge/bloc/challenge_event_test.dart' as _sa;
import 'how_to_play/view/how_to_play_page_test.dart' as _ta;
import 'player/view/player_ranking_information_test.dart' as _ua;
import 'player/bloc/player_state_test.dart' as _va;
import 'player/bloc/player_event_test.dart' as _wa;
import 'player/bloc/player_bloc_test.dart' as _xa;
import 'share/view/share_score_page_test.dart' as _ya;
import 'share/view/share_word_page_test.dart' as _za;
import 'share/widgets/share_dialog_test.dart' as _Aa;

void main() {
  goldenFileComparator = _TestOptimizationAwareGoldenFileComparator(goldenFileComparator as LocalFileComparator);
  group('bottom_bar/view/bottom_bar_test.dart', () { _a.main(); });
  group('hint/widgets/hint_text_test.dart', () { _b.main(); });
  group('hint/widgets/gemini_hint_button_test.dart', () { _c.main(); });
  group('hint/widgets/gemini_text_field_test.dart', () { _d.main(); });
  group('hint/widgets/close_hint_button_test.dart', () { _e.main(); });
  group('hint/bloc/hint_bloc_test.dart', () { _f.main(); });
  group('hint/bloc/hint_event_test.dart', () { _g.main(); });
  group('hint/bloc/hint_state_test.dart', () { _h.main(); });
  group('drawer/view/crossword_drawer_test.dart', () { _i.main(); });
  group('game_intro/view/game_intro_page_test.dart', () { _j.main(); });
  group('game_intro/bloc/game_intro_state_test.dart', () { _k.main(); });
  group('game_intro/bloc/game_intro_event_test.dart', () { _l.main(); });
  group('game_intro/bloc/game_intro_bloc_test.dart', () { _m.main(); });
  group('initials/view/initials_page_test.dart', () { _n.main(); });
  group('initials/widgets/initials_error_text_test.dart', () { _o.main(); });
  group('initials/widgets/initials_submit_button_test.dart', () { _p.main(); });
  group('initials/bloc/initials_bloc_test.dart', () { _q.main(); });
  group('initials/bloc/initials_state_test.dart', () { _r.main(); });
  group('initials/bloc/initials_event_test.dart', () { _s.main(); });
  group('app/view/app_test.dart', () { _t.main(); });
  group('streak/view/streak_at_risk_test.dart', () { _u.main(); });
  group('crossword/game/crossword_game_test.dart', () { _v.main(); });
  group('crossword/game/section_component/section_keyboard_handler_test.dart', () { _w.main(); });
  group('crossword/game/section_component/section_component_test.dart', () { _x.main(); });
  group('crossword/extensions/word_size_test.dart', () { _y.main(); });
  group('crossword/view/crossword_page_test.dart', () { _z.main(); });
  group('crossword/bloc/crossword_bloc_test.dart', () { _A.main(); });
  group('crossword/bloc/crossword_state_test.dart', () { _B.main(); });
  group('crossword/bloc/crossword_event_test.dart', () { _C.main(); });
  group('leaderboard/view/leaderboard_page_test.dart', () { _D.main(); });
  group('leaderboard/view/leaderboard_success_test.dart', () { _E.main(); });
  group('leaderboard/bloc/leaderboard_event_test.dart', () { _F.main(); });
  group('leaderboard/bloc/leaderboard_state_test.dart', () { _G.main(); });
  group('leaderboard/bloc/leaderboard_bloc_test.dart', () { _H.main(); });
  group('about/view/about_how_to_play_test.dart', () { _I.main(); });
  group('about/view/about_project_details_test.dart', () { _J.main(); });
  group('about/view/about_view_test.dart', () { _K.main(); });
  group('welcome/view/welcome_page_test.dart', () { _L.main(); });
  group('welcome/widgets/welcome_header_image_test.dart', () { _M.main(); });
  group('welcome/widgets/challenge_progress_test.dart', () { _N.main(); });
  group('extensions/number_ext_test.dart', () { _O.main(); });
  group('extensions/mascot_color_test.dart', () { _P.main(); });
  group('crossword2/view/crossword2_view_test.dart', () { _Q.main(); });
  group('crossword2/widgets/crossword_chunk_test.dart', () { _R.main(); });
  group('crossword2/widgets/crossword_configuration_test.dart', () { _S.main(); });
  group('crossword2/widgets/crossword_layout_data_test.dart', () { _T.main(); });
  group('crossword2/widgets/crossword_interactive_viewer_test.dart', () { _U.main(); });
  group('crossword2/widgets/quad_scope_test.dart', () { _V.main(); });
  group('team_selection/cubit/team_selection_cubit_test.dart', () { _W.main(); });
  group('team_selection/cubit/team_selection_state_test.dart', () { _X.main(); });
  group('team_selection/view/team_selection_page_test.dart', () { _Y.main(); });
  group('team_selection/teams/dino_team_test.dart', () { _Z.main(); });
  group('team_selection/teams/android_team_test.dart', () { _aa.main(); });
  group('team_selection/teams/sparky_team_test.dart', () { _ba.main(); });
  group('team_selection/teams/sprite_information_test.dart', () { _ca.main(); });
  group('team_selection/teams/dash_team_test.dart', () { _da.main(); });
  group('team_selection/widgets/team_selection_mascot_platform_test.dart', () { _ea.main(); });
  group('team_selection/widgets/team_selection_mascot_test.dart', () { _fa.main(); });
  group('word_selection/widgets/close_word_selection_icon_button_test.dart', () { _ga.main(); });
  group('word_focused/view/word_success_view_test.dart', () { _ha.main(); });
  group('word_focused/view/word_solving_view_test.dart', () { _ia.main(); });
  group('word_focused/view/word_selection_page_test.dart', () { _ja.main(); });
  group('word_focused/view/word_pre_solving_view_test.dart', () { _ka.main(); });
  group('word_focused/view/word_selection_view_test.dart', () { _la.main(); });
  group('word_focused/widgets/word_selection_top_bar_test.dart', () { _ma.main(); });
  group('word_focused/bloc/word_selection_bloc_test.dart', () { _na.main(); });
  group('word_focused/bloc/word_selection_event_test.dart', () { _oa.main(); });
  group('word_focused/bloc/word_selection_state_test.dart', () { _pa.main(); });
  group('challenge/bloc/challenge_state_test.dart', () { _qa.main(); });
  group('challenge/bloc/challenge_bloc_test.dart', () { _ra.main(); });
  group('challenge/bloc/challenge_event_test.dart', () { _sa.main(); });
  group('how_to_play/view/how_to_play_page_test.dart', () { _ta.main(); });
  group('player/view/player_ranking_information_test.dart', () { _ua.main(); });
  group('player/bloc/player_state_test.dart', () { _va.main(); });
  group('player/bloc/player_event_test.dart', () { _wa.main(); });
  group('player/bloc/player_bloc_test.dart', () { _xa.main(); });
  group('share/view/share_score_page_test.dart', () { _ya.main(); });
  group('share/view/share_word_page_test.dart', () { _za.main(); });
  group('share/widgets/share_dialog_test.dart', () { _Aa.main(); });
}


class _TestOptimizationAwareGoldenFileComparator extends GoldenFileComparator {
  final List<String> goldenFilePaths;
  final LocalFileComparator previousGoldenFileComparator;

  _TestOptimizationAwareGoldenFileComparator(this.previousGoldenFileComparator)
      : goldenFilePaths = _goldenFilePaths;

  static List<String> get _goldenFilePaths =>
      Directory.fromUri((goldenFileComparator as LocalFileComparator).basedir)
          .listSync(recursive: true, followLinks: true)
          .whereType<File>()
          .map((file) => file.path)
          .where((path) => path.endsWith('.png'))
          .toList();
  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden)  => previousGoldenFileComparator.compare(imageBytes, golden);

  @override
  Uri getTestUri(Uri key, int? version) {
    final keyString = key.toFilePath();
    return Uri.parse(goldenFilePaths
        .singleWhere((goldenFilePath) => goldenFilePath.endsWith(keyString)));
  }

  @override
  Future<void> update(Uri golden, Uint8List imageBytes) => previousGoldenFileComparator.update(golden, imageBytes);

}
