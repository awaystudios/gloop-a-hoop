package uk.co.awamedia.gloop.gameobjects
{
	import away3d.entities.Mesh;
	import uk.co.awamedia.gloop.Settings;
	
	import flash.geom.Point;

	public class Gloop
	{
		private var _mesh : Mesh;
		
		public var speed : Point;
		public var position : Point;
		
		public function Gloop(mesh : Mesh)
		{
			_mesh = mesh;
			speed = new Point();
			position = new Point();
		}
		
		
		public function update() : void
		{
			speed.x *= Settings.GLOOP_DRAG;
			speed.y *= Settings.GLOOP_DRAG;
			
			speed.y += Settings.GLOOP_GRAVITY;
			
			position.x += speed.x;
			position.y += speed.y;
			
			_mesh.x = position.x;
			_mesh.y = -position.y;
		}
	}
}