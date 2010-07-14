package com.thelab.hotel32.common
{
	import com.greensock.TweenMax;
	import com.thelab.hotel32.assets.NewTabAsset;
	import com.thelab.hotel32.helpers.Logger;
	import com.thelab.hotel32.views.BasicView;
	import com.thelab.hotel32.views.ViewController;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import org.osflash.signals.DeluxeSignal;
	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeMappedSignal;
	import org.osflash.signals.natives.NativeRelaySignal;
	import org.osflash.signals.natives.NativeSignal;
	
	public class NewTab extends Sprite
	{
		private var asset 								: MovieClip;
		public var index								: uint;
		private var rolledOver							: NativeSignal;
		private var rolledOut							: NativeSignal;
		private var clicked 							: NativeSignal;
		public var clickedSender						: Signal;
		
		public var tabWidth								: Number;
		
		private var label								: MovieClip;
		private var over								: MovieClip;
		private var out									: MovieClip;
		
		private var _selected							: Boolean;
		public var view									: BasicView;
		private var _active								: Boolean;
		
		public function NewTab(name:String, width:Number=86)
		{
			tabWidth = width;
			this.name = name;
			if (stage) { init(); } else { addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true); }
		}
		
		override public function toString():String
		{
			return "[Tab id: " + name + "]";
		}
		
		private function init(e:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			mouseChildren = false;
			
			asset = new NewTabAsset();
			addChild(asset);
			
			over = asset.labelClip.over;
			over.tf.autoSize = TextFieldAutoSize.CENTER;
			out = asset.labelClip.out;
			out.tf.autoSize = TextFieldAutoSize.CENTER;
			
			var format:TextFormat = out.tf.getTextFormat();
			out.tf.text = name;
			out.tf.setTextFormat(format);
		
			format = over.tf.getTextFormat();
			over.tf.text = name;
			over.tf.setTextFormat(format);
			
			tabWidth = over.width + 10;
			if (tabWidth < 90) { tabWidth = 86; }
			asset.bgClip.width = tabWidth;
			asset.selectedClip.width = tabWidth;
			asset.shadowClip.width = tabWidth;
			asset.shadowMaskClip.width = tabWidth;
			asset.borderRight.x = tabWidth-1;
			asset.borderTop.width = tabWidth;
			asset.borderBottom.width = tabWidth;
			
			asset.labelClip.x = Math.round(tabWidth * .5);
			
			rolledOver = new NativeSignal(this, MouseEvent.ROLL_OVER, MouseEvent);
			rolledOut = new NativeSignal(this, MouseEvent.ROLL_OUT, MouseEvent);
			clicked = new NativeSignal(this, MouseEvent.CLICK, MouseEvent);
			
			clickedSender = new Signal();
			
			selected = false;
		}
		
		private function doClicked(e:MouseEvent):void
		{
			if (!selected) { clickedSender.dispatch(this); }
		}
		
		private function doRolledOver(e:MouseEvent):void
		{
			if (!selected) { hilite(true); }
		}
		
		private function doRolledOut(e:MouseEvent):void
		{
			if (!selected) { hilite(false); }
		}
		
		private function hilite(val:Boolean):void
		{
			if (val)
			{
				out.visible = false;
				over.visible = true;
			}
			else
			{
				out.visible = true;
				over.visible = false;
			}
			TweenMax.to(asset.labelClip, .25, { alpha: (val) ? 1 : 0.7 } );
		}
		
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void
		{
			_selected = value;
			hilite(_selected);
			if (_selected)
			{
				asset.borderTop.visible = true;
				asset.borderBottom.visible = false;
				asset.borderLeft.visible = true;
				asset.borderRight.visible = true;
				
				rolledOver.remove(doRolledOver);
				rolledOut.remove(doRolledOut);
				clicked.remove(doClicked);
				useHandCursor = false;
				buttonMode = false;
				
				asset.selectedClip.visible = true;
			}
			else
			{
				asset.borderTop.visible = false;
				asset.borderBottom.visible = true;
				asset.borderLeft.visible = false;
				asset.borderRight.visible = false;
				
				rolledOver.add(doRolledOver);
				rolledOut.add(doRolledOut);
				clicked.add(doClicked);
				useHandCursor = true;
				buttonMode = true;
				
				asset.selectedClip.visible = false;
			}
		}
	}
}