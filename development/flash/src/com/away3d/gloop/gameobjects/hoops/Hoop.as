package com.away3d.gloop.gameobjects.hoops
{

	import Box2DAS.Collision.b2WorldManifold;
	import Box2DAS.Collision.b2WorldManifold;
	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.ContactEvent;
	import Box2DAS.Dynamics.Contacts.b2ContactEdge;
	import Box2DAS.Dynamics.b2ContactImpulse;

	import away3d.core.base.Geometry;
	import away3d.entities.Mesh;
	import away3d.library.AssetLibrary;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.CubeGeometry;
	import away3d.primitives.CylinderGeometry;
	import away3d.primitives.SphereGeometry;

	import com.away3d.gloop.Settings;
	import com.away3d.gloop.gameobjects.Box;
	import com.away3d.gloop.gameobjects.DefaultGameObject;
	import com.away3d.gloop.gameobjects.Gloop;
	import com.away3d.gloop.gameobjects.IMouseInteractive;
	import com.away3d.gloop.gameobjects.components.MeshComponent;
	import com.away3d.gloop.gameobjects.components.PhysicsComponent;
	import com.away3d.gloop.level.Level;

	import mx.events.CollectionEvent;

	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class Hoop extends DefaultGameObject implements IMouseInteractive
	{
		private var _color : uint;
		
		protected var _iconMesh : Mesh;
		
		protected var _rotatable:Boolean = true;
		protected var _draggable:Boolean = true;
		protected var _resolveGloopCollisions:Boolean = false;
		
		private var _material:ColorMaterial;

		public function Hoop(color : uint, worldX : Number = 0, worldY : Number = 0, rotation : Number = 0, draggable:Boolean = true, rotatable:Boolean = true)
		{
			_color = color;
			_draggable = draggable;
			_rotatable = rotatable;
			
			_physics = new HoopPhysicsComponent(this);
			_physics.x = worldX;
			_physics.y = worldY;
			_physics.rotation = rotation;

			initVisual()
		}
		
		
		private function initVisual() : void
		{
			var geom : Geometry;
			
			_material = new ColorMaterial(_color);

			geom = Geometry(AssetLibrary.getAsset('Hoop_geom'));

			_meshComponent = new MeshComponent();
			_meshComponent.mesh = new Mesh(geom, _material);

			_iconMesh = new Mesh(getIconGeometry(), _material);
			_meshComponent.mesh.addChild(_iconMesh);

			if( _draggable ) { // TODO: use cloned mesh from asset library
				var cube:Mesh = new Mesh( new CubeGeometry(), new ColorMaterial( 0xFF0000 ) );
				cube.scale( 0.15 );
				cube.z = 100;
				_meshComponent.mesh.addChild( cube );
			}

			if( _rotatable ) { // TODO: use cloned mesh from asset library
				var sphere:Mesh = new Mesh( new SphereGeometry(), new ColorMaterial( 0x00FF00 ) );
				sphere.scale( 0.15 );
				sphere.z = 50;
				_meshComponent.mesh.addChild( sphere );
			}

			_meshComponent.mesh.scale( Settings.HOOP_SCALE );

			createPole();
		}

		private function createPole():void {
			var poleLength:Number = 500;
			var poleRadius:Number = 3;
			var hoopRadius:Number = ( _meshComponent.mesh.bounds.max.x - _meshComponent.mesh.bounds.min.x ) / 2;
			var pole:Mesh = new Mesh( new CylinderGeometry( poleRadius, poleRadius, poleLength ), _material );
			pole.z = poleLength / 2 + hoopRadius;
			pole.rotationX = 90;
			_meshComponent.mesh.addChild( pole );
		}

		protected function getIconGeometry() : Geometry
		{
			// To be overridden
			return null;
		}
		
		
		public function onClick(mouseX:Number, mouseY:Number):void {
			if (inEditMode && rotatable) {
				var pos:V2 = _physics.b2body.GetPosition();
				var angle:Number = _physics.b2body.GetAngle();
				_physics.b2body.SetTransform(pos, angle + Settings.HOOP_ROTATION_STEP / 180 * Math.PI);
				_physics.updateBodyMatrix(null); // updates the 2d view, the 3d will update the next frame
			}
		}
		
		public function onDragStart(mouseX:Number, mouseY:Number):void {

			if (!inEditMode) {
				return;
			}

			_physics.setStatic( false );
		}
		
		public function onDragUpdate(mouseX:Number, mouseY:Number):void {

		}

		public function onDragEnd(mouseX:Number, mouseY:Number):void {
			_physics.setStatic( true );
		}
		
		public override function onCollidingWithGloopStart( gloop:Gloop, event:ContactEvent = null ):void
		{
			super.onCollidingWithGloopStart(gloop);
			
			_meshComponent.mesh.scaleX = 1.1 * Settings.HOOP_SCALE;
			_meshComponent.mesh.scaleY = 1.1 * Settings.HOOP_SCALE;
			_meshComponent.mesh.scaleZ = 1.1 * Settings.HOOP_SCALE;
		}
		
		public override function update(dt:Number):void
		{
			super.update(dt);

			if( _meshComponent.mesh.scaleX > 1.01 * Settings.HOOP_SCALE ) {
				_meshComponent.mesh.scaleX += (1 - _meshComponent.mesh.scaleX) * 0.2;
			}
			else {
				_meshComponent.mesh.scaleX = Settings.HOOP_SCALE;
			}

			_meshComponent.mesh.scaleY = _meshComponent.mesh.scaleX;
			_meshComponent.mesh.scaleZ = _meshComponent.mesh.scaleX;
			
			_iconMesh.rotationZ = -_meshComponent.mesh.rotationZ;
			_iconMesh.rotationY += 0.5;
		}
		
		override public function setMode(value:Boolean):void {
			super.setMode(value);
			HoopPhysicsComponent(_physics).setMode(value);
		}
		
		public function get resolveGloopCollisions():Boolean {
			return _resolveGloopCollisions;
		}
		
		override public function get debugColor1():uint {
			return 0x947d3a;
		}
		
		override public function get debugColor2():uint {
			return 0xcebc84;
		}
		
		public function get rotatable():Boolean {
			return _rotatable;
		}
		
		public function get draggable():Boolean {
			return _draggable;
		}

		// treat collision with boxes in edit mode
		private var _numCollidingBoxes:int = 0;
		override public function onCollidingWithSomethingStart( event:ContactEvent ):void {
			if( _mode != Level.EDIT_MODE ) return;
			var collidingBox:Box = getCollidingBox( event );
			if( collidingBox == null ) return;
			_numCollidingBoxes++;
			_allowMeshUpdateX =_allowMeshUpdateY = false;
		}
		override public function onCollidingWithSomethingEnd( event:ContactEvent ):void {
			if( _mode != Level.EDIT_MODE ) return;
			var collidingBox:Box = getCollidingBox( event );
			if( collidingBox == null ) return;
			_numCollidingBoxes--;
			if( _numCollidingBoxes == 0 ) {
				_allowMeshUpdateX = true;
				_allowMeshUpdateY = true;
			}
		}

		private function getCollidingBox( event:ContactEvent ):Box {
			var otherPhysics:PhysicsComponent = event.other.m_userData as PhysicsComponent;
			if( !otherPhysics ) return null;
			var box:Box = otherPhysics.gameObject as Box;
			if( !box ) return null;
			return box;
		}
	}

}

import Box2DAS.Common.V2;

import com.away3d.gloop.Settings;
import com.away3d.gloop.gameobjects.DefaultGameObject;
import com.away3d.gloop.gameobjects.components.PhysicsComponent;
import com.away3d.gloop.gameobjects.hoops.Hoop;
import com.away3d.gloop.level.Level;

class HoopPhysicsComponent extends PhysicsComponent
{
	private var _inPlayMode:Boolean = Level.EDIT_MODE;

	public function HoopPhysicsComponent(gameObject:DefaultGameObject)
	{
		super(gameObject);
		graphics.beginFill(gameObject.debugColor2);
		graphics.drawRect( -Settings.HOOP_SCALE * Settings.HOOP_RADIUS, -Settings.HOOP_SCALE * Settings.HOOP_RADIUS / 6,
				Settings.HOOP_SCALE * Settings.HOOP_RADIUS * 2, Settings.HOOP_SCALE * Settings.HOOP_RADIUS / 3);
		
		allowDragging = true;
		linearDamping = 9999999;
		angularDamping = 9999999;
		density = 9999;
		restitution = 0;
		fixedRotation = true;
		applyGravity = false;
		enableReportBeginContact();
		enableReportEndContact();
	}

	public override function shapes() : void
	{
		box( Settings.HOOP_SCALE * Settings.HOOP_RADIUS * 2, Settings.HOOP_SCALE * Settings.HOOP_RADIUS / 3);
	}
	
	override public function create():void {
		super.create();
		setMode( _inPlayMode );
		setStatic( true );
	}
	
	public function setMode(playMode:Boolean):void {

		_inPlayMode = playMode;

		if (!b2body) {
			return;
		}

		if( playMode == Level.EDIT_MODE ) {
			allowDragging = true;
			b2body.SetLinearVelocity( new V2() );
			b2body.SetAngularVelocity( 0 );
		} else {
			allowDragging = false;
			b2fixtures[0].SetSensor( !Hoop( gameObject ).resolveGloopCollisions );
		}
	}
}