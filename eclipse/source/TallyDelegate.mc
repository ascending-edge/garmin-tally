/**
 * @author Greg Rowe <greg.rowe@ascending-edge.com>
 *
 * Copyright (c) 2017, 2018 Ascending Edge, LLC.
 */
using Toybox.System;
using Toybox.WatchUi;
using Toybox.Application;

/**
 * This application class holds the model for the Tally widget.
 */
class TD2 extends MultiPressDelegate
{
     /// Easy access to the application instance.
	var m_app = null;

     
     function initialize() 
     {
          MultiPressDelegate.initialize(300);
          m_app = Application.getApp();
     }


     /**
      * This is called when select is pressed.  This is how we handle
      * double-press events on the select button.
      *
      * @param pressCount the number of times it was pressed
      */
     function onMultiSelect(pressCount)
     {
          System.println("select: " + pressCount);
          if(pressCount == 1)
          {
               // The start/stop button was pressed only one time.
               if(m_app.getMode() == m_app.MODE_ADJUST)
               {
                    m_app.setMode(m_app.MODE_VIEW);
                    WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
                    return;
               }

               m_app.setMode(m_app.MODE_ADJUST);
               WatchUi.pushView(new TallyView(), self, WatchUi.SLIDE_IMMEDIATE);
               return;
          }
          
          m_app.add(pressCount / 2);
          WatchUi.requestUpdate();
     }


     private function howMuch(pressCount)
     {
          var value = 1;
          if(pressCount > 1)
          {
               value = pressCount / 2;
          }
          return value;
     }


     private function adjustCounter(value)
     {
          if(m_app.getMode() == m_app.MODE_VIEW)
          {
               return false;
          }
          if(value == 0)
          {
               m_app.reset();
          }
          else
          {
               m_app.add(value);
          }
          WatchUi.requestUpdate();
          return true;
     }


     /** 
      * When in viewing mode pass the input on unhandled.  When in
      * adjustment mode decrement the counter and return to viewing
      * mode.
      */
     function onNextPage() 
     {
          return adjustCounter(-1);
     }


     /** 
      * When in viewing mode pass the input on unhandled.  When in
      * adjustment mode increment the counter and return to viewing
      * mode.
      */
     function onPreviousPage() 
     {
          return adjustCounter(1);
     }


     /** 
      * When in viewing mode pass the input on unhandled.  When in
      * adjustment zero the counter and return to viewing mode.
      */
     function onBack()
     {
          return adjustCounter(0);
     }
}
