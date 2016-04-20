package;

import flash.text.FontStyle;
import flash.text.TextFormat;
import motion.Actuate;
import openfl.Assets;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.events.TouchEvent;
import openfl.text.Font;
import openfl.text.TextField;
import openfl.text.TextFormatAlign;

class Main extends Sprite {
	private static var font:Font = Assets.getFont("fonts/chunkfive.otf");
	
	private var bgColors:Array<Int> = [0x62bd18, 0xff5300, 0xd21034, 0xff475c, 0x8f16b2, 0x588c7e, 0x8c4646];
	private var bgColor:Int;
	
	private var minSize:Float = 40;
	private var maxSize:Float = 240;
	
	private var score:Int = 1;
	private var level:Int = 1;
	
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
	
	private var message:TextField;
	private var scoreText:TextField;
	
	public function new () {
		super ();
		
		bgColor = bgColors[Math.floor(Math.random() * bgColors.length)];
		
		squareSize = Math.round(Random.range(minSize, maxSize));
		wallSize = Math.round(Random.range(squareSize+10, squareSize+70));
		createWallsAndSquares();
		
		stage.color = bgColor;
		
		cube = new Sprite();
		cube.x = stage.stageWidth / 2;
		cube.y = 100;
		
		cube.graphics.beginFill(0xffffff);
		cube.graphics.drawRect( -16, -16, 32, 32);
		cube.graphics.endFill();
		
		addChild(cube);
		
		message = new TextField();
		message.defaultTextFormat = new TextFormat(font.fontName, 32, 0xffffff);
		message.embedFonts = true;
		message.text = "LEVEL 1";
		message.alpha = .5;
		message.width = stage.stageWidth;
		message.selectable = false;
		message.x = (stage.stageWidth - message.textWidth) / 2;
		addChild(message);
		
		scoreText = new TextField();
		scoreText.defaultTextFormat = new TextFormat(font.fontName, 16, bgColor);
		scoreText.embedFonts = true;
		scoreText.text = "1";
		scoreText.selectable = false;
		scoreText.x = -1-scoreText.textWidth / 2;
		scoreText.y = -scoreText.textHeight / 2;
		cube.addChild(scoreText);
		
		addEventListener(Event.ENTER_FRAME, tick);
		/*stage.addEventListener(TouchEvent.TOUCH_BEGIN, touchBegin);
		stage.addEventListener(TouchEvent.TOUCH_END, touchEnd);*/
		stage.addEventListener(MouseEvent.MOUSE_DOWN, touchBegin);
		stage.addEventListener(MouseEvent.MOUSE_UP, touchEnd);
	}
	
	var k:Float = 0;
	function tick(e:Event):Void {
		if (!falling) cube.rotation = Math.sin(k += 0.1) * 20;
		if (touched) {
			size += 2;
			cube.scaleX = cube.scaleY = size / 32;
		}
	}
	
	function touchBegin(t:Event) {
		if (!falling) touched = true;
	}
	
	function touchEnd(t:Event) {
		touched = false;
		fall();
	}
	
	function next(?loose:Bool = false) {
		if (loose) {
			bgColor = bgColors[Math.floor(Math.random() * bgColors.length)];
			score = level;
		} else {
			score--;
			if (score <= 0) {
				level++;
				score = level;
				bgColor = bgColors[Math.floor(Math.random() * bgColors.length)];
			}
		}
		
		message.text = "LEVEL " + level;
		scoreText.text = "" + score;
		
		stage.color = bgColor;
		scoreText.textColor = bgColor;
		
		squareSize = Random.range(minSize, maxSize);
		wallSize = Random.range(squareSize+16, squareSize+64);
		
		Actuate.tween(leftWall, .5, {x: -wallSize / 2});
		Actuate.tween(leftSquare, .5, {x: -squareSize / 2});
		Actuate.tween(rightWall, .5, {x: (stage.stageWidth + wallSize) / 2});
		Actuate.tween(rightSquare, .5, {x: (stage.stageWidth + squareSize) / 2});
		
		Actuate.tween(cube, .5, {y: 100, scaleX: 1, scaleY: 1});
		
		size = 32;
		
		falling = false;
	}
	
	function fall() {
		falling = true;
		Actuate.tween(cube, .5, {rotation: 0});
		var yy:Float = 0;
		var loose:Bool = false;
		if (size > squareSize && size < wallSize) {
			yy = stage.stageHeight - 100 - size / 2; // WIN
		} else if (size > wallSize) {
			yy = stage.stageHeight - 150 - size / 2; // LOOSE
			loose = true;
		} else {
			yy = stage.stageHeight + size; // LOOSE
			loose = true;
		}
		if (loose) {
			message.text = "SORRY!";
		}
		Actuate.tween(cube, .5, {y: yy}).delay(.5);
		Actuate.timer(1).delay(1).onComplete(function() {next(loose); });
	}
	
	function createWallsAndSquares():Void {
		/*var bg:Sprite = new Sprite();
		bg.graphics.beginFill(bgColor);
		bg.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
		bg.graphics.endFill();
		addChild(bg);*/
		
		leftSquare = new Sprite();
		leftSquare.x = -squareSize / 2;
		leftSquare.y = stage.stageHeight - 100;
		leftSquare.graphics.beginFill(0xffffff);
		leftSquare.graphics.drawRect(0, 0, 160, 100);
		leftSquare.graphics.endFill();
		addChild(leftSquare);
		
		leftWall = new Sprite();
		leftWall.x = -wallSize / 2;
		leftWall.y = stage.stageHeight - 150;
		leftWall.graphics.beginFill(0xffffff);
		leftWall.graphics.drawRect(0, 0, 160, 50);
		leftWall.graphics.endFill();
		addChild(leftWall);
		
		rightSquare = new Sprite();
		rightSquare.x = (stage.stageWidth + squareSize) / 2;
		rightSquare.y = stage.stageHeight - 100;
		rightSquare.graphics.beginFill(0xffffff);
		rightSquare.graphics.drawRect(0, 0, 160, 100);
		rightSquare.graphics.endFill();
		addChild(rightSquare);
		
		rightWall = new Sprite();
		rightWall.x = (stage.stageWidth + wallSize) / 2;
		rightWall.y = stage.stageHeight - 150;
		rightWall.graphics.beginFill(0xffffff);
		rightWall.graphics.drawRect(0, 0, 160, 50);
		rightWall.graphics.endFill();
		addChild(rightWall);
	}
}