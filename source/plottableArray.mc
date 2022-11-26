using Toybox.Time;

class PlottableArray
{
    public var min;
    public var max; 

    public var data;
    
    public var capacity;

    public var INVALID;

    function initialize(invalidData, capacity)
    {
        min = 2000;
        max = -1;
        data = [];
        capacity = capacity;

        INVALID = invalidData;
    }
    
    function addInvalidData(item as Numeric)
    {
        data.add(item);
    }

    function add(item as Numeric, when as Time.Moment)
    {
        if(when != null && data.size() == capacity)
        {
            
        }

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