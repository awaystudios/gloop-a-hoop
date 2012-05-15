/**
 * Slice9Bitmap.as
 * by Michael Hoskins
 * http://www.pixelbath.com/
 * 
 * This work is being distributed under the Creative Commons Attribution 3.0 Unported license. You are
 * free to copy, distribute, transmit, remix, adapt or otherwise use the work, as long as attribution
 * to the author is maintained.
 * 
 * For details, see: http://creativecommons.org/licenses/by/3.0/
 * 
 * Usage:
 import com.pixelbath.ui.Slice9Bitmap;
 
 public class Main extends Sprite {
 public var bmp:Slice9Bitmap;
 
 public function Main():void {
 if (stage) init();
 else addEventListener(Event.ADDED_TO_STAGE, init);
 }
 
 [Embed(source="image.png")]
 public var imageTest:Class; 
 
 private var mousepad:Sprite;
 
 private function init(e:Event = null):void {
 removeEventListener(Event.ADDED_TO_STAGE, init);
 
 // load the embedded Bitmap, then pass it along to Slice9Bitmap
 var myBMP:Bitmap = new imageTest();
 bmp = new Slice9Bitmap(myBMP, this, new Rectangle(13, 13, 64, 64));
 
 this.stage.addEventListener(MouseEvent.MOUSE_MOVE, mousemove);
 }
 
 private function mousemove(evt:MouseEvent):void {
 bmp.setSize(this.mouseX + 50, this.mouseY + 50);	// offset for clip registration
 }
 */
package com.pixelbath.ui {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class Slice9Bitmap extends Sprite {
		private var _width:int;
		private var _height:int;
		
		private var _bitmap:Bitmap;
		
		private var _padding:Rectangle;
		
		private var tl:Sprite;
		private var tc:Sprite;
		private var tr:Sprite;
		private var cl:Sprite;
		private var cc:Sprite;
		private var cr:Sprite;
		private var bl:Sprite;
		private var bc:Sprite;
		private var br:Sprite;
		
		public function Slice9Bitmap(bmp:Bitmap, parent:Sprite = null, slicePosition:Rectangle = null) {
			_bitmap = bmp;
			_width = bmp.width;
			_height = bmp.height;
			
			// if a rect is included, assign it in a roundabout way to the padding array
			if (slicePosition == null) {
				_padding = new Rectangle(5, 5, 0, 0);
			} else {
				_padding = slicePosition;
			}
			
			if (parent != null) {
				parent.addChild(this);
			}
			
			draw();
			arrange();
		}
		public function setSize(w:int, h:int):void {
			if (w < _padding.left + _padding.right) w = _padding.right + _padding.left;
			if (h < _padding.top + _padding.bottom) h = _padding.top + _padding.bottom;
			
			_width = w;
			_height = h;
			arrange();
		}
		public function setBitmapData(bmd:BitmapData):void {
			_bitmap = new Bitmap(bmd);
			invalidate();
		}
		public function set bitmap(bmp:Bitmap):void {
			_bitmap = bmp;
			invalidate();
		}
		public function set padding(padRect:Rectangle):void {
			_padding = padRect;
			arrange();
		}
		public function get padding():Rectangle {
			return _padding;
		}
		
		public function invalidate():void {
			// trash all the children
			var numChildren:int = this.numChildren;
			while (numChildren-- > 0) {
				this.removeChildAt(0);
			}
			
			draw();
			arrange();
		}
		
		public function arrange():void {
			// do some local assignments to avoid recalculating for all objects
			var row2y:int = _padding.top;
			var row3y:int = _height - _padding.bottom;
			var col2x:int = _padding.left;
			var col3x:int = _width - _padding.right;
			
			// position container sprites
			tl.x = 0; tl.y = 0;
			tc.x = col2x; tc.y = 0;
			tr.x = col3x; tr.y = 0;
			cl.x = 0; cl.y = row2y;
			cc.x = col2x; cc.y = row2y;
			cr.x = col3x; cr.y = row2y;
			bl.x = 0; bl.y = row3y;
			bc.x = col2x; bc.y = row3y;
			br.x = col3x; br.y = row3y;
			
			// stretch dem hos
			tc.width = cc.width = bc.width = _width - (_padding.right + _padding.left);
			cl.height = cc.height = cr.height = _height - (_padding.top + _padding.bottom);
		}
		
		public function draw():void {
			if (_padding == null) return;
			
			var dest:Point = new Point(0, 0);
			
			// make container sprites and draw cropped bitmaps into them
			tl = new Sprite();
			tc = new Sprite();
			tr = new Sprite();
			cl = new Sprite();
			cc = new Sprite();
			cr = new Sprite();
			bl = new Sprite();
			bc = new Sprite();
			br = new Sprite();
			
			var tlb:BitmapData = new BitmapData(_padding.left, _padding.top, true, 0xff0000);
			var tcb:BitmapData = new BitmapData(_width - _padding.left - _padding.right, _padding.top, true, 0x990000);
			var trb:BitmapData = new BitmapData(_padding.right, _padding.top, true, 0x660000);
			var clb:BitmapData = new BitmapData(_padding.left, _height - _padding.top - _padding.bottom, true, 0x00ff00);
			var ccb:BitmapData = new BitmapData(_width - _padding.left - _padding.right, _height - _padding.top - _padding.bottom, true, 0x009900);
			var crb:BitmapData = new BitmapData(_padding.right, _height - _padding.top - _padding.bottom, true, 0x006600);
			var blb:BitmapData = new BitmapData(_padding.left, _padding.bottom, true, 0x0000ff);
			var bcb:BitmapData = new BitmapData(_width - _padding.left - _padding.right, _padding.bottom, true, 0x000099);
			var brb:BitmapData = new BitmapData(_padding.right, _padding.bottom, true, 0x000066);
			
			tlb.copyPixels(_bitmap.bitmapData, new Rectangle(0, 0, tlb.width, tlb.height), dest);
			tcb.copyPixels(_bitmap.bitmapData, new Rectangle(_padding.left, 0, tcb.width, tcb.height), dest);
			trb.copyPixels(_bitmap.bitmapData, new Rectangle(_width - _padding.right, 0, trb.width, trb.height), dest);
			clb.copyPixels(_bitmap.bitmapData, new Rectangle(0, _padding.top, clb.width, clb.height), dest);
			ccb.copyPixels(_bitmap.bitmapData, new Rectangle(_padding.left, _padding.top, ccb.width, ccb.height), dest);
			crb.copyPixels(_bitmap.bitmapData, new Rectangle(_width - _padding.right, _padding.top, crb.width, crb.height), dest);
			blb.copyPixels(_bitmap.bitmapData, new Rectangle(0, _height - _padding.bottom, blb.width, blb.height), dest);
			bcb.copyPixels(_bitmap.bitmapData, new Rectangle(_padding.left, _height - _padding.bottom, bcb.width, bcb.height), dest);
			brb.copyPixels(_bitmap.bitmapData, new Rectangle(_width - _padding.right, _height - _padding.bottom, brb.width, brb.height), dest);
			
			tl.addChild(new Bitmap(tlb));
			tc.addChild(new Bitmap(tcb, "auto", true));
			tr.addChild(new Bitmap(trb));
			cl.addChild(new Bitmap(clb));
			cc.addChild(new Bitmap(ccb, "auto", true));
			cr.addChild(new Bitmap(crb));
			bl.addChild(new Bitmap(blb));
			bc.addChild(new Bitmap(bcb, "auto", true));
			br.addChild(new Bitmap(brb));
			
			this.addChild(tl);
			this.addChild(tc);
			this.addChild(tr);
			this.addChild(cl);
			this.addChild(cc);
			this.addChild(cr);
			this.addChild(bl);
			this.addChild(bc);
			this.addChild(br);
		}
	}
}