using Toybox.Time;

class PlottableArray
{
    public var min;
    public var max; 

    public var data;
    
    public var INVALID;

    function initialize(invalidData)
    {
        min = 2000;
        max = -1;
        data = [];

        INVALID = invalidData;
    }
    
    function addInvalidData(item as Numeric)
    {
        data.add(item);
    }

    function add(item as Numeric)
    {
        if(min > item)
        {
            min = item;
        }

        if(max < item)
        {
            max = item;
        }

        data.add(item);
        return true;
    }
}