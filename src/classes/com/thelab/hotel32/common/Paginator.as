package com.thelab.hotel32.common
{
	import com.greensock.TweenMax;
	import com.thelab.hotel32.helpers.Logger;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeSignal;
	
	public class Paginator extends Sprite
	{
		private var pageButtonArray							: Array;
		private var _selectedPage							: PageButton;
		private var _count									: uint;
		
		private var hotspot									: Sprite;
		private var timer									: Timer;
		
		public var timerOffSignal							: NativeSignal;
		public var timerOnSignal							: NativeSignal;
		
		public var hideCompleted							: Signal;
		
		public var selectedSender							: Signal;
		
		public function Paginator(name:String="")
		{
			this.name = name;
			selectedSender = new Signal(PageButton);
			pageButtonArray = new Array();
			visible = false;
			alpha = 0;
			hideCompleted = new Signal();
			if (stage) { init(); } else { addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true); }
		}
		
		override public function toString():String
		{
			return "[Paginator id: " + name + "]";
		}
		
		private function init(e:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			hotspot = new Sprite();
			timerOffSignal = new NativeSignal(this, MouseEvent.ROLL_OVER, MouseEvent);
			timerOffSignal.add(stopTimer);
			timerOnSignal = new NativeSignal(this, MouseEvent.ROLL_OUT, MouseEvent);
			timerOnSignal.add(startTimer);
			
			timer = new Timer(6000);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
		}
		
		public function stopTimer(e:MouseEvent=null):void
		{
			//Logger.log("stopping timer");
			timer.stop();
		}

		public function startTimer(e:MouseEvent=null):void
		{
			//Logger.log("starting timer");
			timer.start();
		}
		
		public function get count():uint
		{
			return _count;
		}
		
		public function set count(val:uint):void
		{
			
			hideCompleted.addOnce( function() 
			{
				
				_count = val;
				var pb:PageButton;
				// erase any existing buttons
				if (pageButtonArray.length > 0)
				{
					for each (pb in pageButtonArray)
					{
						removeChild(pb);
					}
					pageButtonArray = [];
				}
				
				// rebuild the button list
				for (var i:uint=0; i<_count; i++)
				{
					pb = new PageButton(name + "-" + i);
					addChild(pb);
					pb.index = i+1;
					pb.x = - ((pb.width * i) + i) ;
					pb.x = -(_count*(pb.width) - ((pb.width)*i));
					pb.clickedSender.add(onPageButtonClicked);
					pageButtonArray.push(pb);
				}
				
				selectedPage = pageButtonArray[0];
				
				pb = null;
				
				addChildAt(hotspot, 0);
				hotspot.graphics.clear();
				hotspot.graphics.beginFill(0x00FF00, 0);
				hotspot.graphics.drawRect(-(width+14), -14, width+28, height+28);
				
//				if (count > 1) { show(); }
				
			} );
			
			hide();
		}
		
		private function onPageButtonClicked(which:PageButton):void
		{
			selectedPage = which;
		}
		
		public function get selectedPage():PageButton
		{
			return _selectedPage;
		}
		
		public function set selectedPage(which:PageButton):void
		{
			if (_selectedPage) { _selectedPage.selected = false; }
			_selectedPage = which;
			_selectedPage.selected = true;
			selectedSender.dispatch(which);
		}
		
		private function onTimer(e:TimerEvent):void
		{
			//Logger.log("selectedPage = " + _selectedPage);
			var page:uint = _selectedPage.index;
			(page == _count) ? page = 1 : page ++;
			selectedPage = pageButtonArray[page-1];
		}
		
		public function hide():void
		{
			TweenMax.to(this, .15, { autoAlpha: 0, onComplete: function() { hideCompleted.dispatch(); } } );
			stopTimer();
		}
		
		public function show():void
		{
			if (count > 1)
			{
				TweenMax.to(this, .5, { autoAlpha: 1 } );
				startTimer();
			}
		}
	}
}