import '../models/mystery_case.dart';

const mysteryCases = <MysteryCase>[
  MysteryCase(
    id: 'corrupted_terminal',
    title: 'The Corrupted Terminal',
    subtitle: 'CASE 001  /  SYSTEM BREACH',
    description:
        'A quiet archive has started answering questions nobody asked.',
    difficulty: 'EASY',
    story:
        'At 02:13, the Northstar archive began printing fragments of a file '
        'deleted years ago. The terminal is isolated, yet something inside it '
        'keeps trying to finish a message. Find what changed before the next '
        'nightly reset erases the evidence.',
    ending:
        'The terminal was not broken; it was completing a message left by its '
        'old archivist. You restored the final line before the reset.',
    icon: 'terminal',
    accentHex: 0xff70f0d1,
    clues: [
      Clue(
        id: 'ct_log',
        title: 'Midnight log',
        description:
            'A process called RESTORE wakes at 02:13. It has no network access '
            'and reads only the archive index.',
        icon: 'receipt_long',
      ),
      Clue(
        id: 'ct_note',
        title: 'Sticky note',
        description:
            'The archivist wrote: “The oldest date is the key. Start at the '
            'beginning, not the end.”',
        icon: 'sticky_note_2',
      ),
      Clue(
        id: 'ct_index',
        title: 'Index fragment',
        description:
            'The missing record is tagged 1984. Nearby records are unchanged; '
            'only its final checksum is incomplete.',
        icon: 'data_object',
      ),
    ],
    puzzles: [
      Puzzle(
        id: 'ct_p1',
        type: PuzzleType.multipleChoice,
        prompt: 'Which process is waking the terminal at 02:13?',
        answer: 'RESTORE',
        hint: 'Read the name in the midnight log.',
        options: ['RESTORE', 'UPLINK', 'SLEEP', 'MIRROR'],
      ),
      Puzzle(
        id: 'ct_p2',
        type: PuzzleType.codeEntry,
        prompt: 'Enter the year on the missing archive record.',
        answer: '1984',
        hint: 'The index fragment gives the four-digit year.',
      ),
      Puzzle(
        id: 'ct_p3',
        type: PuzzleType.pattern,
        prompt: 'Complete the archive sequence.',
        answer: '8',
        hint: 'Each number doubles: 1, 2, 4, then the next value.',
        pattern: '01   /   02   /   04   /   ?',
      ),
    ],
  ),
  MysteryCase(
    id: 'missing_file',
    title: 'The Missing File',
    subtitle: 'CASE 002  /  LOST SIGNAL',
    description: 'A vanished file left a trail across three forgotten folders.',
    difficulty: 'MEDIUM',
    story:
        'A research file called LANTERN disappeared from the city lab. No '
        'one deleted it, but the access map shows a trail through folders '
        'that should not exist. Reconstruct the path and discover who—or what—'
        'moved it.',
    ending:
        'LANTERN was moved by an automated cleanup script following a stale '
        'map. You found the hidden folder and restored the research.',
    icon: 'folder_open',
    accentHex: 0xffb99aff,
    clues: [
      Clue(
        id: 'mf_map',
        title: 'Folder map',
        description:
            'The route reads: /lab → /cache → /old → /vault. The vault was '
            'removed from the public directory last winter.',
        icon: 'account_tree',
      ),
      Clue(
        id: 'mf_ticket',
        title: 'Maintenance ticket',
        description:
            'Ticket 317 says the cleanup script sorts files by size, smallest '
            'first, before moving them.',
        icon: 'assignment',
      ),
      Clue(
        id: 'mf_manifest',
        title: 'Broken manifest',
        description:
            'Three files are listed: 12 KB, 4 KB, and 8 KB. LANTERN is the '
            '4 KB file.',
        icon: 'description',
      ),
    ],
    puzzles: [
      Puzzle(
        id: 'mf_p1',
        type: PuzzleType.multipleChoice,
        prompt: 'Which hidden folder is the last stop on the trail?',
        answer: '/vault',
        hint: 'Follow the route in the folder map to its final arrow.',
        options: ['/cache', '/vault', '/lab', '/old'],
      ),
      Puzzle(
        id: 'mf_p2',
        type: PuzzleType.codeEntry,
        prompt: 'What is the maintenance ticket number?',
        answer: '317',
        hint: 'The ticket number is written at the start of the note.',
      ),
      Puzzle(
        id: 'mf_p3',
        type: PuzzleType.pattern,
        prompt: 'Put the file sizes in the script’s sorting order.',
        answer: '4-8-12',
        hint: 'The script sorts from smallest to largest. Separate sizes with hyphens.',
        pattern: '12 KB   /   4 KB   /   8 KB',
      ),
    ],
  ),
  MysteryCase(
    id: 'phantom_signal',
    title: 'The Phantom Signal',
    subtitle: 'CASE 003  /  UNKNOWN TRANSMISSION',
    description: 'A signal with no sender is tapping on the old observatory.',
    difficulty: 'HARD',
    story:
        'For six nights, the abandoned observatory has received the same '
        'three-pulse transmission. There is no transmitter on the ridge, and '
        'the signal stops whenever the weather station powers down. Decode '
        'the pulses before the next storm rolls in.',
    ending:
        'The phantom signal was a weather beacon reflected through a damaged '
        'relay. You decoded its warning and shut down the loop safely.',
    icon: 'sensors',
    accentHex: 0xffffc878,
    clues: [
      Clue(
        id: 'ps_chart',
        title: 'Pulse chart',
        description:
            'The repeating pulse lengths are short, short, long. The pattern '
            'never changes between nights.',
        icon: 'graphic_eq',
      ),
      Clue(
        id: 'ps_weather',
        title: 'Weather station',
        description:
            'The beacon is active only when the station reports pressure '
            'below 1000 hPa.',
        icon: 'cloud',
      ),
      Clue(
        id: 'ps_manual',
        title: 'Relay manual',
        description:
            'The old relay maps short pulses to 1 and long pulses to 0. '
            'Three bits form a single digit.',
        icon: 'menu_book',
      ),
    ],
    puzzles: [
      Puzzle(
        id: 'ps_p1',
        type: PuzzleType.multipleChoice,
        prompt: 'Which pulse sequence repeats?',
        answer: 'Short, short, long',
        hint: 'The pulse chart lists the order from left to right.',
        options: [
          'Long, short, short',
          'Short, long, short',
          'Short, short, long',
          'Long, long, short',
        ],
      ),
      Puzzle(
        id: 'ps_p2',
        type: PuzzleType.codeEntry,
        prompt: 'Using the manual, decode short-short-long as a binary digit.',
        answer: '110',
        hint: 'Short is 1; long is 0. Keep the three pulses in order.',
      ),
      Puzzle(
        id: 'ps_p3',
        type: PuzzleType.pattern,
        prompt: 'What pressure condition activates the beacon?',
        answer: 'below 1000',
        hint: 'The weather station clue gives the threshold and direction.',
        pattern: 'PRESSURE   ?   1000 hPa',
      ),
    ],
  ),
];
