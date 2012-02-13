package uk.co.awamedia.gloop.gameobjects {
	import away3d.entities.Mesh;
	import away3d.entities.Mesh;
	import away3d.events.MouseEvent3D;
	
	import flash.events.MouseEvent;
	
	import uk.co.awamedia.gloop.Settings;
	import uk.co.awamedia.gloop.gameobjects.GameObject;

	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class Hoop extends GameObject
	{
		private var _cooldown:Number = 0;
		public var rotation : Number;
		
		public function Hoop()
		{
			super(null);
			
			radius = 3;
			rotation = 0;
		}
		
		public function activate(gloop:Gloop):void {
			_cooldown = 10;
			gloop.speed.x = Math.sin(rotation / 180 * Math.PI) * 1;
			gloop.speed.y = Math.cos(rotation / 180 * Math.PI) * 1;
		}
		
		public function get enabled():Boolean {
			return _cooldown <= 0;
		}
		
		
		public override function set mesh(val:Mesh):void
		{
			super.mesh = val;
			
			_mesh.mouseEnabled = true;
			_mesh.addEventListener(MouseEvent3D.CLICK, onMeshClick);
		}
		
		
		public override function update(timeDelta:Number=1):void
		{
			super.update(timeDelta);
			
			if (_cooldown > 0) 
				_cooldown -= timeDelta;
			
			if (_mesh)
				_mesh.rotationZ = rotation;
		}
		
		
		private function onMeshClick(ev : MouseEvent3D) : void
		{
			rotation += 45;
		}
	}
}