package com.away3d.gloop.gameobjects.hoops {
	import away3d.core.base.Geometry;
	import away3d.library.AssetLibrary;
	
	import com.away3d.gloop.Settings;

	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class TrampolineHoop extends Hoop {
		
		public function TrampolineHoop(worldX:Number = 0, worldY:Number = 0, rotation:Number = 0) {
			super(0xe9270e, worldX, worldY, rotation);
			_physics.restitution = Settings.TRAMPOLINE_RESTITUTION;
			_resolveGloopCollisions = true;
		}
		
		
		protected override function getIconGeometry() : Geometry
		{
			return Geometry(AssetLibrary.getAsset('SpringIcon_geom'));
		}
	}

}