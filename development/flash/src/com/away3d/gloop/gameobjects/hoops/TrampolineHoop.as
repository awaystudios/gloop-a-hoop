package com.away3d.gloop.gameobjects.hoops {

	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.ContactEvent;

	import away3d.core.base.Geometry;
	import away3d.library.AssetLibrary;
	
	import com.away3d.gloop.Settings;
	import com.away3d.gloop.gameobjects.Gloop;

	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class TrampolineHoop extends Hoop {
		
		public function TrampolineHoop(worldX:Number = 0, worldY:Number = 0, rotation:Number = 0, movable:Boolean = true, rotatable:Boolean = true) {
			super(0xe9270e, worldX, worldY, rotation, movable, rotatable);
			_physics.restitution = Settings.TRAMPOLINE_RESTITUTION;
			_physics.enableReportPreSolveContact();
			_resolveGloopCollisions = true;
		}

		public override function onCollidingWithGloopPreSolve( gloop:Gloop, e:ContactEvent = null ):void {
			if( e.normal ) {
				var localSpaceNormal:V2 = _physics.b2body.GetLocalVector( e.normal );
				if( !( Math.abs( localSpaceNormal.x ) > 0.01 ) ) { // if not hit from the sides
					_physics.restitution = Settings.TRAMPOLINE_RESTITUTION;
				}
				else {
					_physics.restitution = 0; // use wall restitution here ( for now its the default 0 )
				}
			}
		}
		
		protected override function getIconGeometry() : Geometry
		{
			return Geometry(AssetLibrary.getAsset('SpringIcon_geom'));
		}
	}

}