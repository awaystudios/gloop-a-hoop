package uk.co.awamedia.gloop.gameobjects {
	import away3d.entities.Mesh;
	import away3d.events.MouseEvent3D;
	import away3d.materials.ColorMaterial;
	
	import flash.geom.Point;
	
	import uk.co.awamedia.gloop.gameobjects.GameObject;
	
	

	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class Hoop extends GameObject
	{
		private var _cooldown:Number = 0;
		private var _rotation : Number;
		private var _slope : Point;
		
		public function Hoop()
		{
			super(null);
			
			radius = 3;
			rotation = 0;
		}
		
		public function activate(gloop:Gloop):void {
			_cooldown = 10;
			gloop.speed.x = _slope.y * 1;
			gloop.speed.y = _slope.x * 1;
		}
		
		public function get enabled():Boolean {
			return _cooldown <= 0;
		}
		
		public override function update(timeDelta:Number=1):void
		{
			super.update(timeDelta);
			
			if (_cooldown > 0) 
				_cooldown -= timeDelta;
			
			if (_mesh)
				_mesh.rotationZ = rotation;
		}
		
		
		public function setColor(color:uint):void {
			ColorMaterial(_mesh.material).color = color;
		}
		
		public function get rotation():Number {
			return _rotation;
		}
		
		public function set rotation(value:Number):void {
			_rotation = value;
			_slope = Point.polar(1, rotation / 180 * Math.PI);
		}
		
		public function get slope():Point {
			return _slope;
		}
		
	}
}