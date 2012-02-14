package uk.co.awamedia.gloop.gameobjects
{
	import away3d.entities.Mesh;
	import uk.co.awamedia.gloop.levels.Level;
	import uk.co.awamedia.gloop.Settings;
	
	import flash.geom.Point;

	public class Gloop extends GameObject
	{
		
		public function Gloop(mesh : Mesh)
		{
			super(mesh);
			radius = Settings.GLOOP_RADIUS;
			maxSpeed = Settings.GLOOP_MAX_SPEED;
		}
		
		override public function update(timeDelta:Number = 1):void {			
			speed.x *= Settings.GLOOP_DRAG;
			speed.y *= Settings.GLOOP_DRAG;
			
			speed.y += Settings.GLOOP_GRAVITY;
		
			super.update(timeDelta);
		}
	}
}