package com.away3d.gloop.gameobjects.components
{
	import com.away3d.gloop.Settings;
	import com.away3d.gloop.gameobjects.DefaultGameObject;

	public class GloopPhysicsComponent extends PhysicsComponent
	{
		public function GloopPhysicsComponent( gameObject:DefaultGameObject ) {
			super( gameObject );
			
			graphics.beginFill( gameObject.debugColor1 );
			graphics.drawCircle( 0, 0, 2 * Settings.GLOOP_RADIUS );
			graphics.beginFill( gameObject.debugColor2 );
			graphics.drawRect( -Settings.GLOOP_RADIUS / 2, -Settings.GLOOP_RADIUS / 2, Settings.GLOOP_RADIUS, Settings.GLOOP_RADIUS );

			density = 0.25; // should make a gloop of twice the radius have the same mass as before
		}
		
		public override function shapes():void {
			circle( 2 * Settings.GLOOP_RADIUS );
		}
		
		override public function create():void {
			super.create();
			autoSleep = false;
			setCollisionGroup( GLOOP );
		}
	}
}