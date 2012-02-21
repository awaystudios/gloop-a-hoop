package com.away3d.gloop.gameobjects.hoops
{
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.CylinderGeometry;
	import Box2DAS.Common.V2;
	import com.away3d.gloop.level.Level;
	
	import Box2DAS.Dynamics.ContactEvent;
	
	import com.away3d.gloop.gameobjects.components.MeshComponent;
	import com.away3d.gloop.gameobjects.components.PhysicsComponent;
	import com.away3d.gloop.gameobjects.DefaultGameObject;
	import com.away3d.gloop.gameobjects.Gloop;
	
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class Hoop extends DefaultGameObject
	{
		
		protected var _rotatable:Boolean = true;
		protected var _draggable:Boolean = true;
		protected var _resolveGloopCollisions:Boolean = false;
		
		public function Hoop(worldX : Number = 0, worldY : Number = 0, rotation : Number = 0)
		{
			_interactive = true;
			
			_physics = new HoopPhysicsComponent(this);
			_physics.x = worldX;
			_physics.y = worldY;
			_physics.rotation = rotation;
			
			_physics.fixedRotation = true;
			_physics.applyGravity = false;
			_physics.linearDamping = 100;
			
			_physics.setStatic();
			
			_mesh = new MeshComponent();
			_mesh.mesh = new Mesh(new CylinderGeometry(50, 50, 5), new ColorMaterial(0xffcc00));
			_mesh.mesh.rotationZ = rotation;
		}
		
		public function onClick(mouseX:Number, mouseY:Number):void {
			if (rotatable) {
				var pos:V2 = _physics.b2body.GetPosition();
				var angle:Number = _physics.b2body.GetAngle();
				_physics.b2body.SetTransform(pos, angle + 45 / 180 * Math.PI);
				_physics.updateBodyMatrix(null); // updates the 2d view, the 3d will update the next frame
			}
		}
		
		public function onDragStart(mouseX:Number, mouseY:Number):void {
			
		}
		
		public function onDragUpdate(mouseX:Number, mouseY:Number):void {
			var pos:V2 = new V2(Math.round(mouseX / Level.GRID_SIZE) * Level.GRID_SIZE, Math.round(mouseY / Level.GRID_SIZE) * Level.GRID_SIZE);
				
			// transform point into physics coord space
			pos.x /= 60;
			pos.y /= 60;
			
			var angle:Number = _physics.b2body.GetAngle();
			
			_physics.b2body.SetTransform(pos, angle);
			_physics.updateBodyMatrix(null); // updates the 2d view, the 3d will update the next frame
		}
		
		public function onDragEnd(mouseX:Number, mouseY:Number):void {
			
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

class HoopPhysicsComponent extends PhysicsComponent
{
	
	private static const RADIUS : Number = 60;
	
	public function HoopPhysicsComponent(gameObject:DefaultGameObject)
	{
		super(gameObject);
		graphics.beginFill(gameObject.debugColor1);
		graphics.drawCircle(0, 0, RADIUS);
		graphics.beginFill(gameObject.debugColor2);
		graphics.drawRect( -RADIUS, -RADIUS / 6, RADIUS * 2, RADIUS / 3);
		
		graphics.beginFill(gameObject.debugColor2);
		graphics.moveTo( 0, -RADIUS / 2);
		graphics.lineTo( -RADIUS / 2, 0);
		graphics.lineTo( RADIUS / 2, 0);
	}
	
	public override function shapes() : void
	{
		// used for gloop collision
		box(RADIUS * 2, RADIUS / 3);
		
		// used for collision with the world
		circle(RADIUS);
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