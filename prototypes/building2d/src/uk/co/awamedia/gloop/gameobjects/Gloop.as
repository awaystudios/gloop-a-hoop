package uk.co.awamedia.gloop.gameobjects
{
	import away3d.entities.Mesh;
	
	import flash.geom.Point;

	public class Gloop
	{
		private var _mesh : Mesh;
		
		public var speed : Point;
		
		public function Gloop(mesh : Mesh)
		{
			_mesh = mesh;
			speed = new Point();
		}
		
		
		public function update() : void
		{
			_mesh.x += speed.x;
			_mesh.y += speed.y;
		}
	}
}