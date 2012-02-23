package com.away3d.gloop.gameobjects
{
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.CylinderGeometry;
	
	import com.away3d.gloop.Settings;
	import com.away3d.gloop.gameobjects.components.MeshComponent;
	import com.away3d.gloop.gameobjects.components.PhysicsComponent;
	import com.away3d.gloop.gameobjects.events.GameObjectEvent;
	import com.away3d.gloop.gameobjects.hoops.Hoop;
	
	public class Star extends DefaultGameObject
	{
		
		private var _touched:Boolean = false;
		
		public function Star(worldX:Number = 0, worldY:Number = 0)
		{
			_physics = new StarPhysicsComponent(this);
			_physics.x = worldX;
			_physics.y = worldY;
			_physics.applyGravity = false;
			_physics.isSensor = true;
			
			_meshComponent = new MeshComponent();
			_meshComponent.mesh = new Mesh(new CylinderGeometry(Settings.STAR_RADIUS, Settings.STAR_RADIUS, 5), new ColorMaterial(debugColor1));
			_meshComponent.mesh.rotationX = 90;
		}
		
		override public function reset():void {
			super.reset();
			_touched = false;
			_meshComponent.mesh.visible = true;
		}
		
		override public function onCollidingWithGloopStart(gloop:Gloop):void {
			super.onCollidingWithGloopStart(gloop);
			if (_touched) return;
			_touched = true;
			_meshComponent.mesh.visible = false;
			
			dispatchEvent(new GameObjectEvent(GameObjectEvent.GLOOP_COLLECT_STAR, this));
		}
		
		override public function get debugColor1():uint {
			return 0x01e6f1;
		}
	}
}

import com.away3d.gloop.gameobjects.components.PhysicsComponent;
import com.away3d.gloop.gameobjects.DefaultGameObject;
import com.away3d.gloop.Settings;

class StarPhysicsComponent extends PhysicsComponent
{
	
	public function StarPhysicsComponent(gameObject:DefaultGameObject)
	{
		super(gameObject);
		graphics.beginFill(gameObject.debugColor1);
		graphics.drawCircle(0, 0, Settings.STAR_RADIUS);
	}
	
	public override function shapes() : void
	{
		circle(Settings.STAR_RADIUS);
	}
	
	override public function create():void {
		super.create();
		setCollisionGroup(GLOOP_SENSOR);
	}
}