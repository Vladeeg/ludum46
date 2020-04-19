package;

import openfl.filters.GlowFilter;
import flixel.graphics.frames.FlxFilterFrames;
import openfl.filters.BlurFilter;
import flixel.FlxSprite;

class BeatHolder {

    public var beatIndex: Int;
    public var timestamp: Float;
    var beatTime: Float;
    public var threshold: Float;
    var heatTime: Float;

    public var sprite: FlxSprite;

    public function new(
        timestamp: Float,
        beatIndex: Int,
        beatTime: Float,
        missThreshold: Float,
        heatTime: Float,
        x: Float,
        y: Float
    ) {
        this.beatIndex = beatIndex;
        this.timestamp = timestamp;
        this.beatTime = beatTime;
        this.threshold = missThreshold;
        this.heatTime = heatTime;

        sprite = new FlxSprite(x, y);
        sprite.makeGraphic(10, 10);

        var filter = new GlowFilter(0x0000FF, 1, 10, 10, 1.5, 1);
        // spriteFilter = createFilterFrames(spr3, blurFilter);
        var filterFrames = FlxFilterFrames.fromFrames(sprite.frames, 5, 5, [filter]);
        // updateFilter(sprite, filterFrames);
        filterFrames.applyToSprite(sprite, false, true);
		// return filterFrames;
    }

    public function heat(curTimestamp: Float) {
        // trace('timestamp: $timestamp, currentTimestamp: $curTimestamp');
        return (timestamp - curTimestamp) / heatTime;
    }

    public function checkAccuracy(pressTimestamp: Float) {
        return Math.abs(pressTimestamp - timestamp) / beatTime > threshold;
    }

    public function miss(curTimestamp: Float) {
        var howMuchMissed = (curTimestamp - timestamp) / beatTime;

        // trace('howMuchMissed: $howMuchMissed');

        return howMuchMissed > threshold;
    }

}
