package com.away3d.gloop.screens
{

	import away3d.animators.data.VertexAnimationState;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.core.base.Geometry;
	import away3d.entities.Mesh;
	import away3d.library.AssetLibrary;
	import away3d.materials.ColorMaterial;
	import away3d.materials.DefaultMaterialBase;
	import away3d.materials.TextureMaterial;
	import away3d.textures.BitmapTexture;

	import com.away3d.gloop.Settings;
	import com.away3d.gloop.gameobjects.components.VertexAnimationComponent;

	import com.away3d.gloop.utils.EmbeddedResources;

	import flash.display.Bitmap;
	import flash.display.Scene;
	import flash.events.Event;

	import flash.events.EventDispatcher;
	import flash.geom.Vector3D;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;

	/*
	* AssetManager has 2 functions.
	* 1) Act as a centralized Singleton to retrieve 3D assets.
	* 2) Animate on screen ( even though the screen could be hidden under 2D content ) any heavy resources, to ensure that complex asset initialization
	* does not happen during game play for the 1st time, something that could represent a fps hiccup.
	* */
	public class AssetManager extends EventDispatcher
	{
		private static var _instance:AssetManager;

		private var _view:View3D;
		private var _scene:Scene3D;

		public var gloopSplatAnimMesh:Mesh;
		public var gloopStdAnimMesh:Mesh;
		public var gloopSplatAnimation:VertexAnimationComponent;
		public var gloopStdAnimation:VertexAnimationComponent;

		public var cannonMesh:Mesh;
		public var cannonBody:Mesh;
		public var cannonFrame0:Geometry;
		public var cannonFrame1:Geometry;
		public var cannonAnimationState:VertexAnimationState;
		public var cannonAnimation:VertexAnimationComponent;

		public function AssetManager() {
		}

		public function initializeAnimations():void {

			_scene = new Scene3D();
			_view.scene = _scene;
			_view.camera.position = new Vector3D( -500, 500, 0 );
			_view.camera.lookAt( new Vector3D() );

			addEventListener( Event.ENTER_FRAME, enterframeHandler );

			initializeGloopFly();
			initializeGloopSplat();
			initializeCannonVisual();
			initializeCannonAnimation();
			doComplete();

		}

		private function initializeCannonVisual():void {
			var tex : BitmapTexture;
			var bodyMat:DefaultMaterialBase;
			var footMat:DefaultMaterialBase;
			var footGeom:Geometry;
			var bodyGeom:Geometry;

			tex = new BitmapTexture( Bitmap( new EmbeddedResources.CannonDiffusePNGAsset() ).bitmapData );

			bodyMat = new TextureMaterial( tex );
			footMat = new TextureMaterial( tex );

			bodyGeom = Geometry( AssetLibrary.getAsset( 'CannonFrame0_geom' ) ).clone();
			footGeom = Geometry( AssetLibrary.getAsset( 'CannonFoot_geom' ) );

			cannonMesh = new Mesh( footGeom, footMat );
			cannonBody = new Mesh( bodyGeom, bodyMat );
		}

		private function initializeCannonAnimation():void {
			cannonFrame0 = Geometry(AssetLibrary.getAsset('CannonFrame0_geom'));
			cannonFrame1 = Geometry(AssetLibrary.getAsset('CannonFrame1_geom'));

			cannonAnimation = new VertexAnimationComponent(cannonBody);
			cannonAnimation.addSequence('fire', [
				cannonFrame1,
				Geometry(AssetLibrary.getAsset('CannonFrame2_geom')),
				Geometry(AssetLibrary.getAsset('CannonFrame3_geom')),
				Geometry(AssetLibrary.getAsset('CannonFrame0_geom')),
			], 50, false);

			cannonAnimationState = VertexAnimationState(cannonBody.animationState);

			_scene.addChild( cannonBody );
			cannonAnimation.play( 'fire' );
		}

		private function initializeGloopFly():void {
			var diff_tex : BitmapTexture;
			var spec_tex : BitmapTexture;
			var mat : TextureMaterial;
			var geom:Geometry;

			diff_tex = new BitmapTexture(Bitmap(new EmbeddedResources.GloopDiffusePNGAsset).bitmapData);
			spec_tex = new BitmapTexture(Bitmap(new EmbeddedResources.GloopSpecularPNGAsset).bitmapData);

			mat = new TextureMaterial(diff_tex);
			mat.animateUVs = true;
			mat.specularMap = spec_tex;

			geom = Geometry( AssetLibrary.getAsset( 'GloopFlyFrame0Geom' ) );

			gloopStdAnimMesh = new Mesh(geom, mat);
			gloopStdAnimMesh.subMeshes[0].scaleU = 0.5;
			gloopStdAnimMesh.subMeshes[0].scaleV = 0.5;

			// TODO: Replace with nicer texture animations.
			mat.repeat = true;
			setInterval(function() : void {
				gloopStdAnimMesh.subMeshes[0].offsetU += 0.5;
			}, 300);

			gloopStdAnimation = new VertexAnimationComponent( gloopStdAnimMesh );
			gloopStdAnimation.addSequence( 'fly', [
				Geometry( AssetLibrary.getAsset( 'GloopFlyFrame0Geom' ) ),
				Geometry( AssetLibrary.getAsset( 'GloopFlyFrame1Geom' ) ),
				Geometry( AssetLibrary.getAsset( 'GloopFlyFrame2Geom' ) ),
				Geometry( AssetLibrary.getAsset( 'GloopFlyFrame3Geom' ) ),
				Geometry( AssetLibrary.getAsset( 'GloopFlyFrame4Geom' ) )
			] );

			_scene.addChild( gloopStdAnimMesh );
			gloopStdAnimation.play( 'fly' );
		}

		private function initializeGloopSplat():void {

			var tex:BitmapTexture;
			var geom:Geometry;
			var mat:TextureMaterial;

			tex = new BitmapTexture( Bitmap( new EmbeddedResources.GloopSplatDiffusePNGAsset ).bitmapData );
			mat = new TextureMaterial( tex );

			geom = Geometry( AssetLibrary.getAsset( 'GlSplatFr0_geom' ) );

			gloopSplatAnimMesh = new Mesh( geom, mat );
			gloopSplatAnimMesh.y = -Settings.GLOOP_RADIUS - 5;

			gloopSplatAnimation = new VertexAnimationComponent( gloopSplatAnimMesh );
			gloopSplatAnimation.addSequence( 'splat', [
				Geometry( AssetLibrary.getAsset( 'GlSplatFr0_geom' ) ),
				Geometry( AssetLibrary.getAsset( 'GlSplatFr1_geom' ) ),
				Geometry( AssetLibrary.getAsset( 'GlSplatFr2_geom' ) ),
				Geometry( AssetLibrary.getAsset( 'GlSplatFr3_geom' ) ),
				Geometry( AssetLibrary.getAsset( 'GlSplatFr4_geom' ) ),
				Geometry( AssetLibrary.getAsset( 'GlSplatFr3_geom' ) ),
				Geometry( AssetLibrary.getAsset( 'GlSplatFr4_geom' ) )
			], 100, false );

			_scene.addChild( gloopSplatAnimMesh );
			gloopSplatAnimation.play( 'splat' );
		}

		public static function get instance():AssetManager {
			if( !_instance ) {
				_instance = new AssetManager();
			}
			return _instance;
		}

		private function doComplete():void {
			setTimeout( function():void {
				removeEventListener( Event.ENTER_FRAME, enterframeHandler );
				dispatchEvent( new Event( Event.COMPLETE ) );
			}, 1500 );
		}

		private function enterframeHandler( event:Event ):void {
			_view.render();
		}

		public function get view():View3D {
			return _view;
		}

		public function set view( value:View3D ):void {
			_view = value;
		}
	}
}