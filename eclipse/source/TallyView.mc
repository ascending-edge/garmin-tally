/**
 * @author Greg Rowe <greg.rowe@ascending-edge.com>
 *
 * This class handles the drawing of the Tally view.
 * 
 * Copyright (c) 2017, 2018 Ascending Edge, LLC.
 */
using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Application as App;


/** 
 * Draws the Tally widget view
 */
class TallyView extends Ui.View 
{
     const LABEL_FONT = Gfx.FONT_SYSTEM_MEDIUM;
     
     /// Ascending Edge Logo
	var m_logo = null;

     /// This is the label for the widget name, Tally
	var m_labelApp = null;

     /// This is the counter value.
     var m_labelCounter = null;

     // These are the widgets that make up the legend
     var m_labelInc = null;
     var m_labelDec = null;
     var m_labelReset = null;
     var m_label2x = null;

     /// This is for convenience to avoid calling getApp() over and
     /// over
     var m_app = null;

     
     function initialize() 
     {
          System.println("initialize");          
          m_logo = new WatchUi.Bitmap({
                    :rezId => Rez.Drawables.LauncherIcon,
                         :locX => WatchUi.LAYOUT_HALIGN_CENTER,
                         :locY => WatchUi.LAYOUT_VALIGN_BOTTOM,
                         });
          
          var name = Ui.loadResource(Rez.Strings.AppName);
          m_labelApp = new WatchUi.Text({
                    :text => name,
                         :color => Graphics.COLOR_BLACK,
                         :font => Gfx.FONT_SYSTEM_LARGE,
                         :locX => WatchUi.LAYOUT_HALIGN_CENTER,
                         :locY => 10});
          m_labelCounter = new WatchUi.Text({
                    :color => Graphics.COLOR_BLACK,
                         :font => Gfx.FONT_SYSTEM_NUMBER_THAI_HOT,
                         :locX => WatchUi.LAYOUT_HALIGN_CENTER,
                         :locY => WatchUi.LAYOUT_VALIGN_CENTER});

          m_labelInc = new WatchUi.Text({
                    :text => "+",
                         :color => Graphics.COLOR_BLACK,
                         :font => LABEL_FONT,
                         :justification =>
                         Gfx.TEXT_JUSTIFY_LEFT
                         | Gfx.TEXT_JUSTIFY_VCENTER});
          m_labelDec = new WatchUi.Text({
                    :text => "-",
                         :color => Graphics.COLOR_RED,
                         :font => LABEL_FONT,
                         :justification =>
                         Gfx.TEXT_JUSTIFY_LEFT
                         | Gfx.TEXT_JUSTIFY_VCENTER});
          m_labelReset = new WatchUi.Text({
                    :text => "0",
                         :color => Graphics.COLOR_BLACK,
                         :font => LABEL_FONT,
                         :justification =>
                         Gfx.TEXT_JUSTIFY_RIGHT
                         | Gfx.TEXT_JUSTIFY_VCENTER});
          m_label2x = new WatchUi.Text({
                    :text => "2x",
                         :color => Graphics.COLOR_BLACK,
                         :font => LABEL_FONT,
                         :justification =>
                         Gfx.TEXT_JUSTIFY_RIGHT
                         | Gfx.TEXT_JUSTIFY_VCENTER});
          
          m_app = App.getApp();
          View.initialize();
     }


     /**
      * This finds the coordinates of a point on the circumference of
      * a circle.  This is used here to find the correct location of
      * the legend labels.
      *
      * @param angle which point on the circle (0 is 3 o'clock and it
      * goes clockwise thus 6 o'clock is 900).
      *
      * @param x x position of center of circle
      *
      * @param y y position of center of circle
      *
      * @param radius the size of the circle
      *
      * @return an array of 2 points: x,y representing the position on
      * the circle
      * 
      */
     function circleXY(angle, x, y, radius)
     {
          // x = center_x + radius * cos(angle)
          // y = center_y + radius * sin(angle)
          var coord = new[2];
          var angle_radians = angle * Math.PI / 180;
          coord[0] = x + radius * Math.cos(angle_radians);
          coord[1] = y + radius * Math.sin(angle_radians);
          return coord;
     }

     
     function onLayout(dc)
     {
          System.println("onLayout");
          
          var width = dc.getWidth();
          var height = dc.getHeight();
          var halfWidth = width / 2;
          var halfHeight = height / 2;

          // visual padding
          var pad = 5;
          
          var xy = circleXY(180, halfWidth, halfHeight, halfWidth);
          m_labelInc.setLocation(xy[0] + pad, xy[1]);

          xy = circleXY(150, halfWidth, halfHeight, halfWidth);
          m_labelDec.setLocation(xy[0] + pad, xy[1]);

          xy = circleXY(30, halfWidth, halfHeight, halfWidth);
          m_labelReset.setLocation(xy[0] - pad, xy[1]);

          xy = circleXY(330, halfWidth, halfHeight, halfWidth);
          m_label2x.setLocation(xy[0] - pad, xy[1] + pad);
     }


     /**
      * Draws the labels that mark the buttons.  This varies based on
      * mode.
      */
     function drawLegend(dc)
     {
          if(m_app.getMode() == m_app.MODE_ADJUST)
          {
               m_labelInc.draw(dc);
               m_labelDec.draw(dc);
               m_labelReset.draw(dc);
               m_label2x.setText("Cancel");
          }
          else
          {
               m_label2x.setText("2x");
          }
          m_label2x.draw(dc);          
     }

     
     /**
      * This draws the screen.
      */
     function onUpdate(dc) 
     {
          //System.println("update");
          m_labelCounter.setText(m_app.getCount().format("%d"));
          
          // clear the screen
          dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);
          dc.clear();

          m_labelApp.draw(dc);
          m_labelCounter.draw(dc);
		        
          drawLegend(dc);
          m_logo.draw(dc);
     }
}
