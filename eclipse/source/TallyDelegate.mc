/**
 * @author Greg Rowe <greg.rowe@ascending-edge.com>
 *
 * This class handles the button presses/actions for the Tally widget.
 * 
 * Copyright (c) 2017 Ascending Edge, LLC.
 */
using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Application as App;


/** 
 * This class handles the button presses/actions for the Tally widget.
 *
 * There are two modes: viewing, and editing mode.  The viewing mode
 * shows the current count value.  The adjustment mode allows
 * adjustment of the counter.
 */
class TallyDelegate extends Ui.BehaviorDelegate 
{
     /// Easy access to the application instance.
	var m_app = null;


     function initialize() 
     {
          BehaviorDelegate.initialize();
          m_app = App.getApp();
     }

     
     /** 
      * When in viewing mode pass the input on unhandled.  When in
      * adjustment mode decrement the counter and return to viewing
      * mode.
      */
     function onNextPage() 
     {
          System.println("next page");
          if(m_app.getMode() == m_app.MODE_VIEW)
          {
               return false;
          }
          m_app.dec();
          m_app.setMode(m_app.MODE_VIEW);
          Ui.popView(Ui.SLIDE_IMMEDIATE);
          return true;
     }


     /** 
      * When in viewing mode pass the input on unhandled.  When in
      * adjustment mode increment the counter and return to viewing
      * mode.
      */
     function onPreviousPage() 
     {
          System.println("prev page");
		if(m_app.getMode() == m_app.MODE_VIEW)
		{
			return false;
		}
		m_app.inc();
		m_app.setMode(m_app.MODE_VIEW);
          Ui.popView(Ui.SLIDE_IMMEDIATE);
          return true;
     }


     /** 
      * This is called when the back/lap button is pressed.  If the
      * widget is in viewing mode it will exit by letting the system
      * handle the input.  When in adjustment mode this will reset the
      * counter to zero and return to viewing mode.
      */
     function onBack() 
     {
          System.println("back");
          if(m_app.getMode() == m_app.MODE_VIEW)
          {
               System.println("exiting");
               return false;
          }
          m_app.setMode(m_app.MODE_VIEW);
          // Reset the counter
          m_app.reset();
		Ui.popView(Ui.SLIDE_IMMEDIATE);
          return true;
     }


     /** 
      * This is called when the start/stop button is pressed.  This
      * toggles the mode between adjustment and viewing modes.
      */
     function onSelect() 
     {
          System.println("select");
          if(m_app.getMode() == m_app.MODE_ADJUST)
          {
               m_app.setMode(m_app.MODE_VIEW);
               Ui.popView(Ui.SLIDE_IMMEDIATE);
               return true;
          }
          m_app.setMode(m_app.MODE_ADJUST);
          Ui.pushView(new TallyView(), self, Ui.SLIDE_IMMEDIATE);
          return true;
     }
}
