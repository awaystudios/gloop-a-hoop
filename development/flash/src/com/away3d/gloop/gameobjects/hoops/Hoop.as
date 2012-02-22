package com.away3d.gloop.gameobjects.hoops
{
	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.ContactEvent;
	
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.CylinderGeometry;
	
	import com.away3d.gloop.Settings;
	import com.away3d.gloop.gameobjects.DefaultGameObject;
	import com.away3d.gloop.gameobjects.Gloop;
	import com.away3d.gloop.gameobjects.components.MeshComponent;
	import com.away3d.gloop.gameobjects.components.PhysicsComponent;
	import com.away3d.gloop.level.Level;
	
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class Hoop extends DefaultGameObject
	{
		
		protected var _rotatable:Boolean = true;
		protected var _draggable:Boolean = true;
		protected var _resolveGloopCollisions:Boolean = false;
		protected var _lastValidPosition:V2;
		
		public function Hoop(worldX : Number = 0, worldY : Number = 0, rotation : Number = 0)
		{
			_physics = new HoopPhysicsComponent(this);
			_physics.x = worldX;
			_physics.y = worldY;
			_physics.rotation = rotation;
			
			_physics.fixedRotation = true;
			_physics.applyGravity = false;
			
			_physics.setStatic();
			
			_mesh = new MeshComponent();
			_mesh.mesh = new Mesh(new CylinderGeometry(Settings.HOOP_RADIUS, Settings.HOOP_RADIUS, 5), new ColorMaterial(0xffcc00));
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
			_lastValidPosition = _physics.b2body.GetPosition();
		}
		
		public function onDragUpdate(mouseX:Number, mouseY:Number):void {
			if (!inEditMode || !draggable) return;
			
			var pos:V2 = new V2(Math.round(mouseX / Level.GRID_SIZE) * Level.GRID_SIZE, Math.round(mouseY / Level.GRID_SIZE) * Level.GRID_SIZE);
				
			// transform point into physics coord space
			pos.x /= Settings.PHYSICS_SCALE;
			pos.y /= Settings.PHYSICS_SCALE;
			
			var angle:Number = _physics.b2body.GetAngle();
			
			_physics.b2body.SetTransform(pos, angle);
			_physics.updateBodyMatrix(null); // updates the 2d view, the 3d will update the next frame
		}
		
		public function onDragEnd(mouseX:Number, mouseY:Number):void {
			
		}
		
		public override function onCollidingWithGloopStart(gloop:Gloop):void
		{
			super.onCollidingWithGloopStart(gloop);
			
			_mesh.mesh.scaleX = 1.1;
			_mesh.mesh.scaleY = 1.1;
			_mesh.mesh.scaleZ = 1.1;
		}
		
		public override function update(dt:Number):void
		{
			super.update(dt);
			
			_mesh.mesh.scaleX += (1 - _mesh.mesh.scaleX) * 0.2;
			_mesh.mesh.scaleY = _mesh.mesh.scaleX;
			_mesh.mesh.scaleZ = _mesh.mesh.scaleX;
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

	}

}

import com.away3d.gloop.gameobjects.components.PhysicsComponent;
import com.away3d.gloop.gameobjects.DefaultGameObject;
import com.away3d.gloop.gameobjects.hoops.Hoop;
import com.away3d.gloop.Settings;

class HoopPhysicsComponent extends PhysicsComponent
{
	
	public function HoopPhysicsComponent(gameObject:DefaultGameObject)
	{
		super(gameObject);
		graphics.beginFill(gameObject.debugColor1);
		graphics.drawCircle(0, 0, Settings.HOOP_RADIUS);
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
		circle(Settings.HOOP_RADIUS);
	}
	
	override public function create():void {
		super.create();
		
		if (Hoop(gameObject).resolveGloopCollisions == false) {
			b2fixtures[0].SetSensor(true);
		}
		
		setCollisionGroup(GLOOP_SENSOR, b2fixtures[0]);
		setCollisionGroup(HOOP, b2fixtures[1]);
	}
}