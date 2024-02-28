// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Crossword extends Crossword {
  @override
  final BuiltList<String> candidates;
  @override
  final BuiltMap<Location, String> downWords;
  @override
  final BuiltMap<Location, String> acrossWords;
  @override
  final BuiltMap<Location, CrosswordCharacter> characters;

  factory _$Crossword([void Function(CrosswordBuilder)? updates]) =>
      (new CrosswordBuilder()..update(updates))._build();

  _$Crossword._(
      {required this.candidates,
      required this.downWords,
      required this.acrossWords,
      required this.characters})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        candidates, r'Crossword', 'candidates');
    BuiltValueNullFieldError.checkNotNull(downWords, r'Crossword', 'downWords');
    BuiltValueNullFieldError.checkNotNull(
        acrossWords, r'Crossword', 'acrossWords');
    BuiltValueNullFieldError.checkNotNull(
        characters, r'Crossword', 'characters');
  }

  @override
  Crossword rebuild(void Function(CrosswordBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CrosswordBuilder toBuilder() => new CrosswordBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Crossword &&
        candidates == other.candidates &&
        downWords == other.downWords &&
        acrossWords == other.acrossWords &&
        characters == other.characters;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, candidates.hashCode);
    _$hash = $jc(_$hash, downWords.hashCode);
    _$hash = $jc(_$hash, acrossWords.hashCode);
    _$hash = $jc(_$hash, characters.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Crossword')
          ..add('candidates', candidates)
          ..add('downWords', downWords)
          ..add('acrossWords', acrossWords)
          ..add('characters', characters))
        .toString();
  }
}

class CrosswordBuilder implements Builder<Crossword, CrosswordBuilder> {
  _$Crossword? _$v;

  ListBuilder<String>? _candidates;
  ListBuilder<String> get candidates =>
      _$this._candidates ??= new ListBuilder<String>();
  set candidates(ListBuilder<String>? candidates) =>
      _$this._candidates = candidates;

  MapBuilder<Location, String>? _downWords;
  MapBuilder<Location, String> get downWords =>
      _$this._downWords ??= new MapBuilder<Location, String>();
  set downWords(MapBuilder<Location, String>? downWords) =>
      _$this._downWords = downWords;

  MapBuilder<Location, String>? _acrossWords;
  MapBuilder<Location, String> get acrossWords =>
      _$this._acrossWords ??= new MapBuilder<Location, String>();
  set acrossWords(MapBuilder<Location, String>? acrossWords) =>
      _$this._acrossWords = acrossWords;

  MapBuilder<Location, CrosswordCharacter>? _characters;
  MapBuilder<Location, CrosswordCharacter> get characters =>
      _$this._characters ??= new MapBuilder<Location, CrosswordCharacter>();
  set characters(MapBuilder<Location, CrosswordCharacter>? characters) =>
      _$this._characters = characters;

  CrosswordBuilder();

  CrosswordBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _candidates = $v.candidates.toBuilder();
      _downWords = $v.downWords.toBuilder();
      _acrossWords = $v.acrossWords.toBuilder();
      _characters = $v.characters.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Crossword other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Crossword;
  }

  @override
  void update(void Function(CrosswordBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Crossword build() => _build();

  _$Crossword _build() {
    Crossword._fillCharacters(this);
    _$Crossword _$result;
    try {
      _$result = _$v ??
          new _$Crossword._(
              candidates: candidates.build(),
              downWords: downWords.build(),
              acrossWords: acrossWords.build(),
              characters: characters.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'candidates';
        candidates.build();
        _$failedField = 'downWords';
        downWords.build();
        _$failedField = 'acrossWords';
        acrossWords.build();
        _$failedField = 'characters';
        characters.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'Crossword', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$Location extends Location {
  @override
  final int across;
  @override
  final int down;

  factory _$Location([void Function(LocationBuilder)? updates]) =>
      (new LocationBuilder()..update(updates))._build();

  _$Location._({required this.across, required this.down}) : super._() {
    BuiltValueNullFieldError.checkNotNull(across, r'Location', 'across');
    BuiltValueNullFieldError.checkNotNull(down, r'Location', 'down');
  }

  @override
  Location rebuild(void Function(LocationBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LocationBuilder toBuilder() => new LocationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Location && across == other.across && down == other.down;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, across.hashCode);
    _$hash = $jc(_$hash, down.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Location')
          ..add('across', across)
          ..add('down', down))
        .toString();
  }
}

class LocationBuilder implements Builder<Location, LocationBuilder> {
  _$Location? _$v;

  int? _across;
  int? get across => _$this._across;
  set across(int? across) => _$this._across = across;

  int? _down;
  int? get down => _$this._down;
  set down(int? down) => _$this._down = down;

  LocationBuilder();

  LocationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _across = $v.across;
      _down = $v.down;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Location other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Location;
  }

  @override
  void update(void Function(LocationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Location build() => _build();

  _$Location _build() {
    final _$result = _$v ??
        new _$Location._(
            across: BuiltValueNullFieldError.checkNotNull(
                across, r'Location', 'across'),
            down: BuiltValueNullFieldError.checkNotNull(
                down, r'Location', 'down'));
    replace(_$result);
    return _$result;
  }
}

class _$CrosswordCharacter extends CrosswordCharacter {
  @override
  final String character;
  @override
  final String? acrossWord;
  @override
  final String? downWord;

  factory _$CrosswordCharacter(
          [void Function(CrosswordCharacterBuilder)? updates]) =>
      (new CrosswordCharacterBuilder()..update(updates))._build();

  _$CrosswordCharacter._(
      {required this.character, this.acrossWord, this.downWord})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        character, r'CrosswordCharacter', 'character');
  }

  @override
  CrosswordCharacter rebuild(
          void Function(CrosswordCharacterBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CrosswordCharacterBuilder toBuilder() =>
      new CrosswordCharacterBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CrosswordCharacter &&
        character == other.character &&
        acrossWord == other.acrossWord &&
        downWord == other.downWord;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, character.hashCode);
    _$hash = $jc(_$hash, acrossWord.hashCode);
    _$hash = $jc(_$hash, downWord.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CrosswordCharacter')
          ..add('character', character)
          ..add('acrossWord', acrossWord)
          ..add('downWord', downWord))
        .toString();
  }
}

class CrosswordCharacterBuilder
    implements Builder<CrosswordCharacter, CrosswordCharacterBuilder> {
  _$CrosswordCharacter? _$v;

  String? _character;
  String? get character => _$this._character;
  set character(String? character) => _$this._character = character;

  String? _acrossWord;
  String? get acrossWord => _$this._acrossWord;
  set acrossWord(String? acrossWord) => _$this._acrossWord = acrossWord;

  String? _downWord;
  String? get downWord => _$this._downWord;
  set downWord(String? downWord) => _$this._downWord = downWord;

  CrosswordCharacterBuilder();

  CrosswordCharacterBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _character = $v.character;
      _acrossWord = $v.acrossWord;
      _downWord = $v.downWord;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CrosswordCharacter other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$CrosswordCharacter;
  }

  @override
  void update(void Function(CrosswordCharacterBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CrosswordCharacter build() => _build();

  _$CrosswordCharacter _build() {
    final _$result = _$v ??
        new _$CrosswordCharacter._(
            character: BuiltValueNullFieldError.checkNotNull(
                character, r'CrosswordCharacter', 'character'),
            acrossWord: acrossWord,
            downWord: downWord);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
