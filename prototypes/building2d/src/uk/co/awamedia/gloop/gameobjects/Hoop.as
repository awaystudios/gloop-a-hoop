package uk.co.awamedia.gloop.gameobjects {
	import away3d.entities.Mesh;
	import uk.co.awamedia.gloop.Settings;

	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class Hoop extends GameObject
	{
		
		private var _cooldown:Number = 0;
		
		public function Hoop()
		{
			super(null);
			radius = 2;
		}
		
		override public function update(timeDelta:Number = 1):void {
			super.update(timeDelta);
			if (_cooldown > 0) _cooldown -= timeDelta;
		}
		
		public function activate(gloop:Gloop):void {
			_cooldown = 10;
			gloop.speed.y += 3;
		}
		
		public function get enabled():Boolean {
			return _cooldown <= 0;
		}
	}
}