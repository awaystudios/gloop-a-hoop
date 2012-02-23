package com.away3d.gloop.gameobjects
{
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.CylinderGeometry;
	import com.away3d.gloop.gameobjects.components.MeshComponent;
	import com.away3d.gloop.gameobjects.hoops.Hoop;
	import com.away3d.gloop.Settings;
	
	public class Button extends DefaultGameObject
	{
		private var _pressed : Boolean;
		private var _btnGroup : uint;
		
		private var _controllables : Vector.<IButtonControllable>;
		
		
		public function Button(worldX:Number = 0, worldY:Number = 0, rotation:Number = 0, btnGroup : uint = 0)
		{
			_physics = new ButtonPhysicsComponent(this);
			_physics.x = worldX;
			_physics.y = worldY;
			_physics.rotation = rotation;
			
			_physics.fixedRotation = true;
			_physics.applyGravity = false;
			
			_physics.setStatic();
			
			_meshComponent = new MeshComponent();
			_meshComponent.mesh = new Mesh(new CylinderGeometry(Settings.BUTTON_RADIUS, Settings.BUTTON_RADIUS, 5), new ColorMaterial(debugColor1));
			
			_btnGroup = btnGroup;
			
			_controllables = new Vector.<IButtonControllable>();
		}
		
		override public function reset():void 
		{
			super.reset();
			toggleOff();
		}
		
		
		public function get buttonGroup() : uint
		{
			return _btnGroup;
		}
		
		
		public function addControllable(controllable : IButtonControllable) : void
		{
			_controllables.push(controllable);
		}
		
		
		public override function onCollidingWithGloopStart(gloop : Gloop) : void
		{
			_pressed = !_pressed;
			
			if (_pressed) toggleOn();
			else toggleOff();
		}
		
		
		private function toggleOn() : void
		{
			var i : uint;
			
			_pressed = true;
			
			for (i=0; i<_controllables.length; i++) {
				_controllables[i].toggleOn();
			}
		}
		
		
		private function toggleOff() : void
		{
			var i : uint;
			
			_pressed = false;
			
			for (i=0; i<_controllables.length; i++) {
				_controllables[i].toggleOff();
			}
		}
		
		override public function get debugColor1():uint {
			return 0xde6a14;
		}
	}
}

import com.away3d.gloop.gameobjects.components.PhysicsComponent;
import com.away3d.gloop.gameobjects.DefaultGameObject;
import com.away3d.gloop.gameobjects.hoops.Hoop;
import com.away3d.gloop.Settings;

class ButtonPhysicsComponent extends PhysicsComponent
{
	
	public function ButtonPhysicsComponent(gameObject:DefaultGameObject)
	{
		super(gameObject);
		
		graphics.beginFill(gameObject.debugColor1);
		graphics.drawRect( -Settings.BUTTON_RADIUS, -Settings.BUTTON_RADIUS / 6, Settings.BUTTON_RADIUS * 2, Settings.BUTTON_RADIUS / 3);
		
		graphics.beginFill(gameObject.debugColor1);
		graphics.moveTo( 0, -Settings.BUTTON_RADIUS / 2);
		graphics.lineTo( -Settings.BUTTON_RADIUS / 2, 0);
		graphics.lineTo( Settings.BUTTON_RADIUS / 2, 0);
	}
	
	public override function shapes() : void
	{
		// used for gloop collision
		box(Settings.BUTTON_RADIUS * 2, Settings.BUTTON_RADIUS / 3);
	}
	
	override public function create():void {
		super.create();
		setCollisionGroup(GLOOP_SENSOR, b2fixtures[0]);
	}
}