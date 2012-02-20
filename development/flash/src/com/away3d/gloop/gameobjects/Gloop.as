package com.away3d.gloop.gameobjects
{
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.SphereGeometry;
	
	import com.away3d.gloop.gameobjects.components.MeshComponent;
	import com.away3d.gloop.gameobjects.components.PhysicsComponent;

	public class Gloop extends DefaultGameObject
	{
		public function Gloop()
		{
			super();
			_physics = new GloopPhysicsComponent(this);
			_physics.angularDamping = 1;
			_physics.friction = 1;
			_physics.restitution = .75;
			_physics.allowDragging = true;
			
			_mesh = new MeshComponent();
			_mesh.mesh = new Mesh(new SphereGeometry(), new ColorMaterial(0x00ff00));
		}
		
		override public function get debugColor1():uint {
			return 0x84c806;
		}
		
		override public function get debugColor2():uint {
			return 0x7da628;
		}
	}
}

import com.away3d.gloop.gameobjects.components.PhysicsComponent;
import com.away3d.gloop.gameobjects.DefaultGameObject;

class GloopPhysicsComponent extends PhysicsComponent {
	
	private static const RADIUS:Number = 30;
	
	public function GloopPhysicsComponent(gameObject:DefaultGameObject) {
		super(gameObject);
		graphics.beginFill(gameObject.debugColor1);
		graphics.drawCircle(0, 0, RADIUS);
		graphics.beginFill(gameObject.debugColor2);
		graphics.drawRect(-RADIUS / 2, -RADIUS / 2, RADIUS, RADIUS);

	}
	
	public override function shapes():void {
		circle(RADIUS);
	}
	
	override public function create():void {
		super.create();
		setCollisionGroup(GLOOP);
	}
}