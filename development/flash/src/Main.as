package
{
	import Box2DAS.Common.V2;
	import com.away3d.gloop.gameobjects.DefaultGameObject;
	import com.away3d.gloop.gameobjects.Gloop;
	import com.away3d.gloop.gameobjects.Wall;
	import com.away3d.gloop.level.Level;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Rectangle;
	import wck.WCK;
	import wck.World;
	
	public class Main extends Sprite
	{
		
		private var _level:Level;
		
		public function Main()
		{
			var document:WCK = new WCK;
			addChild(document);
			
			_level = new Level;
			
			var wall:Wall;
			
			var worldW:Number = 768;
			var worldH:Number = 1024;
			var thickness:Number = 100;
			
			wall = new Wall(worldW/2, 0, worldW, thickness);
			_level.world.addChild(wall.physics);
			
			wall = new Wall(worldW/2, worldH, worldW, thickness);
			_level.world.addChild(wall.physics);
			
			wall = new Wall(0, worldH/2, thickness, worldH);
			_level.world.addChild(wall.physics);
			
			wall = new Wall(worldW, worldH/2, thickness, worldH);
			_level.world.addChild(wall.physics);
			
			
			document.addChild(_level.world);
			
			var gloops:Vector.<DefaultGameObject> = new Vector.<DefaultGameObject>;
			
			for (var i:int = 0; i < 10; i++) {
				var gloop:Gloop = new Gloop;
				_level.world.addChild(gloop.physics);
				gloops.push(gloop);
			}		
			
			var reset:Function = function():void {
				for each (gloop in gloops) {
					gloop.physics.x = worldW / 2;
					gloop.physics.y = worldH / 2;
					gloop.physics.rotation = 0;
					gloop.physics.b2body.SetAngularVelocity(0);
					gloop.physics.b2body.SetLinearVelocity(new V2(0, 0));
					gloop.physics.body.syncTransform();
				}	
			}
			
			reset();

			stage.addEventListener(KeyboardEvent.KEY_DOWN, function(e:Event):void {
				reset();
			});
		}
	}
}