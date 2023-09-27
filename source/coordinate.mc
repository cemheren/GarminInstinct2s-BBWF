import Toybox.Graphics; 

class Coordinate
{
    public var X;
    public var Y;

    public var W;

    function initialize(x, y)
    {
        X = x;
        Y = y;
    }

    function drawLargeTextAt(dc, text)
    {
        dc.drawText(
            X,                      // gets the width of the device and divides by 2
            Y,                     // gets the height of the device and divides by 2
            Graphics.FONT_NUMBER_THAI_HOT,                    // sets the font size
            text,                             // the String to display
            Graphics.TEXT_JUSTIFY_CENTER            // sets the justification for the text
        );
    }

    function drawSmallTextAt(dc, text)
    {
        dc.drawText(
            X,                      // gets the width of the device and divides by 2
            Y,                     // gets the height of the device and divides by 2
            2,                    // sets the font size
            text,                             // the String to display
            Graphics.TEXT_JUSTIFY_CENTER            // sets the justification for the text
        );
    }

    function drawTinyTextAt(dc, text)
    {
        dc.drawText(
            X,                      // gets the width of the device and divides by 2
            Y,                     // gets the height of the device and divides by 2
            0,                    // sets the font size
            text,                             // the String to display
            Graphics.TEXT_JUSTIFY_CENTER            // sets the justification for the text
        );
    }

    function drawHorizontalLineForPercentileFromRight(dc, width, maxLength, fraction)
    {
        if(fraction >= 1)
        {
            fraction = 1;
        }

        dc.setPenWidth(width);
        dc.drawLine(X + (maxLength * fraction), Y, X + maxLength, Y);
    }

    function drawHorizontalLineForPercentile(dc, width, maxLength, fraction)
    {
        if(fraction >= 1)
        {
            fraction = 1;
        }

        dc.setPenWidth(width);
        dc.drawLine(X, Y, X + (maxLength * fraction), Y);
    }

    function drawVerticalLineForPercentile(dc, width, maxLength, fraction)
    {
        if(fraction >= 1)
        {
            fraction = 1;
        }

        dc.setPenWidth(width);
        dc.drawLine(X - 1, Y, X - 1, Y - (maxLength * fraction));
    }

    function drawPointWithOffset(dc, XOffset, penWidth)
    {
        dc.setPenWidth(penWidth);
        dc.drawPoint(X + XOffset, Y);
    }

    function drawPointWithYOffset(dc, YOffset, penWidth)
    {
        dc.setPenWidth(penWidth);
        // dc.drawPoint(X, Y - YOffset);

        dc.drawLine(X - 1, Y - YOffset, X + 2, Y - YOffset);
    }

    function drawHorizontalLine(dc, width, length)
    {
        dc.setPenWidth(width);
        dc.drawLine(X, Y, X + length, Y);
    }

    function drawVerticalLine(dc, width, length)
    {
        dc.setPenWidth(width);
        dc.drawLine(X, Y, X, Y + length);
    }

    function drawPercentageCurvedBarChart(dc, height as Double, width as Double, data as PlottableArray)
    {
        if(data.size() <= 0){return;}

        var min = 0;
        var max = 100;

        // degrees start from 180 and go to 360
        var r = 24;
        var rLen = 180;
        var interval = rLen / (data.data.size() - 1);
        var leftAngle = 180;

        dc.setPenWidth(1);
        // dc.drawLine(X - 4, Y, X - 4, Y + height);
        // dc.drawLine(X - 4, Y, X - 2 + width, Y);

        dc.drawArc(X, Y, r, 0, leftAngle, leftAngle + rLen);

        dc.setPenWidth(1);

        var bottomY = Y + height;
        var onePercent = r / (max - min);

        for (var i = 0; i < data.size(); ++i) 
        {
            var item = data.data[i];
            var itemScale = 1 - (item/100.0);

            var angle = Math.toRadians(leftAngle + (i * interval));
            var x_for_i = X - r * Math.cos(angle);
            var y_for_i = Y - r * Math.sin(angle);

            var topX = X + ((x_for_i - X) * itemScale);
            var topY = Y + ((y_for_i - Y) * itemScale);

            dc.drawLine(x_for_i, y_for_i, topX, topY);
        }
    }

    function drawPercentageBarChart(dc, height as Double, width as Double, data as PlottableArray, penWidth)
    {
        if(data.data.size() <= 0){return;}

        var min = 0;
        var max = 100;

        dc.setPenWidth(1);
        dc.drawLine(X - 4, Y, X - 4, Y + height + 1);
        dc.drawLine(X - 4, Y, X - 2 + width, Y);

        dc.setPenWidth(penWidth);
        
        var bottomY = Y + height;

        var interval = width / data.data.size();
        var onePercent = height / (max - min);

        for (var i = 0; i < data.data.size(); ++i) 
        {
            var item = data.data[i];
            var itemHeight = onePercent * item;

            var leftShift = interval * i;

            dc.drawLine(X + leftShift, bottomY, X + leftShift, bottomY - itemHeight);
        }
    }

    function drawArray(dc, height as Double, data as PlottableArray, minOverride, maxOverride, currentValue as Number)
    {
        var max = data.max > maxOverride ? data.max : maxOverride;
        var min = data.min < minOverride ? data.min : minOverride;
        var diff = (max - min);
        var oneHR = height / diff;

        // draw the left bar 
        dc.setPenWidth(1);

        var eightyP = Y + ((max - 80) * oneHR);
        dc.drawLine(X - 1, eightyP, X + 2, eightyP);


        var oneTwentyP = Y + ((max - 110) * oneHR);
        dc.drawLine(X - 1, oneTwentyP, X + 2, oneTwentyP);

        // draw vertical
        dc.drawLine(X - 1, oneTwentyP, X - 1, eightyP);

        // add current val to the vertical bar
        var currentValueP = max < currentValue ? Y : Y + ((max - currentValue) * oneHR);
        dc.drawLine(X - 1, currentValueP, X + 2, currentValueP);

        dc.setPenWidth(2);

        var prevX = -1;
        var prevY = -1;

        var dX = X + 5;

        for (var i = 0; i < data.data.size() && i + dX <= 156; ++i) 
        {
            var item = data.data[i];

            if(item == data.INVALID)
            {
                continue;
            }

            var hrDiffFromMax = max - item;

            var currentHR = oneHR * hrDiffFromMax;

            if(prevX == -1)
            {
                prevX = dX + i;
                prevY = Y + currentHR;
                dc.drawPoint(dX + i, Y + currentHR);
                continue;
            }

            dc.drawLine(prevX, prevY, dX + i, Y + currentHR);
            prevX = dX + i;
            prevY = Y + currentHR;
        }
    }
}