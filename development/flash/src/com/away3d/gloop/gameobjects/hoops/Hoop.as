package com.away3d.gloop.gameobjects.hoops
{
	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.ContactEvent;
	import Box2DAS.Dynamics.Contacts.b2ContactEdge;
	
	import away3d.core.base.Geometry;
	import away3d.entities.Mesh;
	import away3d.library.AssetLibrary;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.CubeGeometry;
	import away3d.primitives.CylinderGeometry;
	
	import com.away3d.gloop.Settings;
	import com.away3d.gloop.gameobjects.DefaultGameObject;
	import com.away3d.gloop.gameobjects.Gloop;
	import com.away3d.gloop.gameobjects.IMouseInteractive;
	import com.away3d.gloop.gameobjects.components.MeshComponent;
	import com.away3d.gloop.gameobjects.events.GameObjectEvent;
	
	
	
	
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
		
		protected var _lastPositionX:int = 0;
		protected var _lastPositionY:int = 0;
		protected var _lastValidPositionX:int = 0;
		protected var _lastValidPositionY:int = 0;
		protected var _needsPositionValidation:Boolean = true;
		
		protected var _newlyPlaced:Boolean = true;
		
		private var _material:ColorMaterial;
		private var _material_invalid:ColorMaterial;
		
		public function Hoop(color : uint, worldX : Number = 0, worldY : Number = 0, rotation : Number = 0)
		{
			_color = color;
			
			_physics = new HoopPhysicsComponent(this);
			_physics.x = worldX;
			_physics.y = worldY;
			_physics.rotation = rotation;
			_physics.fixedRotation = true;
			_physics.applyGravity = false;
			_physics.enableReportBeginContact();
			
			initVisual()
		}
		
		
		private function initVisual() : void
		{
			var geom : Geometry;
			
			_material = new ColorMaterial(_color);
			_material_invalid = new ColorMaterial(0xff0000);
			
			geom = Geometry(AssetLibrary.getAsset('Hoop_geom'));
			
			_meshComponent = new MeshComponent();
			_meshComponent.mesh = new Mesh(geom, _material);
			
			_iconMesh = new Mesh(getIconGeometry(), _material);
			_meshComponent.mesh.addChild(_iconMesh);
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
			if (!inEditMode) return;
			_physics.setStatic(false);
		}
		
		public function onDragUpdate(mouseX:Number, mouseY:Number):void {
			if (!inEditMode || !draggable) return;
			
			var posX:int = snapToHoopGrid(mouseX);
			var posY:int = snapToHoopGrid(mouseY);
			
			if (posX != _lastPositionX || posY != _lastPositionY) {
				_physics.moveTo(posX, posY, false);
				_lastPositionX = posX;
				_lastPositionY = posY;
			} else if (isCollidingWithLevel) {
				displayAsColliding(true);
			} else {
				displayAsColliding(false);
				_lastValidPositionX = _lastPositionX;
				_lastValidPositionY = _lastPositionY;
			}
		}
		
		public function onDragEnd(mouseX:Number, mouseY:Number):void {
			_needsPositionValidation = true;
		}
		
		private function validatePosition():void {
			if (isCollidingWithLevel) {
				
				// if we're inside the wall and the hoop hasn't been validated at all, there's no valid place to go back to
				// so it has to be removed
				if (_newlyPlaced) {
					dispatchEvent(new GameObjectEvent(GameObjectEvent.HOOP_REMOVE, this));
					
				// if not, we go back to wherever was the last valid position
				} else {
					_physics.moveTo(_lastValidPositionX, _lastValidPositionY, true);
				}
			}
			_newlyPlaced = false;
			_physics.setStatic(true);
			displayAsColliding(false);
			_needsPositionValidation = false;
		}
		
		private function displayAsColliding(value:Boolean):void {
			if (value) {
				_meshComponent.mesh.material = _material_invalid;
			} else {
				_meshComponent.mesh.material = _material;
			}
		}
		
		private function get isCollidingWithLevel():Boolean {
			var contacts:b2ContactEdge = _physics.b2body.GetContactList();
			
			while (contacts) {
				//PhysicsComponent(contacts.contact.GetFixtureA().GetUserData()).transform.colorTransform = new ColorTransform(Math.random(), Math.random(), Math.random());
				//PhysicsComponent(contacts.contact.GetFixtureB().GetUserData()).transform.colorTransform = new ColorTransform(Math.random(), Math.random(), Math.random());

				if (contacts.contact.IsTouching()) return true;
				contacts = contacts.next;
			}
			
			return false;
		}
		
		public override function onCollidingWithGloopStart( gloop:Gloop, event:ContactEvent = null ):void
		{
			super.onCollidingWithGloopStart(gloop);
			
			_meshComponent.mesh.scaleX = 1.1;
			_meshComponent.mesh.scaleY = 1.1;
			_meshComponent.mesh.scaleZ = 1.1;
		}
		
		public override function update(dt:Number):void
		{
			super.update(dt);
			
			_meshComponent.mesh.scaleX += (1 - _meshComponent.mesh.scaleX) * 0.2;
			_meshComponent.mesh.scaleY = _meshComponent.mesh.scaleX;
			_meshComponent.mesh.scaleZ = _meshComponent.mesh.scaleX;
			
			_iconMesh.rotationZ = -_meshComponent.mesh.rotationZ;
			_iconMesh.rotationY += 0.5;
			
			if (_needsPositionValidation) validatePosition();
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
		
		public static function snapToHoopGrid(value:Number):int {
			// floor to the nearest whole grid
			// then offset by half a grid to align to the center of grid "boxes" not the intersections
			return Math.floor(value / Settings.GRID_SIZE) * Settings.GRID_SIZE + Settings.GRID_SIZE / 2;
		}
	
	}

}

import com.away3d.gloop.gameobjects.components.PhysicsComponent;
import com.away3d.gloop.gameobjects.DefaultGameObject;
import com.away3d.gloop.gameobjects.hoops.Hoop;
import com.away3d.gloop.level.Level;
import com.away3d.gloop.Settings;

class HoopPhysicsComponent extends PhysicsComponent
{
	private var _mode:Boolean = Level.EDIT_MODE;
	
	public function HoopPhysicsComponent(gameObject:DefaultGameObject)
	{
		super(gameObject);
		graphics.beginFill(gameObject.debugColor1);
		graphics.drawCircle(0, 0, Settings.HOOP_RADIUS * .8);
		graphics.beginFill(gameObject.debugColor2);
		graphics.drawRect( -Settings.HOOP_RADIUS, -Settings.HOOP_RADIUS / 6, Settings.HOOP_RADIUS * 2, Settings.HOOP_RADIUS / 3);
		
		graphics.beginFill(gameObject.debugColor2);
		graphics.moveTo( 0, -Settings.HOOP_RADIUS / 2);
		graphics.lineTo( -Settings.HOOP_RADIUS / 2, 0);
		graphics.lineTo( Settings.HOOP_RADIUS / 2, 0);
	}
	
	public override function shapes() : void
	{
		// used for gloop collision
		box(Settings.HOOP_RADIUS * 2, Settings.HOOP_RADIUS / 3);
		
		// used for collision with the world
		circle(Settings.HOOP_RADIUS * .8);
	}
	
	override public function create():void {
		super.create();
		setCollisionGroup(GLOOP_SENSOR, b2fixtures[0]);
		setCollisionGroup(HOOP, b2fixtures[1]);
		setMode(_mode);
	}
	
	public function setMode(mode:Boolean):void {
		_mode = mode;
		if (!b2body) return;
		if (mode == Level.EDIT_MODE) {
			b2fixtures[0].SetSensor(true);
			b2fixtures[1].SetSensor(true);
		} else {
			if (Hoop(gameObject).resolveGloopCollisions == false) {
				b2fixtures[0].SetSensor(true);
			} else {
				b2fixtures[0].SetSensor(false);
			}
			b2fixtures[1].SetSensor(false);
		}
	}
}