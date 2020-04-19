package;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tile.FlxTileblock;

class GroundPlatform extends FlxTypedGroup<FlxTileblock> {

    var currentPlatform: Int;
    var platforms: Array<FlxTileblock>;

    public function new(x: Int, y: Int) {
        super(2);

        platforms = new Array<FlxTileblock>();
        platforms[0] = new FlxTileblock(x, 314, 800, 32);
        platforms[1] = new FlxTileblock(Std.int(x + platforms[0].width), 314, 800, 32);
        add(platforms[0]);
        add(platforms[1]);
        currentPlatform = 0;
    }

    override public function update(elapsed: Float) {
        if (platforms[currentPlatform].x == -platforms[currentPlatform].width) {
            ++currentPlatform;
            currentPlatform %= 2;
        }
    }
}