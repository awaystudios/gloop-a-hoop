package com.away3d.gloop.gameobjects.components
{
	import com.away3d.gloop.Settings;
	import com.away3d.gloop.gameobjects.DefaultGameObject;
	import com.away3d.gloop.gameobjects.components.PhysicsComponent;
	
	public class GloopPhysicsComponent extends PhysicsComponent
	{
		public function GloopPhysicsComponent( gameObject:DefaultGameObject ) {
			super( gameObject );
			
			graphics.beginFill( gameObject.debugColor1 );
			graphics.drawCircle( 0, 0, Settings.GLOOP_RADIUS );
			graphics.beginFill( gameObject.debugColor2 );
			graphics.drawRect( -Settings.GLOOP_RADIUS / 2, -Settings.GLOOP_RADIUS / 2, Settings.GLOOP_RADIUS, Settings.GLOOP_RADIUS );
		}
		
		public override function shapes():void {
			circle( Settings.GLOOP_RADIUS );
		}
		
		override public function create():void {
			super.create();
			setCollisionGroup( GLOOP );
		}
	}
}