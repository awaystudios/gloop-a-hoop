package com.away3d.gloop.gameobjects
{
	import away3d.entities.Mesh;
	import away3d.materials.BitmapMaterial;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.PlaneGeometry;
	import away3d.textures.BitmapTexture;
	
	import com.away3d.gloop.Settings;
	import com.away3d.gloop.gameobjects.components.MeshComponent;

	
	
	public class HoopGrid extends DefaultGameObject
	{
		
		private var _plane:PlaneGeometry;
		
		[Embed("/../assets/images/grid.png")]
		private var GridDiffusePNGAsset : Class;
		
		public function HoopGrid()
		{
			_meshComponent = new MeshComponent();
			
			var texture:BitmapTexture = new BitmapTexture(new GridDiffusePNGAsset().bitmapData);
			var material:TextureMaterial = new TextureMaterial(texture, true, true);
			material.animateUVs = true;
			_plane = new PlaneGeometry(100, 100, 1, 1, false);
			_meshComponent.mesh = new Mesh(_plane, material);
			_meshComponent.mesh.z = 50;
		}
		
		public function setDimensions(boundsX:Number, boundsY:Number, boundsWidth:Number, boundsHeight:Number):void{
			_plane.width = roundToGrid(boundsWidth);
			_plane.height = roundToGrid(boundsHeight);
			
			_meshComponent.mesh.x = roundToGrid(boundsX + _plane.width / 2);
			_meshComponent.mesh.y = roundToGrid(boundsY + _plane.height / 2);
			
			_meshComponent.mesh.subMeshes[0].scaleU = _plane.width / Settings.GRID_SIZE;
			_meshComponent.mesh.subMeshes[0].scaleV = _plane.height / Settings.GRID_SIZE;
			
			trace(_meshComponent.mesh.subMeshes[0].scaleU, _meshComponent.mesh.subMeshes[0].scaleV);
		}
		
		private function roundToGrid(value:Number):Number{
			return Math.round(value / Settings.GRID_SIZE) * Settings.GRID_SIZE
		}
	}
}