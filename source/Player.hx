package;

import flixel.FlxObject;
import flixel.FlxG;
import flixel.input.keyboard.FlxKey;
import flixel.FlxSprite;

class Player extends FlxSprite {
    public function new(x: Float = 0, y: Float = 0) {
        super(x, y);

        loadGraphic(AssetPaths.robot__png, true, 64, 64);
        animation.add("idle", [0, 1, 2, 3], 12);
        animation.add("run", [4, 5, 6, 7, 8, 9, 10, 11], 12);
        animation.add("hurt", [12, 13], 12, false);
        animation.add("jump", [14], 12);

        animation.play("run");

        health = 100;
    }

    override public function hurt(damage: Float) {
        super.hurt(damage);

        animation.play("hurt");
    }

    override public function update(elapsed: Float) {
        if (FlxG.keys.anyPressed([FlxKey.UP]) && isTouching(FlxObject.ANY)) {
            velocity.y = -300;
        }

        if (velocity.x == 0) {
            animation.play("idle");
        } else {
            if (animation.curAnim.name == "hurt") {
                if (animation.finished) {
                    animation.play("run");
                }
            } else {
                animation.play("run");
            }
        }

        super.update(elapsed);
    }
}