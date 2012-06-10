# Game Engine API

This document details the API for making requests of the game engine
and the JSON formatting used to communicate data to and from the
engine.

The game engine API is made available to clients local to its
machine, namely the game client which interacts with the players'
clients and the database. Calls are made by sending HTTP requests
to the API server at `http://localhost:1942`. 

All message bodies in requests and responses are of content-type
`application/json`. This document assumes a foreknowledge of JSON.
See the official [JSON website](http://www.json.org) for more
information. All of the following definitions are case *sensitive*.

## Responses

	HTTP/1.1 200 OK
	Content-Type: application/json
	
	{ "summary"   : string
	, "gameState" : gameState
	}

Most replies are returned as an object of two string-value pairs: a
summary of the action taken and the (possibly) modified game state.
When the requesting player receives this reply object, it is
simultaneously made available to the other players' clients (via
Android push notifications, if possible.)

If a request was denied, the summary will begin with the string
"Denied."

Some combat-related interactions will reply with something other
than this uniform reply object. See below for details.

## Requests

	POST /<requestResource> HTTP/1.1
	Host: localhost:1942
	Content-Type: application/json
	
	{ "game"   : gameState
	, "nation" : strNation
	, "params" :
		{ param1 : val1
		, ...
		}
	}

In order to send the engine requests, one always includes three
different pieces of data: the current game state, the modification
request parameters, and the nation making the request.

### Simple API requests

Possible `<requestResources>`s are listed below in bold with documentation of
their corresponding purpose and parameter object.

**`/research`**

	{ ...
	, "params" : { "dice" : positiveInteger }
	}

Requests to purchase and roll a number of research dies. Alters the
player's balance and updates their known tech if the research is
successful.

**`/purchaseUnits`**

	{ ...
	, "params" : { "unitCounts" : arrUnits }
	}

Requests to purchase a number of units to be placed later. Alters the
player's balance and places purchased units in the player's state.

**`/combatMoves`**

	{ ...
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
order in which they appear in the movements array. 

For most units, the final zone in any route must be a hostile zone
and all the other zones must be friendly. There are, however, many
exceptions:

+ Tanks can *blitz* through unoccupied hostile zone and end in
  either friendly or hostile zone. The player takes control of the
  blitzed territory with no combat.
  
+ Aircraft can fly over hostile zones as if they were friendly. No
  combat occurs and the player does *not* take control of unoccupied
  hostile zones along the route.
  
  Any zones containing hostile antiair, however, get to roll an
  attack against each aircraft (hitting on a one or less.) If any
  attacks are successful, the hit aircraft will simply not arrive
  at its destination and be removed from the board.
  
+ Aircraft which remain aboard carriers in this phase are unable
  to participate in combat in the next phase. If their carrier
  enters combat with them aboard and is sunk, they sink with
  the carrier.

+ Submarines can move through hostile sea zones as if they were
  friendly, unless those zones contain a destroyer. If a sub's
  movement ends in a hostile sea zone, it will engage in combat
  in the next phase.
  
+ *Transport pickup needs to be clarified. I'll have to add some
  special parameters or something in order describe this via the
  API. Ditto for amphibious assaults, which must be declared in
  this phase.*

If the units detailed in the unit count array
are not present in the first zone in the route, than the request as
a whole will be denied and no modifications will be made.

*Combat API calls are much more complex than all of the other
phases' calls, requiring multiple players' real-time input and
synchronization between clients. See the section below for details.*

**`/noncombatMoves`**

	{ ...
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

**`/placeUnits`**

	{ ...
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


**`/collectIncome`**

	{ ...
	, "params" : null
	}

Updates the player's income and adds the new income to the player's
balance. Takes no parameters.

### Combat API calls and replies

Many combat-related client-server interactions deviate from the
simpler request-modification-receive-new-game-state loop of the
above calls. As such, there are different combat request resources
located under `/combat/` for different types of modification
requests.

Combat is initiated by the server after it performs the attacker's
combat movements and finds that any destination or blitz zones
contain hostile units. The server selects an embattled zone and
intiates combat there. The battle is resolved through successive
interactions between the attacker and defender and then the server
selects the next embattled zone and initiates combat there. If there
are no embattled zones remaining, the combat phase ends and the
server notifies the attacker that it is now awaiting their
noncombat movements.

When combat starts, the server creates a *battleState* object which
stores information about the battle. A battle sequence of actions
follows the order described below:

*to be completed*

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

#### The turn object

Turn information must be supplied in the game state by