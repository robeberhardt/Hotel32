package com.thelab.hotel32.common
{
	import com.greensock.TweenMax;
	import com.thelab.hotel32.assets.CaretAsset;

	import com.thelab.hotel32.assets.fonts.FontLibrary;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeSignal;
	
	// Library imports
	import com.thelab.hotel32.assets.ToolTipAsset;
	
	public class ToolTip extends Sprite
	{
		private var over									: NativeSignal;
		private var out										: NativeSignal;
		private var clicked									: NativeSignal;
		public var ready									: Signal;
		public var clickedSender							: Signal;
		
		public var asset									: MovieClip;
		private var caret									: MovieClip;
		
		private var format									: TextFormat;
		private var field									: TextField;
		private var fieldWidth								: Number;
		
		private var _active									: Boolean;
		private var _text									: String;
		
		public function ToolTip(text:String)
		{
			over = new NativeSignal(this, MouseEvent.ROLL_OVER, MouseEvent);
			out = new NativeSignal(this, MouseEvent.ROLL_OUT, MouseEvent);
			clicked = new NativeSignal(this, MouseEvent.CLICK, MouseEvent);
			ready = new Signal();
			clickedSender = new Signal();
			_text = text;
			
			if (stage) { init(); } else { addEventListener(Event.ADDED_TO_STAGE, init); }
		}
		
		private function init(e:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			visible = false;
			alpha = 0;
			mouseChildren = false;
			buttonMode = true;
			
			asset = new ToolTipAsset();
			addChild(asset);
			
			format = new TextFormat();
			format.letterSpacing = 2;
			format.font = FontLibrary.FUTURA_MEDIUM_FORMAT;
			format.size = 14;
			format.color = 0xFFFFFF;
			format.align = TextFormatAlign.CENTER;
			
			field = new TextField();
			field.antiAliasType = AntiAliasType.ADVANCED;
			field.autoSize = TextFieldAutoSize.CENTER;
			field.embedFonts = true;
			field.selectable = false;
			field.defaultTextFormat = format;
			field.x = -9;
			field.y = -35;
			addChild(field);
			
			caret = new CaretAsset();
			addChild(caret);
			caret.y = -25;
			
			text = _text;
			
			setup();
		}
		
		public function setup():void
		{
			ready.dispatch();
		}
		
		private function onClicked(e:MouseEvent):void
		{
			clickedSender.dispatch();
		}

		public function get active():Boolean
		{
			return _active;
		}

		public function set active(value:Boolean):void
		{
			_active = value;
			if (_active)
			{
//				over.add(onOver);
//				out.add(onOut);
				clicked.add(onClicked);
				useHandCursor = true;
			}
			else
			{
//				over.remove(onOver);
//				out.remove(onOut);
				clicked.remove(onClicked);
				useHandCursor = false;
			}
		}
		
		public function set text(val:String):void
		{
			_text = val;
			field.text = _text;
			asset.fill.scaleX = (field.width + 14) * 0.02;
			field.x = -Math.round((field.width * 0.5)) - 5;
			caret.x = Math.round(field.width * .5) + 1;
		}
		
		public function show(d:Number=0):void
		{
			TweenMax.to(this, .25, { delay: d, autoAlpha: 1 });
			active = true;
		}
		
		public function hide():void
		{
			TweenMax.to(this, .25, { autoAlpha: 0 });
			active = false;
		}
	}
}