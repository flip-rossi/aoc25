package lib.java;

public class Point2D {
    public long x;
    public long y;

    public Point2D(long x, long y) {
        this.x = x;
        this.y = y;
    }

    static public Point2D of(long x, long y) {
        return new Point2D(x, y);
    }

    static public Point2D of(String xStr, String yStr) {
        return Point2D.of(Integer.parseInt(xStr), Integer.parseInt(yStr));
    }

    static public Point2D ofSplit(String xyStr, String splitRegex) {
        var split = xyStr.split(splitRegex);
        return Point2D.of(Integer.parseInt(split[0]), Integer.parseInt(split[1]));
    }

    @Override
    public boolean equals(Object obj) {
        return obj == null
               ? false
               : this == obj
                 ? true
                 : obj instanceof Point2D other
                   ? this.x == other.x && this.y == other.y
                   : false;
    }

    @Override
    public String toString() {
        return "(" + x + "," + y + ")";
    }

    public String toString(String l, String sep, String r) {
        return l + x + sep + y + r;
    }
}
