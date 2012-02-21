package com.away3d.gloop.gameobjects
{

	import Box2DAS.Collision.b2WorldManifold;
	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.ContactEvent;

	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.SphereGeometry;

	import com.away3d.gloop.effects.DecalSplatter;
	import com.away3d.gloop.effects.decals.SplatDecal;
	import com.away3d.gloop.gameobjects.components.MeshComponent;
	import com.away3d.gloop.gameobjects.components.PhysicsComponent;

	import flash.geom.Vector3D;

	public class Gloop extends DefaultGameObject
	{
		[Embed(source="../../../../../assets/images/green-splat.png")]
		private var SplatImage1:Class;

		[Embed(source="../../../../../assets/images/green-splat-1.png")]
		private var SplatImage2:Class;

		private var _decalSplatter:DecalSplatter;

		public function Gloop() {

			super();

			_decalSplatter = new DecalSplatter();
			_decalSplatter.apertureX = 0.5;
			_decalSplatter.apertureY = 0.5;
			_decalSplatter.apertureZ = 0.25;
			_decalSplatter.minScale = 0.5;
			_decalSplatter.maxScale = 1;
			_decalSplatter.maxDistance = 60;
			_decalSplatter.decals = Vector.<Mesh>( [
				new SplatDecal( new SplatImage1().bitmapData ),
				new SplatDecal( new SplatImage2().bitmapData )
			] );

			_physics = new GloopPhysicsComponent( this );
			_physics.angularDamping = 1;
			_physics.friction = 1;
			_physics.restitution = .75;
			_physics.reportBeginContact = true;
			_physics.addEventListener( ContactEvent.BEGIN_CONTACT, handleBeginContact );

			_mesh = new MeshComponent();
			_mesh.mesh = new Mesh( new SphereGeometry(), new ColorMaterial( 0x00ff00 ) );
		}

		public function set splattables( value:Vector.<Mesh> ):void {
			_decalSplatter.targets = value;
		}

		private function handleBeginContact( e:ContactEvent ):void {
			var otherPhysics:PhysicsComponent = e.other.m_userData as PhysicsComponent;
			if( !otherPhysics ) return;
			var wm:b2WorldManifold = e.getWorldManifold();
			if( wm.points.length > 0 ) {
				splatter( e.point );
			}
		}

		private function splatter( collisionPoint:V2 ):void {
			// splat source is the gloop's position
			_decalSplatter.sourcePosition = new Vector3D( _physics.x, -_physics.y, 0 );
			// splat direction depends contact normal
			var bodyPosition:V2 = _physics.b2body.GetPosition();
			_decalSplatter.splatDirection = new Vector3D( ( collisionPoint.x - bodyPosition.x ), -( collisionPoint.y - bodyPosition.y ), 0 );
			// splat intensity ( num splats ) depends on body speed
			var linearVelocity:V2 = _physics.b2body.GetLinearVelocity();
			var speed:Number = linearVelocity.length();
			_decalSplatter.numRays = 1 + Math.floor( speed * 20 );
			// perform splat
			if( speed > 1 ) {
				_decalSplatter.evaluate();
			}
		}

		override public function get debugColor1():uint {
			return 0x84c806;
		}

		override public function get debugColor2():uint {
			return 0x7da628;
		}
	}
}

import com.away3d.gloop.gameobjects.DefaultGameObject;
import com.away3d.gloop.gameobjects.components.PhysicsComponent;

class GloopPhysicsComponent extends PhysicsComponent
{

	private static const RADIUS:Number = 30;

	public function GloopPhysicsComponent( gameObject:DefaultGameObject ) {
		super( gameObject );
		graphics.beginFill( gameObject.debugColor1 );
		graphics.drawCircle( 0, 0, RADIUS );
		graphics.beginFill( gameObject.debugColor2 );
		graphics.drawRect( -RADIUS / 2, -RADIUS / 2, RADIUS, RADIUS );

	}

	public override function shapes():void {
		circle( RADIUS );
	}

	override public function create():void {
		super.create();
		setCollisionGroup( GLOOP );
	}
}