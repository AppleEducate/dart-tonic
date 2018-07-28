part of tonic;

class InstrumentClass {
  final String name;

  static final Map _byName = <String, InstrumentClass>{};

  InstrumentClass({this.name}) {
    _byName[name] = this;
  }

  static InstrumentClass lookup(String name) {
    _initialize();
    var instrument = _byName[name];
    if (instrument == null) throw new Exception("No instrument named $name");
    return instrument;
  }

  bool get fretted => false;

  static final FrettedInstrumentClass Guitar = InstrumentClass.lookup('Guitar');

  static bool _initialized = false;

  static _initialize() {
    if (_initialized) return;
    _initialized = true;
    for (var spec in _INSTRUMENT_SPECS) {
      // var stringPitches = spec['stringPitches']
      //     .split(new RegExp(r'\s+'))
      //     .map(Pitch.parse)
      //     .toList();
      String _spec = spec['stringPitches'];
      _spec.split(new RegExp(r'\s+')).map(Pitch.parse).toList();
      var stringPitches =
          _spec.split(new RegExp(r'\s+')).map(Pitch.parse).toList();

      new FrettedInstrumentClass(
          name: spec['name'], stringPitches: stringPitches);
    }
  }
}

class FrettedInstrumentClass extends InstrumentClass {
  final List<Pitch> stringPitches;

  FrettedInstrumentClass({String name, List<Pitch> this.stringPitches})
      : super(name: name);

  bool get fretted => true;

  // Iterable<int> get stringIndices => [0, ..., stringPitches.length - 1];
  Iterable<int> get stringIndices =>
      new Iterable<int>.generate(stringPitches.length, (i) => i);

  Pitch pitchAt({int stringIndex, int fretNumber}) =>
      stringPitches[stringIndex] + new Interval.fromSemitones(fretNumber);

  // eachFingerPosition: (fn) ->
  //   for string in @stringNumbers
  //     for fret in [0 .. @fretCount]
  //       fn string: string, fret: fret
}

final _INSTRUMENT_SPECS = [
  {
    'name': 'Guitar',
    // TODO: factor into Tuning model http://en.wikipedia.org/wiki/Stringed_instrument_tunings
    'stringPitches': 'E2 A2 D3 G3 B3 E4',
    'fretted': true,
    'fretCount': 12,
  },
  {
    'name': 'Violin',
    'stringPitches': 'G3 D4 A4 E5',
  },
  {
    'name': 'Viola',
    'stringPitches': 'C3 G3 D4 A4',
  },
  {
    'name': 'Cello',
    'stringPitches': 'C2 G2 D3 A3',
  }
];

// FretNumbers = [0..4]  # includes nut
// FretCount = FretNumbers.length - 1  # doesn't include nut

// intervalPositionsFromRoot = (instrument, rootPosition, semitones) ->
//   rootPitch = instrument.pitchAt(rootPosition)
//   positions = []
//   fretboard_positions_each (fingerPosition) ->
//     return unless intervalClassDifference(rootPitch, instrument.pitchAt(fingerPosition)) == semitones
//     positions.push fingerPosition
//   return positions
