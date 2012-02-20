package com.away3d.gloop.gameobjects.hoops {
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class TrampolineHoop extends Hoop {
		
		public function TrampolineHoop(worldX:Number=0, worldY:Number=0, rotation:Number=0) {
			super(worldX, worldY, rotation);
			_physics.restitution = 1.25;
			_resolveGloopCollisions = true;
		}
		
	}

}