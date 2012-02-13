package uk.co.awamedia.gloop.gameobjects {
	import away3d.entities.Mesh;
	import flash.geom.Point;
	import uk.co.awamedia.gloop.Settings;
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class GameObject {
		
		private var _mesh : Mesh;
		public var speed : Point;
		public var position : Point;
		
		public function GameObject(mesh:Mesh) {
			_mesh = mesh;
			speed = new Point();
			position = new Point();
		}
		
		public function update(timeDelta:Number = 1):void {			
			position.x += speed.x;
			position.y += speed.y;
			
			_mesh.x = position.x;
			_mesh.y = -position.y;
		}
		
	}

}