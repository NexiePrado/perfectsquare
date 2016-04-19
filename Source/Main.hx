package;

import motion.Actuate;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.events.TouchEvent;

class Main extends Sprite {
	private var minSize:Float = 32;
	private var maxSize:Float = 96;
	
	private var score:Int = 0;
	private var squareSize:Float = 0;
	private var wallSize:Float = 0;
	
	private var leftWall:Sprite;
	private var leftSquare:Sprite;
	private var rightWall:Sprite;
	private var rightSquare:Sprite;
	
	private var cube:Sprite;
	private var size:Float = 32;
	private var touched:Bool = false;
	private var falling:Bool = false;
	
	public function new () {
		super ();
		squareSize = Random.range(minSize, maxSize);
		wallSize = Random.range(squareSize+16, squareSize+64);
		createWallsAndSquares();
		
		cube = new Sprite();
		cube.x = stage.stageWidth / 2;
		cube.y = 100;
		
		cube.graphics.beginFill(0xffffff);
		cube.graphics.drawRect( -16, -16, 32, 32);
		cube.graphics.endFill();
		
		addChild(cube);
		
		addEventListener(Event.ENTER_FRAME, tick);
		/*stage.addEventListener(TouchEvent.TOUCH_BEGIN, touchBegin);
		stage.addEventListener(TouchEvent.TOUCH_END, touchEnd);*/
		addEventListener(MouseEvent.MOUSE_DOWN, touchBegin);
		addEventListener(MouseEvent.MOUSE_UP, touchEnd);
	}
	
	var k:Float = 0;
	function tick(e:Event):Void {
		if (!falling) cube.rotation = Math.sin(k += 0.1) * 20;
		if (touched) {
			size += 1;
			cube.graphics.clear();
			cube.graphics.beginFill(0xffffff);
			cube.graphics.drawRect( -size / 2, -size / 2, size, size);
			cube.graphics.endFill();
		}
	}
	
	function touchBegin(t:Event) {
		if (!falling) touched = true;
	}
	
	function touchEnd(t:Event) {
		touched = false;
		fall();
	}
	
	function next() {
		squareSize = Random.range(minSize, maxSize);
		wallSize = Random.range(squareSize+16, squareSize+64);
		
		Actuate.tween(leftWall, .5, {x: -wallSize / 2});
		Actuate.tween(leftSquare, .5, {x: -squareSize / 2});
		Actuate.tween(rightWall, .5, {x: (stage.stageWidth + wallSize) / 2});
		Actuate.tween(rightSquare, .5, {x: (stage.stageWidth + squareSize) / 2});
		
		Actuate.tween(cube, .5, {y: 100, scaleX: 32 / size, scaleY: 32 / size}).onComplete(function() {
			cube.scaleX = cube.scaleY = 1;
			cube.graphics.clear();
			cube.graphics.beginFill(0xffffff);
			cube.graphics.drawRect( -16, -16, 32, 32);
			cube.graphics.endFill();
		});
		
		size = 32;
		
		falling = false;
		score++;
	}
	
	function fall() {
		falling = true;
		Actuate.tween(cube, .5, {rotation: 0});
		var yy:Float = 0;
		if (size > squareSize && size < wallSize) {
			yy = stage.stageHeight - 100 - size / 2;
		} else if (size > wallSize) {
			yy = stage.stageHeight - 150 - size / 2;
		} else {
			yy = stage.stageHeight + size;
		}
		Actuate.tween(cube, .5, {y: yy}).delay(.5);
		Actuate.timer(2).delay(1).onComplete(function() {next(); });
	}
	
	function createWallsAndSquares():Void {
		var bg:Sprite = new Sprite();
		bg.graphics.beginFill(0xff8080);
		bg.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
		bg.graphics.endFill();
		addChild(bg);
		
		leftSquare= new Sprite();
		leftSquare.x = -squareSize / 2;
		leftSquare.y = stage.height - 100;
		leftSquare.graphics.beginFill(0xffffff);
		leftSquare.graphics.drawRect(0, 0, 160, 100);
		leftSquare.graphics.endFill();
		addChild(leftSquare);
		
		leftWall = new Sprite();
		leftWall.x = -wallSize / 2;
		leftWall.y = stage.height - 150;
		leftWall.graphics.beginFill(0xffffff);
		leftWall.graphics.drawRect(0, 0, 160, 50);
		leftWall.graphics.endFill();
		addChild(leftWall);
		
		rightSquare = new Sprite();
		rightSquare.x = (stage.stageWidth + squareSize) / 2;
		rightSquare.y = stage.height - 100;
		rightSquare.graphics.beginFill(0xffffff);
		rightSquare.graphics.drawRect(0, 0, 160, 100);
		rightSquare.graphics.endFill();
		addChild(rightSquare);
		
		rightWall = new Sprite();
		rightWall.x = (stage.stageWidth + wallSize) / 2;
		rightWall.y = stage.height - 150;
		rightWall.graphics.beginFill(0xffffff);
		rightWall.graphics.drawRect(0, 0, 160, 50);
		rightWall.graphics.endFill();
		addChild(rightWall);
	}
}