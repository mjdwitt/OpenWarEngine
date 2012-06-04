# Game Engine API

This document details the API for making requests of the game engine
and the JSON formatting used to communicate data to and from the
engine. 

The game engine expects all data it receives to be in JSON and
formats all of its replys in JSON as well. In order to send the
engine any data, one always includes three different pieces of data:
the current game state, the modification request object, and the
nation making the request. (This document assumes a foreknowledge of
JSON. See the official [JSON website](http://www.json.org) for more
information.)

All replies are returned as an object of two string-value pairs: a
summary of the action taken and the (possibly) modified game state.

	{ "summary" : string
	, "newGameState" : gameState
	}

If a request was denied, the summary will begin with the string
"Denied."

All definitions are case *sensitive*.

## Request objects

	{ "gameState" : gameState
	, "nation" : strNation
	, "request" :
		{ "name" : reqName
		, "params" :
			{ param1 : val1
			, ...
			}
		}
	}

As stated above, requests are formed of three objects, the game
state, the requesting player's nation, and the modification request.

### API requests

Possible `reqName`s are listed below in bold with documentation of
their corresponding purpose and parameter object.

**research**

	{ "name"   : "research"
	, "params" : { "dice" : positiveInteger }
	}

Requests to purchase and roll a number of research dies. Alters the
player's balance and updates their known tech if the research is
successful.

**purchaseUnits**

	{ "name"   : "purchaseUnits"
	, "params" : { "unitCounts" : arrUnits }
	}

Requests to purchase a number of units to be placed later. Alters the
player's balance and places purchased units in the player's state.

**combatMoves**

	{ "name"   : "combatMoves"
	, "params" :
		{ "movements" :
			[ { "route" : arrStrZone
			  , "units" : arrUnits
			  }
			, ...
			]
		}
	}

Perform a collection of moves which initiate combat and/or armor
blitzes. `"route"` is an array of zone names through which the
associated `"units"` will move. Movements will be performed in the
order in which they appear in the movements array. The final zone
in any route must be a hostile zone, unless a blitz was performed
by an army of tanks. If the units detailed in the unit count array
are not present in the first zone in the route, than the request as
a whole will be denied and no modifications will be made.

**combat**

todo

**noncombatMoves**

	{ "name"   : "noncombatMoves"
	, "params" :
		{ "movements" :
			[ { "route" : arrStrZone
			  , "units" : arrUnits
			  }
			, ...
			]
		}
	}

Perform a collection of moves through friendly zones. The parameters
are of the same form as `combatMoves`. If any of the zones in the
route are hostile, the entire request will be denied and no
modifications will be made.

**placeUnits**

	{ "name"   : "placeUnits"
	, "params" :
		{ "placements" :
			[ { "zoneName" : strZoneName
			  , "units"    : arrUnits
			  }
			, ...
			]
		}
	}

Removes units from the player's stockpile of unplaced units and
places them on the board in specified zones. The single parameter
is an array of placement objects where `"zoneName"` is a zone in
which to place the `"units"` (which are represent by a unit count
array of twelve non-negative integers.)


**collectIncome**

	{ "name"   : "collectIncome"
	, "params" : null
	}

Updates the player's income and adds the new income to the player's
balance. Takes no parameters.
	

### The gameState object

	{ "Russia"  : player
	, "Germany" : player
	, "Britain" : player
	, "Japan"   : player
	, "America" : player
	, "board"   : board
	}

The game state is represented as an object of six string-value pairs,
one for each player and one for the board, where the strings are the
players' nations or simply "board". The values for the players are
also objects and the board's value is an array.

#### The player object

	{ "nation"         : strNation
	, "income"         : integer
	, "balance"        : integer
	, "purchasedUnits" : arrUnits
	, "researchedTech" : arrTech
	}

+ The `"nation"` must be one of these strings: `"Russia"`,
  `"Germany"`, `"Britain"`, `"Japan"`, or `"America"`.
+ `"income"` and `"balance"` are both positive integers.
+ `"purchasedUnits"` is an array of unit counts.
+ `"researchedTech"` is an array of strings describing the tech
  that the player may have researched. Any strings must be one of
  `"JetPower"`, `"Rockets"`, `"SuperSubs"`, `"LongRangeAircraft"`,
  `"IndustrialTech"`, or `"HeavyBombers"`.

##### The units counts array

	[ infantry
	, artillery
	, armors
	, antiair
	, factories
	, fighters
	, bombers
	, battleships
	, destroyers
	, carriers
	, transports
	, submarines
	]

An array of twelve non-negative integers representing the number
of units of each type.

#### The board array

The board is a simple array of zones, which are represented as
objects.

	[ { "name"  : string
	  , "value" : integer
	  , "water" : boolean
	  , "owner" : strNation
	  , "color" : strNation
	  , "units" : objUnits
	  , "adjacentZones" : arrNames
	  }
	, ...
	]

The name, value, and water fields are simply represented by a string,
positive integer, and a boolean, respectively. The remaining fields,
however, have some more complex restrictions. 

+ The `"owner"` must be one of these strings: `"Russia"`,
  `"Germany"`, `"Britain"`, `"Japan"`, or `"America"`.
+ The `"color"` is meant to represent the original owner
  (and implicitly, the color of the zone on the board) and can
  be any of the same strings as the owner field or one of the
  additional strings, `"Neutral"`, or `"Sea"`.
+ `"units"` represents the five players' units present in the zone
  as an object of five arrays, each of which contain twelve numbers
  for the number of each of the twelve unit types:
  
		{ "Russia"  : [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
		, "Germany" : ...
		, "Britain" : ...
		, "Japan"   : ...
		, "America" : ...
		}

+ `"adjacentZones"` is an array of the names of each of the zone's
  neighbors. Each entry in this array must be a valid name or
  catastrophic errors could occur. For instance, a zone named "Foo"
  might have an array of adjacent territories that looks like
  `["Bar", "Baz", "Quux"]`.