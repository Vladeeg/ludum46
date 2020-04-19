package;

import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.input.keyboard.FlxKey;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;

class Engine extends FlxTypedGroup<FlxSprite> {

    var pistons: Map<FlxKey, FlxSprite>;
    var actualPistons: Map<FlxKey, FlxSprite>;
    var actualPistons2: Map<FlxKey, FlxSprite>;
    var x: Float;
    var y: Float;
    var keys: Map<FlxKey, FlxSprite>;
    var pistonCount: Int;

    public function new(?x: Float = 0, ?y: Float = 0, keys: Array<FlxKey>, keysToString: Map<FlxKey, FlxText>) {
        super();
        this.x = x;
        this.y = y;
        pistons = new Map<FlxKey, FlxSprite>();
        actualPistons = new Map<FlxKey, FlxSprite>();
        actualPistons2 = new Map<FlxKey, FlxSprite>();
        this.keys = new Map<FlxKey, FlxSprite>();
        
        for (k in keys) {
            makePiston(k);
        }

        for (key in keys) {
            var value = pistons.get(key);
            var keySprite = new FlxSprite(value.x + 25 - 16, value.y + 78 + 40);
            keySprite.loadGraphic("assets/images/key.png", true, 32, 32);
            keySprite.animation.add("press", [0, 1, 0], 12, false);
            
            // trace(key.toString());

            // trace(text == null);
            
            var text = keysToString.get(key);
            text.x = keySprite.x + 8;
            text.y = keySprite.y;
            text.scrollFactor.set();
            // keySprite.stamp(text);
            
            keySprite.scrollFactor.set();
            this.keys.set(key, keySprite);
            add(keySprite);
            add(text);
        }
    }

    public function getKeys() {
        return keys;
    }

    public function pushPiston(key: FlxKey) {
        pistons.get(key).animation.play("work");
        actualPistons.get(key).animation.play("work");
        actualPistons2.get(key).animation.play("work");
        keys.get(key).animation.play("press");
    }

    function makePiston(key: FlxKey) {
        var ofstMultiplier = pistonCount * 0.5;
        
        var width = 50;
        var height = 78;
        var ofst = pistonCount % 2 == 0 ? ofstMultiplier * width : -ofstMultiplier * width - (width / 2);
        var piston = new FlxSprite(x + ofst, y);
        piston.loadGraphic(AssetPaths.engine__png, true, width, height);
        piston.scrollFactor.set();
        piston.animation.add("work", [0, 1, 2, 3, 4, 5, 0], 16, false);
        // piston.animation.play("work");
        var actualPiston = new FlxSprite(x + ofst + width * 0.5 - 11.5, y + height - 4);
        actualPiston.scrollFactor.set();
        actualPiston.loadGraphic(AssetPaths.piston__png, true, 23, 30);
        actualPiston.animation.add("work", [0, 1, 0, 2, 3, 4, 0], 16, false);

        var actualPiston2 = new FlxSprite(x + ofst + width * 0.5 - 11.5, y - 30 + 4);
        actualPiston2.scrollFactor.set();
        actualPiston2.loadGraphic(AssetPaths.piston__png, true, 23, 30);
        actualPiston2.animation.add("work", [0, 1, 0, 2, 3, 4, 0], 16, false);
        actualPiston2.flipY = true;

        ++pistonCount;

        pistons.set(key, piston);
        actualPistons.set(key, actualPiston);
        actualPistons2.set(key, actualPiston2);

        add(piston);
        add(actualPiston);
        add(actualPiston2);
    }

}