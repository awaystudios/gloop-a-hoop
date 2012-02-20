package
{
	import Box2DAS.Common.V2;
	import com.away3d.gloop.gameobjects.DefaultGameObject;
	import com.away3d.gloop.gameobjects.Gloop;
	import com.away3d.gloop.gameobjects.hoops.Hoop;
	import com.away3d.gloop.gameobjects.hoops.RocketHoop;
	import com.away3d.gloop.gameobjects.hoops.TrampolineHoop;
	import com.away3d.gloop.gameobjects.Wall;
	import com.away3d.gloop.level.Level;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import wck.WCK;
	import wck.World;
	
	public class MartinMain extends Sprite
	{
		
		private var _level:Level;
		
		public function MartinMain()
		{
			var document:WCK = new WCK;
			addChild(document);
			
			_level = new Level;
			
			var wall:Wall;
			
			var worldW:Number = 768;
			var worldH:Number = 1024;
			var thickness:Number = 100;
			
			wall = new Wall(-thickness / 2, -thickness / 2, worldW + thickness, thickness);
			_level.world.addChild(wall.physics);
			
			wall = new Wall(-thickness / 2, worldH - thickness / 2, worldW + thickness, thickness);
			_level.world.addChild(wall.physics);
			
			wall = new Wall(-thickness/2, -thickness/2, thickness, worldH + thickness);
			_level.world.addChild(wall.physics);
			
			wall = new Wall(worldW - thickness / 2, - thickness / 2, thickness, worldH + thickness);
			_level.world.addChild(wall.physics);
			
			
			//wall = new Wall( -thickness / 2, -thickness / 2, thickness, thickness);
			//wall.physics.x = worldW / 2;
			//wall.physics.y = worldH / 2 + 200;
			//wall.physics.rotation = 45;
			//_level.world.addChild(wall.physics);
			
			
			var hoop:Hoop = new TrampolineHoop( worldW / 2, worldH / 2 + 200);
			_level.world.addChild(hoop.physics);
			
			//addEventListener(Event.ENTER_FRAME, function(e:Event):void {
				//wall.physics.rotation++;
				//wall.physics.body.syncTransform();
			//});
			
			
			
			var gloops:Vector.<DefaultGameObject> = new Vector.<DefaultGameObject>;
			for (var i:int = 0; i < 10; i++) {
				var gloop:Gloop = new Gloop;
				_level.world.addChild(gloop.physics);
				gloops.push(gloop);
			}
			
			document.addChild(_level.world);
			
			
			var reset:Function = function():void {
				for each (gloop in gloops) {
					gloop.physics.x = worldW / 2 - Math.random();
					gloop.physics.y = worldH / 2 - Math.random();
					gloop.physics.rotation = 0;
					gloop.physics.b2body.SetAngularVelocity(0);
					gloop.physics.b2body.SetLinearVelocity(new V2(0, 0));
					gloop.physics.body.syncTransform();
				}	
			}
			
			reset();

			stage.addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent):void {
				if (e.keyCode == Keyboard.SPACE) reset();
				if (e.keyCode == Keyboard.PERIOD) hoop.physics.b2body.SetTransform(hoop.physics.b2body.GetPosition(), 45);
				if (e.keyCode == Keyboard.S) hoop.physics.setStatic(!hoop.physics.isStatic);
			});
		}
	}
}