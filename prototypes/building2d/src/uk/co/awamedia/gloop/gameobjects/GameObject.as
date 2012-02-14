package uk.co.awamedia.gloop.gameobjects {
	import away3d.entities.Mesh;
	import flash.geom.Point;
	import uk.co.awamedia.gloop.levels.Level;
	import uk.co.awamedia.gloop.Settings;
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class GameObject {
		
		protected var _mesh : Mesh;
		public var speed : Point;
		public var position : Point;
		public var radius : Number = 10;
		public var maxSpeed : Number = 5;
		
		public function GameObject(mesh:Mesh) {
			_mesh = mesh;
			speed = new Point();
			position = new Point();
		}
		
		public function get mesh() : Mesh
		{
			return _mesh;
		}
		public function set mesh(val : Mesh) : void
		{
			_mesh = val;
		}
		
		public function update(timeDelta:Number = 1):void {
			if (speed.length > maxSpeed) speed.normalize(maxSpeed);
			
			position.x += speed.x;
			position.y += speed.y;
			
			if (_mesh) {
				_mesh.x = position.x * Settings.GRID_SIZE;
				_mesh.y = -position.y * Settings.GRID_SIZE;
			}
		}
		
		public function testAndResolveCollision(level:Level, offsetX:Number, offsetY:Number, lockToX:Boolean = false, lockToY:Boolean = false):Boolean {
			if (level.testCollision(position.x + offsetX, position.y + offsetY)) {
					
				var direction:Point = speed.clone();
				
				// hack to only resolve in the offset direction. hacktastic!
				if (lockToX != 0) direction.y = 0;
				if (lockToY != 0) direction.x = 0;
				
				direction.normalize(Settings.COLLISION_STEP);
				var stepsBack:int = 1;
				
				while (level.testCollision(position.x + offsetX - direction.x * stepsBack, position.y + offsetY - direction.y * stepsBack)) {
					stepsBack++;
					
					// something is messed up, bail!
					if (stepsBack > 10) return true;
				}
				
				position.x -= direction.x * stepsBack;
				position.y -= direction.y * stepsBack;
					
				return true;
			}
			
			return false;
		}
		
	}

}