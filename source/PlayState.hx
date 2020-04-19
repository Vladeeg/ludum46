package;

import flixel.ui.FlxBar;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.input.keyboard.FlxKey;
import haxe.Timer;
import flixel.system.FlxSound;
import flixel.tile.FlxTilemap;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;

class PlayState extends FlxState
{
	var player: Player;
	var road: FlxTilemap;

	var engine: Engine;
	
	var track: Array<Int>;
	var measureSize: Int = 16;
	var currentMeasure: Int;
	var bpm: Float = 120;
	var beatTime: Float;

	var beatMapping: Map<Int, FlxSound>;
	var time: Float;
	var curBeat: Int;
	var musicStartTime: Float;
	var bg: FlxSprite;
	// var bg2: Parallax;
	var bg2: FlxBackdrop;
	var pressed: Float;

	var heatTime: Float;

	var keys: Map<FlxKey, Array<BeatHolder>>;
	var keysArray: Array<FlxKey>;
	var addedBeats: Array<Int>;
	var nextPressAllowedTimes: Map<FlxKey, Float>;

	var playing: Bool;

	var beatmapInfo: OsuBeatmapInfo;
	var music: FlxSound;

	var bigBoy: FlxSprite;

	override public function create()
	{
		FlxG.mouse.visible = false;
		bg = new FlxSprite(0, 0);
		bg.loadGraphic(AssetPaths.bg1__png, false, 800, 500);
		bg.scrollFactor.set();
		add(bg);
		// bg2 = new Parallax(0.9, AssetPaths.bg2__png);
		bg2 = new FlxBackdrop(AssetPaths.bg2__png, 0.92, 0, true, false);
		add(bg2);
		currentMeasure = 0;

		bigBoy = new FlxSprite(FlxG.width * 2);
		bigBoy.loadGraphic(AssetPaths.giant__png, true, 305, 500);
		bigBoy.animation.add("move", [0, 1, 2], 3);
		bigBoy.scrollFactor.set(1, 0);
		bigBoy.animation.play("move");
		add(bigBoy);

		// beatTime = 60 / (bpm * 4);

		beatmapInfo = OsuBeatmapReader.readFromFile("assets/data/beatmap.osu");
		beatTime = beatmapInfo.timePointsBpm[0] / 1000;
		heatTime = beatTime * 4;

		track = beatmapInfo.hitObjectTimes;
		if (track[track.length - 1] < track[track.length - 2]) {
			track[track.length - 1] = track[track.length - 2] + 1000;
		}
		trace('track:  $track');
		trace("music: " + beatmapInfo.filename);
		trace("beatTime: " + beatTime);
		#if desktop
		var fnameparts = beatmapInfo.filename.split(".");
		var fname = "";
		for (i in 0...fnameparts.length - 1) {
			fname += fnameparts[i] + ".";
		}
		fname += "wav";
		trace(fname);
		beatmapInfo.filename = fname;
		#end
		// music = FlxG.sound.load("assets/music/The Pretender.wav");
		music = FlxG.sound.load("assets/music/" + beatmapInfo.filename);
		trace("musicLength: " + music.length);

		curBeat = 0;
		// track = [0, 0, 0, 1,  0, 0, 0, 2,  0, 0, 0, 1,  0, 0, 0, 2,  0, 0, 0, 1,  0, 0, 0, 2,  0, 0, 0, 1,  0, 2, 0, 2];
		// var length = track.length;
		// for (_ in 0...100) {
		// 	for (j in 0...length) {
		// 		track.push(track[j]);
		// 	}
		// }


		// beatMapping = new Map<Int, FlxSound>();
		// beatMapping.set(1, FlxG.sound.load(AssetPaths.bass_drop__wav));
		// beatMapping.set(2, FlxG.sound.load(AssetPaths.hi_hat__wav));

		// beatHolders = new Array<BeatHolder>();
		keysArray = new Array<FlxKey>();
		keysArray.push(FlxKey.J);
		keysArray.push(FlxKey.F);
		keysArray.push(FlxKey.K);
		keysArray.push(FlxKey.D);
		var keysToString = new Map<FlxKey, FlxText>();

		
		var keyText = new FlxText(0, 0, 0, "K", 12);
		keyText.color = FlxColor.BLACK;
		keysToString.set(FlxKey.K, keyText);

		keyText = new FlxText(0, 0, 0, "F", 12);
		keyText.color = FlxColor.BLACK;
		keysToString.set(FlxKey.F, keyText);

		keyText = new FlxText(0, 0, 0, "D", 12);
		keyText.color = FlxColor.BLACK;
		keysToString.set(FlxKey.D, keyText);

		keyText = new FlxText(0, 0, 0, "J", 12);
		keyText.color = FlxColor.BLACK;
		keysToString.set(FlxKey.J, keyText);

		keys = new Map<FlxKey, Array<BeatHolder>>();
		for (k in keysArray) {
			keys.set(k, new Array<BeatHolder>());
		}

		addedBeats = new Array<Int>();
		nextPressAllowedTimes = new Map<FlxKey, Float>();

		player = new Player();
		player.acceleration.y = 800;
		// player.y += 123;
		FlxG.camera.follow(player);
		// FlxG.camera.setScrollBounds(0, null, 0, 1600);
		add(player);
		
		engine = new Engine(FlxG.width * 0.5, 50, keysArray, keysToString);
		add(engine);

		playing = false;

		
		road = new FlxTilemap();
		road.loadMapFrom2DArray(
			[for (_ in 0...3) [for (_ in 0...Std.int(track[track.length - 1])) 0]],
			AssetPaths.tiles__png,
			32,
			32
		);
		road.y = player.y + player.height;
		fillPlatform(road, Std.int(track[track.length - 1]));
		// road = new FlxBackdrop(AssetPaths.tiles__png, 1, 0, true, false);

		add(road);

		var healthBar = new FlxBar(10, 10, null, 100, 10, player, "health", 0, 100, true);
		healthBar.scrollFactor.set();
		add(healthBar);

		super.create();
	}

	function start() {
		playing = true;
		// music.play();
		music.fadeIn();
		musicStartTime = Timer.stamp();
		player.velocity.x = 200;
		bigBoy.velocity.x = 50;
	}

	function findPossibleKeysToHoldBeat(beatHoldersHolders: Map<FlxKey, Array<BeatHolder>>, beatIndex: Int) {
		var possible = new Array<FlxKey>();
		for (k => v in beatHoldersHolders) {
			var possiblyPossible = v.filter(function(bh) {
				return bh != null && bh.beatIndex == beatIndex;
			});
			if (possiblyPossible.length == 0) {
				possible.push(k);
			}
		}

		var min = 99999999;
		for (k in possible) {
			var v = keys.get(k);
			if (v.length < min) {
				min = v.length;
			}
		}

		for (k in possible) {
			var v = keys.get(k);
			if (v.length != min) {
				possible.remove(k);
			}
		}

		return possible;
	}

	override public function draw() {
		super.draw();

		if (playing) {
			var secondsPassed = Timer.stamp() - musicStartTime;
			// var secondsPassed = music.
			var prevBeat = curBeat;
			// curBeat = Std.int(secondsPassed / beatTime);
			
			for (i in 0...8) {
				var beatToAdd = curBeat + i;
				// trace('beatToAdd: $beatToAdd');
				// trace("track length: " + track.length);
				if (addedBeats.indexOf(beatToAdd) < 0 && beatToAdd > 0 && beatToAdd < track.length) {
					if (track[beatToAdd] > 0) {
						var possibleKeys = findPossibleKeysToHoldBeat(keys, beatToAdd);
						// var possibleKeys = [FlxKey.J];
						if (possibleKeys.length > 0) {
							var randomKey = possibleKeys[FlxG.random.int(0, possibleKeys.length - 1)];
							var enginePiston = engine.getKeys().get(randomKey);
							var holderToPush = new BeatHolder(
								track[beatToAdd] / 1000,
								curBeat + i,
								beatTime,
								0.5,
								heatTime,
								enginePiston.x + enginePiston.width * 0.5 - 5,
								enginePiston.y
							);
							holderToPush.sprite.scrollFactor.set();
							add(holderToPush.sprite);
							keys.get(randomKey)
								.push(holderToPush);
							addedBeats.push(beatToAdd);
						}
					}
				}
			}

			// var curTime = Timer.stamp();
			for (k => v in keys) {
				var enginePiston = engine.getKeys().get(k);

				for (e in v) {
					// trace("noteposition: " + e.sprite.getPosition());
					// trace("heat: " + e.heat(secondsPassed));
					if (e != null) {
						e.sprite.y = enginePiston.y + e.heat(secondsPassed) * (enginePiston.y + 300);
					}
				}
			}

			if (curBeat >= 0 && curBeat < track.length) {
				if (secondsPassed > track[curBeat] / 1000) {
					while (curBeat < track.length && secondsPassed > track[curBeat] / 1000) {
						++curBeat;
					}
				}
			}

		} else {
			if (FlxG.keys.anyJustPressed([FlxKey.SPACE])) {
				start();
			}
		}
	}

	function fuckedUp() {
		FlxG.camera.flash(FlxColor.WHITE);
		// FlxG.camera.shake();
		player.hurt(10);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		road.follow();
		FlxG.collide(player, road);
		if (playing) {
			var secondsPassed = Timer.stamp() - musicStartTime;
			for (k => v in keys) {
				// var nextPressAllowedTime = nextPressAllowedTimes.get(k);
				if (/*(nextPressAllowedTime == null || nextPressAllowedTime < secondsPassed) && */
					FlxG.keys.anyJustPressed([k])
				) {
					// nextPressAllowedTimes.set(k, secondsPassed + beatTime);
					var beatHolder = v.shift();
					if (beatHolder != null) {
						engine.pushPiston(k);
						if (beatHolder.checkAccuracy(secondsPassed)) {
							fuckedUp();
						}
						remove(beatHolder.sprite);
						beatHolder.sprite.destroy();
					}
				}
				var beatHolder = v[0];
				if (beatHolder != null) {
					if (beatHolder.miss(secondsPassed)) {
						remove(beatHolder.sprite);
						beatHolder.sprite.destroy();
						fuckedUp();
						v.shift();
					}
				}
			}

			if (player.x - bigBoy.x > FlxG.width) {
				bigBoy.x = player.x + FlxG.width * FlxG.random.int(2, 4);
			}


			if (playing) {
				if (player.health <= 5) {
					lose();
				}
			}
			player.health += elapsed;

			if (curBeat >= track.length) {
				win();
			}
		}
	}

	function win() {
		playing = false;
		music.fadeOut();
		FlxG.camera.fade(FlxColor.WHITE, 1, false,
			function() {
				FlxG.switchState(new WinState());
			}
		);
	}

	function lose() {
		playing = false;
		music.fadeOut();
		FlxG.camera.fade(FlxColor.WHITE, 1, false,
			function() {
				FlxG.switchState(new LoseState());
			}
		);
	}

	function fillPlatform(platform: FlxTilemap, length: Int) {
		var currentHeight = 0;

		var i = 0;
		while (i < length) {
			var tileToSet = 1;
			// if (track[i] != 0) {
			// 	// currentHeight = track[i];
			// } else {
			// 	tileToSet = 1;
			// }
			platform.setTile(2 * i, currentHeight, tileToSet);
			platform.setTile(2 * i + 1, currentHeight, tileToSet);
			++i;
		}
	}

}
